# frozen_string_literal: true

# name: domniq-web-page
# about: A Premium Welcome Page Plugin for Discourse by Domniq.app
# version: 2.0.0
# authors: DPN MEDiA WORKS
# url: https://domniq.app

enabled_site_setting :domniq_web_enabled

register_asset "stylesheets/common/dwp-admin.scss", :admin

add_admin_route "dwp.admin.title", "domniq-web-page", use_new_show_route: true

require_relative "lib/dwp"

UPLOAD_SETTINGS = %w[
  domniq_web_og_image domniq_web_favicon domniq_web_logo_dark domniq_web_logo_light
  domniq_web_footer_logo domniq_web_hero_bg_image domniq_web_hero_image
  domniq_web_about_image domniq_web_about_bg_image domniq_web_faq_image
  domniq_web_cta_image domniq_web_ios_badge_image domniq_web_android_badge_image
  domniq_web_preloader_logo_dark domniq_web_preloader_logo_light
].freeze

register_upload_in_use do |upload|
  UPLOAD_SETTINGS.any? do |setting_name|
    begin
      SiteSetting.public_send(setting_name)&.id == upload.id
    rescue
      false
    end
  end
end

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
         SiteSetting.respond_to?(:domniq_web_enabled)
    Rails.logger.error("[DWP] Critical dependency missing — skipping route registration.")
    next
  end

  Discourse::Application.routes.append { mount ::DomniqWebPage::Engine, at: "/dwp" }

  Discourse::Application.routes.prepend do
    root to: "domniq_web_page/landing#index",
         as: "root",
         constraints: ->(req) {
           begin
             !CurrentUser.lookup_from_env(req.env) &&
               SiteSetting.domniq_web_enabled
           rescue => e
             Rails.logger.error("[DWP] Route constraint error: #{e.message}")
             false
           end
         }
  end
end
