# frozen_string_literal: true

module DomniqWebPage
  class ConfigBuilder
    def self.build
      configs = Config.active
      result = {}

      configs.each do |c|
        result[c.config_type] ||= {}
        result[c.config_type][c.config_key] = parse_value(c.config_value)
      end

      result["uploads"] = upload_urls
      result
    end

    def self.get(config_type, config_key, fallback = "")
      Config.find_by(config_type: config_type, config_key: config_key)
            &.config_value || fallback
    end

    private

    def self.parse_value(value)
      return true  if value == "true"
      return false if value == "false"
      JSON.parse(value)
    rescue JSON::ParserError
      value
    end

    def self.upload_urls
      {
        "og_image"             => url(SiteSetting.domniq_web_og_image),
        "favicon"              => url(SiteSetting.domniq_web_favicon),
        "logo_dark"            => url(SiteSetting.domniq_web_logo_dark),
        "logo_light"           => url(SiteSetting.domniq_web_logo_light),
        "footer_logo"          => url(SiteSetting.domniq_web_footer_logo),
        "hero_bg_image"        => url(SiteSetting.domniq_web_hero_bg_image),
        "hero_image"           => url(SiteSetting.domniq_web_hero_image),
        "about_image"          => url(SiteSetting.domniq_web_about_image),
        "about_bg_image"       => url(SiteSetting.domniq_web_about_bg_image),
        "faq_image"            => url(SiteSetting.domniq_web_faq_image),
        "cta_image"            => url(SiteSetting.domniq_web_cta_image),
        "ios_badge_image"      => url(SiteSetting.domniq_web_ios_badge_image),
        "android_badge_image"  => url(SiteSetting.domniq_web_android_badge_image),
        "preloader_logo_dark"  => url(SiteSetting.domniq_web_preloader_logo_dark),
        "preloader_logo_light" => url(SiteSetting.domniq_web_preloader_logo_light),
      }
    end

    def self.url(upload)
      return nil if upload.blank?
      upload.respond_to?(:url) ? UrlHelper.cook_url(upload.url) : nil
    rescue
      nil
    end
  end
end
