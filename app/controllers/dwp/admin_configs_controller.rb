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

      errors = []
      (params[:configs] || {}).each do |key, value|
        record = Config.find_or_initialize_by(config_type: type, config_key: key.to_s)
        record.config_value = value.to_s
        record.enabled = true
        errors << "#{key}: #{record.errors.full_messages.join(', ')}" unless record.save
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
