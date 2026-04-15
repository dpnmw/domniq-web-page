# frozen_string_literal: true

require_relative "helpers"

module DomniqWebPage
  class StyleBuilder
    include Helpers

    def initialize(config)
      @c = config
    end

    def color_overrides
      accent       = hex(cfg("design", "accent_color")) || "#d4a24e"
      accent_hover = hex(cfg("design", "accent_hover_color")) || "#c4922e"
      dark_bg      = hex(cfg("design", "dark_bg_color")) || "#06060f"
      light_bg     = hex(cfg("design", "light_bg_color")) || "#faf6f0"
      stat_icon    = hex(cfg("stats", "stat_icon_color")) || accent
      about_bg_img = upload("about_bg_image")
      app_g1_dark  = safe_cfg_hex("app_cta", "app_cta_gradient_start_dark") || accent
      app_g1_light = safe_cfg_hex("app_cta", "app_cta_gradient_start_light")
      app_g2_dark  = safe_cfg_hex("app_cta", "app_cta_gradient_mid_dark") || accent_hover
      app_g2_light = safe_cfg_hex("app_cta", "app_cta_gradient_mid_light")
      app_g3_dark  = safe_cfg_hex("app_cta", "app_cta_gradient_end_dark") || accent_hover
      app_g3_light = safe_cfg_hex("app_cta", "app_cta_gradient_end_light")
      stat_icon_bg = hex(cfg("stats", "stat_icon_bg_color").to_s.presence)
      stat_counter = hex(cfg("stats", "stat_counter_color").to_s.presence)
      video_btn_bg = hex(cfg("hero", "hero_video_button_color").to_s.presence)

      hero_card_dark  = hex(cfg("hero", "hero_card_bg_dark").to_s.presence)
      hero_card_light = hex(cfg("hero", "hero_card_bg_light").to_s.presence)
      hero_card_opacity = [[cfg("hero", "hero_card_opacity").to_s.to_f, 0].max, 1].min
      hero_card_opacity = 0.85 if hero_card_opacity == 0.0 && cfg("hero", "hero_card_opacity").to_s.strip.empty?

      navbar_signin_dark  = safe_cfg_hex("navbar", "navbar_signin_color_dark")
      navbar_signin_light = safe_cfg_hex("navbar", "navbar_signin_color_light")
      navbar_join_dark    = safe_cfg_hex("navbar", "navbar_join_color_dark")
      navbar_join_light   = safe_cfg_hex("navbar", "navbar_join_color_light")
      navbar_text_dark    = safe_cfg_hex("navbar", "navbar_text_color_dark")
      navbar_text_light   = safe_cfg_hex("navbar", "navbar_text_color_light")
      navbar_icon_dark    = safe_cfg_hex("navbar", "navbar_icon_color_dark")
      navbar_icon_light   = safe_cfg_hex("navbar", "navbar_icon_color_light")
      primary_btn_dark    = safe_cfg_hex("hero", "hero_primary_btn_color_dark")
      primary_btn_light   = safe_cfg_hex("hero", "hero_primary_btn_color_light")
      secondary_btn_dark  = safe_cfg_hex("hero", "hero_secondary_btn_color_dark")
      secondary_btn_light = safe_cfg_hex("hero", "hero_secondary_btn_color_light")
      pill_bg_dark        = safe_cfg_hex("hero", "contributors_pill_bg_dark")
      pill_bg_light       = safe_cfg_hex("hero", "contributors_pill_bg_light")
      stat_card_dark      = safe_cfg_hex("stats", "stat_card_bg_dark")
      stat_card_light     = safe_cfg_hex("stats", "stat_card_bg_light")
      about_card_dark     = safe_cfg_hex("about", "about_card_color_dark")
      about_card_light    = safe_cfg_hex("about", "about_card_color_light")
      topic_card_dark     = safe_cfg_hex("topics", "topics_card_bg_dark")
      topic_card_light    = safe_cfg_hex("topics", "topics_card_bg_light")
      faq_card_dark       = safe_cfg_hex("faq", "faq_card_bg_dark")
      faq_card_light      = safe_cfg_hex("faq", "faq_card_bg_light")
      part_card_dark      = safe_cfg_hex("leaderboard", "leaderboard_card_bg_dark")
      part_card_light     = safe_cfg_hex("leaderboard", "leaderboard_card_bg_light")
      lb_accent_color     = safe_cfg_hex("leaderboard", "leaderboard_accent_color")
      part_bio_color      = safe_cfg_hex("leaderboard", "leaderboard_bio_color")
      hero_title_dark     = safe_cfg_hex("hero", "hero_title_color_dark")
      hero_title_light    = safe_cfg_hex("hero", "hero_title_color_light")
      hero_sub_dark       = safe_cfg_hex("hero", "hero_subtitle_color_dark")
      hero_sub_light      = safe_cfg_hex("hero", "hero_subtitle_color_light")
      cta_headline_dark   = safe_cfg_hex("app_cta", "app_cta_headline_color_dark")
      cta_headline_light  = safe_cfg_hex("app_cta", "app_cta_headline_color_light")
      cta_subtext_dark    = safe_cfg_hex("app_cta", "app_cta_subtext_color_dark")
      cta_subtext_light   = safe_cfg_hex("app_cta", "app_cta_subtext_color_light")
      footer_text_dark    = safe_cfg_hex("footer", "footer_text_color_dark")
      footer_text_light   = safe_cfg_hex("footer", "footer_text_color_light")
      preloader_bg_dark   = safe_cfg_hex("design", "preloader_bg_dark")
      preloader_bg_light  = safe_cfg_hex("design", "preloader_bg_light")
      preloader_text_dark = safe_cfg_hex("design", "preloader_text_color_dark")
      preloader_text_light = safe_cfg_hex("design", "preloader_text_color_light")
      preloader_bar       = safe_cfg_hex("design", "preloader_bar_color")

      orb_color   = safe_cfg_hex("design", "orb_color")
      orb_opacity = (cfg("design", "orb_opacity") || 50).to_i.clamp(0, 100)
      orb_opacity = 50 if orb_opacity == 0 && cfg("design", "orb_opacity").to_s.strip.empty?

      accent_rgb    = hex_to_rgb(accent)
      orb_rgb       = orb_color ? hex_to_rgb(orb_color) : accent_rgb
      stat_icon_rgb = hex_to_rgb(stat_icon)

      stat_icon_bg_val = stat_icon_bg || "rgba(#{stat_icon_rgb}, 0.1)"
      stat_counter_val = stat_counter || "var(--dw-text-strong)"

      hero_card_dark_rgb  = hero_card_dark ? hex_to_rgb(hero_card_dark) : "12, 12, 25"
      hero_card_light_rgb = hero_card_light ? hex_to_rgb(hero_card_light) : "255, 255, 255"
      hero_card_dark_val  = "rgba(#{hero_card_dark_rgb}, #{hero_card_opacity})"
      hero_card_light_val = "rgba(#{hero_card_light_rgb}, #{hero_card_opacity})"

      about_dark_val  = about_card_dark || "var(--dw-card)"
      about_light_val = about_card_light || "var(--dw-card)"
      about_dark_css  = about_bg_img ? "#{about_dark_val}, url('#{about_bg_img}') center/cover no-repeat" : about_dark_val
      about_light_css = about_bg_img ? "#{about_light_val}, url('#{about_bg_img}') center/cover no-repeat" : about_light_val

      dark_extras = +""
      dark_extras << "\n  --dw-navbar-signin-color: #{navbar_signin_dark};" if navbar_signin_dark
      dark_extras << "\n  --dw-navbar-join-bg: #{navbar_join_dark};" if navbar_join_dark
      dark_extras << "\n  --dw-navbar-text-color: #{navbar_text_dark};" if navbar_text_dark
      dark_extras << "\n  --dw-navbar-icon-color: #{navbar_icon_dark};" if navbar_icon_dark
      dark_extras << "\n  --dw-primary-btn-bg: #{primary_btn_dark};" if primary_btn_dark
      dark_extras << "\n  --dw-secondary-btn-bg: #{secondary_btn_dark};" if secondary_btn_dark
      dark_extras << "\n  --dw-pill-bg: #{pill_bg_dark};" if pill_bg_dark
      if video_btn_bg
        video_btn_rgb = hex_to_rgb(video_btn_bg)
        dark_extras << "\n  --dw-video-btn-bg: #{video_btn_bg};"
        dark_extras << "\n  --dw-video-btn-glow: rgba(#{video_btn_rgb}, 0.35);"
      end
      dark_extras << "\n  --dw-hero-title-color: #{hero_title_dark};" if hero_title_dark
      dark_extras << "\n  --dw-hero-subtitle-color: #{hero_sub_dark};" if hero_sub_dark
      dark_extras << "\n  --dw-footer-text: #{footer_text_dark};" if footer_text_dark
      dark_extras << "\n  --dw-preloader-bg: #{preloader_bg_dark};" if preloader_bg_dark
      dark_extras << "\n  --dw-preloader-text: #{preloader_text_dark};" if preloader_text_dark
      dark_extras << "\n  --dw-preloader-bar: #{preloader_bar};" if preloader_bar

      light_extras = +""
      light_extras << "\n  --dw-hero-title-color: #{hero_title_light || hero_title_dark};" if hero_title_light || hero_title_dark
      light_extras << "\n  --dw-hero-subtitle-color: #{hero_sub_light || hero_sub_dark};" if hero_sub_light || hero_sub_dark
      light_extras << "\n  --dw-navbar-signin-color: #{navbar_signin_light || navbar_signin_dark};" if navbar_signin_light || navbar_signin_dark
      light_extras << "\n  --dw-navbar-join-bg: #{navbar_join_light || navbar_join_dark};" if navbar_join_light || navbar_join_dark
      light_extras << "\n  --dw-navbar-text-color: #{navbar_text_light || navbar_text_dark};" if navbar_text_light || navbar_text_dark
      light_extras << "\n  --dw-navbar-icon-color: #{navbar_icon_light || navbar_icon_dark};" if navbar_icon_light || navbar_icon_dark
      light_extras << "\n  --dw-primary-btn-bg: #{primary_btn_light || primary_btn_dark};" if primary_btn_light || primary_btn_dark
      light_extras << "\n  --dw-secondary-btn-bg: #{secondary_btn_light || secondary_btn_dark};" if secondary_btn_light || secondary_btn_dark
      light_extras << "\n  --dw-pill-bg: #{pill_bg_light || pill_bg_dark};" if pill_bg_light || pill_bg_dark
      if video_btn_bg
        video_btn_rgb ||= hex_to_rgb(video_btn_bg)
        light_extras << "\n  --dw-video-btn-bg: #{video_btn_bg};"
        light_extras << "\n  --dw-video-btn-glow: rgba(#{video_btn_rgb}, 0.25);"
      end
      light_extras << "\n  --dw-footer-text: #{footer_text_light || footer_text_dark};" if footer_text_light || footer_text_dark
      light_extras << "\n  --dw-preloader-bg: #{preloader_bg_light || preloader_bg_dark};" if preloader_bg_light || preloader_bg_dark
      light_extras << "\n  --dw-preloader-text: #{preloader_text_light || preloader_text_dark};" if preloader_text_light || preloader_text_dark
      light_extras << "\n  --dw-preloader-bar: #{preloader_bar};" if preloader_bar

      "<style>
