# frozen_string_literal: true

module DomniqWebPage
  class Engine < ::Rails::Engine
    isolate_namespace DomniqWebPage
    engine_name PLUGIN_NAME

    def self.safe_to_load?
      defined?(DomniqWebPage::PageBuilder) &&
        defined?(DomniqWebPage::ConfigBuilder) &&
        SiteSetting.respond_to?(:domniq_web_enabled)
    rescue
      false
    end
  end
end
