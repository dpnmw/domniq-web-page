# frozen_string_literal: true

module DomniqWebPage
  class AdminConfigsController < ::Admin::AdminController
    requires_plugin DomniqWebPage::PLUGIN_NAME

    def show
      type = params[:config_type]
      raise Discourse::NotFound unless allowed_types.include?(type)

      configs = Config.for_type(type).order(:config_key)
      render json: { configs: serialize(configs) }
    end

    def bulk_update
      type = params[:config_type]
      raise Discourse::NotFound unless allowed_types.include?(type)

      # Server-side license enforcement — reject writes to locked config types/keys
      if defined?(DomniqWebPage::LicenseChecker)
        if DomniqWebPage::LicenseChecker.config_locked?(type)
          render json: { errors: ["This section requires a valid licence."] }, status: :forbidden
          return
        end
      end

      known_keys = Config.for_type(type).pluck(:config_key).to_set

      errors = []
      (params[:configs] || {}).each do |key, value|
        key_str = key.to_s

        # Reject keys that were not seeded — prevents arbitrary key injection
        unless known_keys.include?(key_str)
          errors << "#{key_str}: unknown config key"
          next
        end

        # Reject individual locked keys within partially locked types
        if defined?(DomniqWebPage::LicenseChecker) &&
           DomniqWebPage::LicenseChecker.config_locked?(type, key_str)
          errors << "#{key_str}: requires a valid licence"
          next
        end

        value_str = value.to_s.slice(0, 10_000)
        record = Config.find_or_initialize_by(config_type: type, config_key: key_str)
        record.config_value = value_str
        record.enabled = true
        errors << "#{key_str}: #{record.errors.full_messages.join(', ')}" unless record.save
      end

      if errors.any?
        render json: { errors: errors }, status: :unprocessable_entity
      else
        render json: success_json
      end
    end

    private

    def allowed_types
      DomniqWebPage::Config::VALID_TYPES
    end

    def serialize(configs)
      configs.map { |c|
        { config_type: c.config_type, config_key: c.config_key,
          config_value: c.config_value, enabled: c.enabled }
      }
    end
  end
end
