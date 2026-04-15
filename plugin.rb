# frozen_string_literal: true

# name: domniq-web-page
# about: A Premium Welcome Page Plugin for Discourse by Domniq.app
# version: 2.0.0
# authors: DPN MEDiA WORKS
# url: https://domniq.app

enabled_site_setting :dwp_enabled

register_asset "stylesheets/common/dwp-admin.scss", :admin

add_admin_route "dwp.admin.title", "domniq-web-page", use_new_show_route: true

require_relative "lib/dwp"

after_initialize do
  require_relative "lib/dwp/helpers"
  require_relative "lib/dwp/icons"
  require_relative "lib/dwp/data_fetcher"
  require_relative "lib/dwp/config_builder"
  require_relative "lib/dwp/style_builder"
  require_relative "lib/dwp/page_builder"

  begin
    require_relative "premium/license_checker"
  rescue LoadError
  end

  unless defined?(DomniqWebPage::PageBuilder) &&
         defined?(DomniqWebPage::ConfigBuilder) &&
         SiteSetting.respond_to?(:dwp_enabled)
    Rails.logger.error("[DWP] Critical dependency missing — skipping route registration.")
    next
  end

  Discourse::Application.routes.append { mount ::DomniqWebPage::Engine, at: "/dwp" }

  Discourse::Application.routes.prepend do
    root to: "dwp/landing#index",
         as: "root",
         constraints: ->(req) {
           begin
             !CurrentUser.lookup_from_env(req.env) &&
               SiteSetting.dwp_enabled
           rescue => e
             Rails.logger.error("[DWP] Route constraint error: #{e.message}")
             false
           end
         }
  end
end
