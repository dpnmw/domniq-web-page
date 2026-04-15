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
      Rails.logger.error(
        "[DWP] Landing page render error: #{e.class}: #{e.message}\n" \
        "#{e.backtrace&.first(15)&.join("\n")}"
      )

      if Rails.env.development?
        bt = e.backtrace&.first(15)&.join("\n") rescue ""
        error_page = <<~HTML
          <!DOCTYPE html>
          <html>
          <head><meta charset="UTF-8"><title>DWP Error</title>
          <style>
            body { font-family: monospace; padding: 2em; background: #111; color: #eee; }
            pre  { background: #1a1a2e; padding: 1em; overflow-x: auto;
                   border-radius: 8px; font-size: 13px; }
          </style>
          </head>
          <body>
          <h1 style="color:#e74c3c">Domniq Web Page Error</h1>
          <p><strong>#{ERB::Util.html_escape(e.class)}</strong>:
             #{ERB::Util.html_escape(e.message)}</p>
          <pre>#{ERB::Util.html_escape(bt)}</pre>
          </body>
          </html>
        HTML
        render html: error_page.html_safe, layout: false,
               content_type: "text/html", status: 500
      else
        redirect_to "/login"
      end
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
