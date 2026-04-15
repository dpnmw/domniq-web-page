# frozen_string_literal: true

require "ipaddr"

module DomniqWebPage
  class LicenseChecker
    CACHE_KEY = "dwp_license_status"
    CACHE_TTL = 86_400 # 24 hours
    REMOTE_URL = "https://api.dpnmediaworks.com/api/check"

    BLOCKED_HOSTS = %w[
      localhost
      127.0.0.1
      0.0.0.0
      ::1
    ].freeze

    PRIVATE_RANGES = [
      IPAddr.new("10.0.0.0/8"),
      IPAddr.new("172.16.0.0/12"),
      IPAddr.new("192.168.0.0/16"),
    ].freeze

    def self.licensed?
      result = check
      result && result["license_active"] == true
    end

    def self.check(force: false)
      domain = current_domain

      return blocked_result(domain) if blocked_domain?(domain)

      unless force
        cached = read_cache
        if cached && !cache_expired?(cached)
          return cached
        end
      end

      key = license_key
      if key.blank?
        result = {
          "license_active" => false,
          "domain" => domain,
          "error" => "No license key configured",
          "checked_at" => Time.now.iso8601,
        }
        store_result(result)
        send_heartbeat(result) if force && SiteSetting.respond_to?(:domniq_web_telemetry_enabled) && SiteSetting.domniq_web_telemetry_enabled
        return result
      end

      result = remote_check(domain, key)
      store_result(result)
      send_heartbeat(result) if force && SiteSetting.respond_to?(:domniq_web_telemetry_enabled) && SiteSetting.domniq_web_telemetry_enabled
      result
    end

    def self.badge_hidden?
      licensed?
    rescue StandardError
      false
    end

    def self.license_key
      PluginStore.get(DomniqWebPage::PLUGIN_NAME, "license_key")
    end

    def self.activate(key)
      PluginStore.set(DomniqWebPage::PLUGIN_NAME, "license_key", key)
      check(force: true)
    end

    def self.license_key_masked
      key = license_key
      return nil if key.blank?
      return key if key.length <= 8
      key[0..3] + ("*" * (key.length - 8)) + key[-4..]
    end

    def self.expires_at
      cached = read_cache
      cached&.dig("expires_at")
    end

    def self.current_domain
      URI.parse(Discourse.base_url).host
    rescue StandardError
      "unknown"
    end

    # Locked config types — sections behind the license
    LOCKED_SECTION_TYPES = %w[stats about leaderboard topics faq app_cta].freeze
    LOCKED_ACCORDION_KEYS = {
      "hero" => %w[
        hero_bg_effect hero_background_overlay hero_overlay_color hero_overlay_opacity
        hero_video_url hero_video_button_color hero_video_button_position hero_video_blur_on_hover
        contributors_enabled contributors_title_enabled contributors_title contributors_count_label_enabled
        contributors_count_label contributors_alignment contributors_days contributors_count
        contributors_pill_max_width contributors_pill_bg_dark contributors_pill_bg_light
        hero_bg_dark hero_bg_light hero_min_height hero_border_style
      ],
      "design" => %w[
        google_font_name title_font_name
        scroll_animation staggered_reveal_enabled dynamic_background_enabled
        mouse_parallax_enabled scroll_progress_enabled
        preloader_enabled preloader_min_duration preloader_bar_color
        preloader_bg_dark preloader_bg_light preloader_text_color_dark preloader_text_color_light
      ],
      "general" => %w[icon_library custom_css],
      "navbar" => %w[
        navbar_bg_color navbar_border_style navbar_text_color_dark navbar_text_color_light
        navbar_icon_color_dark navbar_icon_color_light
        social_twitter_url social_facebook_url social_instagram_url
        social_youtube_url social_tiktok_url social_github_url
      ],
      "footer" => %w[
        footer_border_style footer_bg_dark footer_bg_light
        footer_text_color_dark footer_text_color_light
      ],
    }.freeze

    def self.section_fully_locked?(config_type)
      return false if licensed?
      LOCKED_SECTION_TYPES.include?(config_type)
    end

    def self.config_locked?(config_type, config_key = nil)
      return false if licensed?
      return true if LOCKED_SECTION_TYPES.include?(config_type)
      return false unless LOCKED_ACCORDION_KEYS.key?(config_type)
      return true if config_key.nil?
      LOCKED_ACCORDION_KEYS[config_type].include?(config_key)
    end

    private

    def self.blocked_domain?(domain)
      return true if BLOCKED_HOSTS.include?(domain.downcase)
      begin
        ip = IPAddr.new(domain)
        PRIVATE_RANGES.any? { |range| range.include?(ip) }
      rescue IPAddr::InvalidAddressError
        false
      end
    end

    def self.blocked_result(domain)
      {
        "license_active" => false,
        "domain" => domain,
        "error" => "License validation is not available for local or private domains",
        "checked_at" => Time.now.iso8601,
      }
    end

    def self.remote_check(domain, key)
      response = Excon.post(
        REMOTE_URL,
        body: { license_key: key, domain: domain }.to_json,
        headers: { "Content-Type" => "application/json" },
        connect_timeout: 5,
        read_timeout: 5,
      )

      if response.status == 200
        data = JSON.parse(response.body)
        {
          "license_active" => data["active"] == true,
          "domain" => domain,
          "email" => data["email"],
          "paid_at" => data["paid_at"],
          "expires_at" => data["expires_at"],
          "checked_at" => Time.now.iso8601,
        }
      else
        fallback_result(domain)
      end
    rescue Excon::Error, JSON::ParserError, StandardError => e
      Rails.logger.warn("[DomniqWebPage] License check failed: #{e.message}")
      fallback_result(domain)
    end

    def self.fallback_result(domain)
      cached = read_cache
      if cached && cached["license_active"]
        cached["domain"] = domain
        cached
      else
        {
          "license_active" => false,
          "domain" => domain,
          "checked_at" => Time.now.iso8601,
        }
      end
    end

    def self.read_cache
      PluginStore.get(DomniqWebPage::PLUGIN_NAME, CACHE_KEY)
    end

    def self.store_result(result)
      PluginStore.set(DomniqWebPage::PLUGIN_NAME, CACHE_KEY, result)
    end

    TELEMETRY_URL = "https://api.dpnmediaworks.com/api/telemetry/heartbeat"

    def self.send_heartbeat(result)
      Thread.new do
        begin
          plugin = Discourse.plugins.find { |p| p.metadata.name == "domniq-web-page" }
          Excon.post(
            TELEMETRY_URL,
            body: {
              site_url: Discourse.base_url,
              plugin: "domniq-web-page",
              plugin_version: plugin&.metadata&.version || "unknown",
              platform: "discourse",
              platform_version: Discourse::VERSION::STRING,
              license_key: license_key,
              licensed: result["license_active"] == true,
            }.to_json,
            headers: { "Content-Type" => "application/json" },
            connect_timeout: 5,
            read_timeout: 5,
          )
        rescue StandardError => e
          Rails.logger.warn("[DomniqWebPage] Heartbeat failed: #{e.message}")
        end
      end
    end

    def self.cache_expired?(cached)
      checked_at = cached["checked_at"]
      return true unless checked_at
      Time.parse(checked_at) < Time.now - CACHE_TTL
    rescue StandardError
      true
    end
  end
end
