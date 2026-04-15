# frozen_string_literal: true

module DomniqWebPage
  class LandingController < ::ApplicationController
    requires_plugin DomniqWebPage::PLUGIN_NAME

    skip_before_action :check_xhr
    skip_before_action :redirect_to_login_if_required
    skip_before_action :preload_json, raise: false
    content_security_policy false

    def index
      return redirect_to "/login" unless safe_to_render?

      config = DomniqWebPage::ConfigBuilder.build
      html   = DomniqWebPage::PageBuilder.new(config).build

      render html: html.html_safe, layout: false, content_type: "text/html"

    rescue => e
      Rails.logger.error("[DWP] Landing error: #{e.class}: #{e.message}\n#{e.backtrace&.first(10)&.join("\n")}")
      redirect_to "/login"
    end

    private

    def safe_to_render?
      return false unless SiteSetting.dwp_enabled
      return false unless defined?(DomniqWebPage::PageBuilder)
      return false unless ActiveRecord::Base.connection.active?
      true
    rescue
      false
    end
  end
end
