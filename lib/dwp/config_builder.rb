# frozen_string_literal: true

module DomniqWebPage
  class ConfigBuilder
    # When unlicensed, locked keys either get a seed default or are turned off.
    # Keys not listed here are simply skipped (nil), which naturally disables them.
    UNLICENSED_OVERRIDES = {
      # Navbar appearance → seed defaults
      ["navbar", "navbar_bg_color"]          => "",
      ["navbar", "navbar_border_style"]      => "none",
      ["navbar", "navbar_text_color_dark"]   => "",
      ["navbar", "navbar_text_color_light"]  => "",
      ["navbar", "navbar_icon_color_dark"]   => "",
      ["navbar", "navbar_icon_color_light"]  => "",
      # Footer appearance → seed defaults
      ["footer", "footer_border_style"]      => "solid",
      ["footer", "footer_bg_dark"]           => "",
      ["footer", "footer_bg_light"]          => "",
      ["footer", "footer_text_color_dark"]   => "",
      ["footer", "footer_text_color_light"]  => "",
      # Typography → seed defaults
      ["design", "google_font_name"]         => "Outfit",
      ["design", "title_font_name"]          => "",
      # Animations → all off
      ["design", "scroll_animation"]         => "none",
      ["design", "staggered_reveal_enabled"] => "false",
      ["design", "dynamic_background_enabled"] => "false",
      ["design", "mouse_parallax_enabled"]   => "false",
      ["design", "scroll_progress_enabled"]  => "false",
      # Hero background → seed defaults (none)
      ["hero", "hero_bg_effect"]             => "none",
      ["hero", "hero_bg_dark"]               => "",
      ["hero", "hero_bg_light"]              => "",
      ["hero", "hero_min_height"]            => "0",
      ["hero", "hero_border_style"]          => "none",
      # Hero overlay → off
      ["hero", "hero_background_overlay"]    => "false",
      # Hero video → off
      ["hero", "hero_video_url"]             => "",
      # Hero contributors → off
      ["hero", "contributors_enabled"]       => "false",
    }.freeze

    def self.build
      configs = Config.active
      result = {}
      unlicensed = defined?(DomniqWebPage::LicenseChecker) && !DomniqWebPage::LicenseChecker.licensed?

      configs.each do |c|
        if unlicensed && DomniqWebPage::LicenseChecker.config_locked?(c.config_type, c.config_key)
          override_key = [c.config_type, c.config_key]
          if UNLICENSED_OVERRIDES.key?(override_key)
            result[c.config_type] ||= {}
            result[c.config_type][c.config_key] = parse_value(UNLICENSED_OVERRIDES[override_key])
          end
          next
        end

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
