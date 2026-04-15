# frozen_string_literal: true

module DomniqWebPage
  class AdminController < ::Admin::AdminController
    requires_plugin DomniqWebPage::PLUGIN_NAME
    def index; end

    def landing_css
      css_path = File.join(DomniqWebPage::PLUGIN_DIR, "assets", "stylesheets", "dwp", "landing.css")
      css = File.read(css_path) rescue ""
      render json: { css: css }
    end
  end
end
