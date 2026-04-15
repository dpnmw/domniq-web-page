# frozen_string_literal: true

module Jobs
  class DwpHeartbeat < ::Jobs::Scheduled
    every 1.week

    TELEMETRY_URL = "https://api.dpnmediaworks.com/telemetry/heartbeat"

    def execute(args)
      return unless SiteSetting.domniq_web_enabled
      return unless SiteSetting.domniq_web_telemetry_enabled

      payload = {
        site_url: Discourse.base_url,
        plugin: "domniq-web-page",
        plugin_version: plugin_version,
        discourse_version: Discourse::VERSION::STRING,
        license_key: license_key,
        licensed: DomniqWebPage::LicenseChecker.licensed?,
        total_users: User.real.count,
        active_users_30d: User.real.where("last_seen_at > ?", 30.days.ago).count,
      }

      begin
        response = Excon.post(
          TELEMETRY_URL,
          body: payload.to_json,
          headers: {
            "Content-Type" => "application/json",
            "User-Agent" => "DomniqWebPage/#{payload[:plugin_version]}",
          },
          connect_timeout: 5,
          read_timeout: 10,
        )

        Rails.logger.info("[DWP] Heartbeat sent (#{response.status})")
      rescue Excon::Error => e
        Rails.logger.warn("[DWP] Heartbeat failed: #{e.message}")
      end
    end

    private

    def plugin_version
      plugin = Discourse.plugins.find { |p| p.metadata.name == "domniq-web-page" }
      plugin&.metadata&.version || "unknown"
    end

    def license_key
      PluginStore.get(DomniqWebPage::PLUGIN_NAME, "license_key") || ""
    end
  end
end