:root, [data-theme=\"dark\"] {
  --dw-accent: #{accent};
  --dw-accent-hover: #{accent_hover};
  --dw-accent-glow: rgba(#{accent_rgb}, 0.35);
  --dw-accent-subtle: rgba(#{accent_rgb}, 0.08);
  --dw-bg: #{dark_bg};
  --dw-hero-bg: #{dark_bg};
  --dw-gradient-text: linear-gradient(135deg, #{accent_hover}, #{accent}, #{accent_hover});
  --dw-border-hover: rgba(#{accent_rgb}, 0.25);
  --dw-orb-1: rgba(#{orb_rgb}, 0.12);
  --dw-orb-2: rgba(#{orb_rgb}, 0.08);
  --dw-orb-opacity: #{orb_opacity / 100.0};
  --dw-stat-icon-color: #{stat_icon};
  --dw-stat-icon-bg: #{stat_icon_bg_val};
  --dw-stat-counter-color: #{stat_counter_val};
  --dw-stat-card-bg: #{stat_card_dark || 'var(--dw-card)'};
  --dw-topic-card-bg: #{topic_card_dark || 'var(--dw-card)'};
  --dw-hero-card-bg: #{hero_card_dark_val};
  --dw-about-card-bg: #{about_dark_css};
  --dw-leaderboard-card-bg: #{part_card_dark || 'var(--dw-card)'};
  --dw-leaderboard-accent-color: #{lb_accent_color || 'var(--dw-accent)'};
  --dw-leaderboard-bio-color: #{part_bio_color || 'var(--dw-text)'};
  --dw-faq-card-bg: #{faq_card_dark || 'var(--dw-card)'};
  --dw-app-gradient: linear-gradient(135deg, #{app_g1_dark}, #{app_g2_dark}, #{app_g3_dark});
  --dw-cta-headline-color: #{cta_headline_dark || '#ffffff'};
  --dw-cta-subtext-color: #{cta_subtext_dark || 'rgba(255, 255, 255, 0.75)'};#{dark_extras}
}
[data-theme=\"light\"] {
  --dw-accent: #{accent};
  --dw-accent-hover: #{accent_hover};
  --dw-accent-glow: rgba(#{accent_rgb}, 0.2);
  --dw-accent-subtle: rgba(#{accent_rgb}, 0.06);
  --dw-bg: #{light_bg};
  --dw-hero-bg: #{light_bg};
  --dw-gradient-text: linear-gradient(135deg, #{accent}, #{accent_hover}, #{accent});
  --dw-border-hover: rgba(#{accent_rgb}, 0.3);
  --dw-orb-1: rgba(#{orb_rgb}, 0.08);
  --dw-orb-2: rgba(#{orb_rgb}, 0.05);
  --dw-orb-opacity: #{orb_opacity / 100.0};
  --dw-stat-icon-color: #{stat_icon};
  --dw-stat-icon-bg: #{stat_icon_bg_val};
  --dw-stat-counter-color: #{stat_counter_val};
  --dw-stat-card-bg: #{stat_card_light || stat_card_dark || 'var(--dw-card)'};
  --dw-topic-card-bg: #{topic_card_light || topic_card_dark || 'var(--dw-card)'};
  --dw-hero-card-bg: #{hero_card_light_val};
  --dw-about-card-bg: #{about_light_css};
  --dw-leaderboard-card-bg: #{part_card_light || part_card_dark || 'var(--dw-card)'};
  --dw-leaderboard-accent-color: #{lb_accent_color || 'var(--dw-accent)'};
  --dw-leaderboard-bio-color: #{part_bio_color || 'var(--dw-text)'};
  --dw-faq-card-bg: #{faq_card_light || faq_card_dark || 'var(--dw-card)'};
  --dw-app-gradient: linear-gradient(135deg, #{app_g1_light || app_g1_dark}, #{app_g2_light || app_g2_dark}, #{app_g3_light || app_g3_dark});
  --dw-cta-headline-color: #{cta_headline_light || '#1a1a2e'};
  --dw-cta-subtext-color: #{cta_subtext_light || 'rgba(26, 26, 46, 0.7)'};#{light_extras}
}
@media (prefers-color-scheme: light) {
  :root:not([data-theme=\"dark\"]) {
    --dw-accent: #{accent};
    --dw-accent-hover: #{accent_hover};
    --dw-accent-glow: rgba(#{accent_rgb}, 0.2);
    --dw-accent-subtle: rgba(#{accent_rgb}, 0.06);
    --dw-bg: #{light_bg};
    --dw-hero-bg: #{light_bg};
    --dw-gradient-text: linear-gradient(135deg, #{accent}, #{accent_hover}, #{accent});
    --dw-border-hover: rgba(#{accent_rgb}, 0.3);
    --dw-orb-1: rgba(#{orb_rgb}, 0.08);
    --dw-orb-2: rgba(#{orb_rgb}, 0.05);
    --dw-orb-opacity: #{orb_opacity / 100.0};
    --dw-stat-icon-color: #{stat_icon};
    --dw-stat-card-bg: #{stat_card_light || stat_card_dark || 'var(--dw-card)'};
    --dw-topic-card-bg: #{topic_card_light || topic_card_dark || 'var(--dw-card)'};
    --dw-about-card-bg: #{about_light_css};
    --dw-leaderboard-card-bg: #{part_card_light || part_card_dark || 'var(--dw-card)'};
    --dw-leaderboard-accent-color: #{lb_accent_color || 'var(--dw-accent)'};
    --dw-leaderboard-bio-color: #{part_bio_color || 'var(--dw-text)'};
    --dw-faq-card-bg: #{faq_card_light || faq_card_dark || 'var(--dw-card)'};
    --dw-app-gradient: linear-gradient(135deg, #{app_g1_light || app_g1_dark}, #{app_g2_light || app_g2_dark}, #{app_g3_light || app_g3_dark});
    --dw-cta-headline-color: #{cta_headline_light || '#1a1a2e'};
    --dw-cta-subtext-color: #{cta_subtext_light || 'rgba(26, 26, 46, 0.7)'};#{light_extras}
  }
}
</style>\n"
    end

    def section_backgrounds
      css = +""
      sections = [
        ["#dw-hero",        safe_cfg_hex("hero", "hero_bg_dark"),              safe_cfg_hex("hero", "hero_bg_light")],
        ["#dw-stats-row",   safe_cfg_hex("stats", "stats_bg_dark"),            safe_cfg_hex("stats", "stats_bg_light")],
        ["#dw-about",       safe_cfg_hex("about", "about_bg_dark"),            safe_cfg_hex("about", "about_bg_light")],
        ["#dw-leaderboard", safe_cfg_hex("leaderboard", "leaderboard_bg_dark"), safe_cfg_hex("leaderboard", "leaderboard_bg_light")],
        ["#dw-topics",      safe_cfg_hex("topics", "topics_bg_dark"),          safe_cfg_hex("topics", "topics_bg_light")],
        ["#dw-faq",         safe_cfg_hex("faq", "faq_bg_dark"),                safe_cfg_hex("faq", "faq_bg_light")],
        ["#dw-app-cta",     safe_cfg_hex("app_cta", "app_cta_bg_dark"),        safe_cfg_hex("app_cta", "app_cta_bg_light")],
        ["#dw-footer",      safe_cfg_hex("footer", "footer_bg_dark"),          safe_cfg_hex("footer", "footer_bg_light")],
      ]

      sections.each do |sel, dark_bg, light_bg|
        next unless dark_bg || light_bg
        css << ":root #{sel}, [data-theme=\"dark\"] #{sel} { background: #{dark_bg}; }\n" if dark_bg
        if light_bg
          css << "[data-theme=\"light\"] #{sel} { background: #{light_bg}; }\n"
          css << "@media (prefers-color-scheme: light) { :root:not([data-theme=\"dark\"]) #{sel} { background: #{light_bg}; } }\n"
        end
      end

      faq_mh = (cfg("faq", "faq_mobile_max_height") || 0).to_i
      css << "@media (max-width: 767px) { .dw-faq { max-height: #{faq_mh}px; overflow-y: auto; } }\n" if faq_mh > 0

      css.present? ? "<style>\n#{css}</style>\n" : ""
    end

    private

    def cfg(type, key)
      @c.dig(type, key)
    end

    def upload(key)
      @c.dig("uploads", key)
    end

    def safe_cfg_hex(type, key)
      hex(cfg(type, key).to_s.presence)
    rescue
      nil
    end
  end
end
