# frozen_string_literal: true

require_relative "helpers"
require_relative "icons"
require_relative "data_fetcher"

module DomniqWebPage
  class PageBuilder
    include Helpers
    include Icons

    SECTION_MAP = {
      "hero"        => :render_hero,
      "stats"       => :render_stats,
      "about"       => :render_about,
      "leaderboard" => :render_leaderboard,
      "topics"      => :render_topics,
      "faq"         => :render_faq_section,
      "app_cta"     => :render_app_cta,
    }.freeze

    def initialize(config)
      @c = config
      @data = DataFetcher.fetch(config)
      @styles = StyleBuilder.new(config)
    end

    def build
      css = landing_css
      js  = landing_js

      html = +""
      html << render_head(css)
      html << "<body class=\"dw-body\">\n"
      html << render_preloader if cfg("design", "preloader_enabled")
      if cfg("design", "dynamic_background_enabled")
        html << "<div class=\"dw-orb-container\"><div class=\"dw-orb dw-orb--1\"></div><div class=\"dw-orb dw-orb--2\"></div></div>\n"
      end
      html << render_navbar

      order = (cfg("general", "section_order") || "hero|stats|about|leaderboard|topics|faq|app_cta").to_s
      order.split("|").map(&:strip).each do |section_id|
        method_name = SECTION_MAP[section_id]
        html << send(method_name) if method_name
      end

      html << render_footer_desc
      html << render_footer
      html << render_video_modal
      html << render_designer_badge
      html << render_theme_sounds
      html << "<script>\n#{js}\n</script>\n"
      html << "</body>\n</html>"
      html
    end

    private

    def cfg(type, key)
      @c.dig(type, key)
    end

    def upload(key)
      @c.dig("uploads", key)
    end

    # ── <head> ──

    def render_head(css)
      site_name  = SiteSetting.title
      anim_class = cfg("design", "scroll_animation") || "fade_up"
      anim_class = "none" if anim_class.to_s.blank?
      og_logo    = logo_dark_img || logo_light_img
      base_url   = Discourse.base_url

      meta_desc = cfg("general", "meta_description").to_s.presence || cfg("hero", "hero_subtitle")
      og_image  = upload("og_image") || og_logo
      favicon   = upload("favicon")

      html = +""
      html << "<!DOCTYPE html>\n<html lang=\"en\""
      html << " data-scroll-anim=\"#{e(anim_class)}\""
      html << " data-parallax=\"#{cfg("design", "mouse_parallax_enabled")}\""
      html << ">\n<head>\n"
      html << "<meta charset=\"UTF-8\">\n"
      body_font  = cfg("design", "google_font_name").to_s.presence || "Outfit"
      title_font = cfg("design", "title_font_name").to_s.presence
      font_families = [body_font]
      font_families << title_font if title_font && title_font != body_font
      font_params = font_families.map { |f| "family=#{f.gsub(' ', '+')}:wght@400;500;600;700;800;900" }.join("&")

      html << "<link rel=\"preconnect\" href=\"https://fonts.googleapis.com\">\n"
      html << "<link rel=\"preconnect\" href=\"https://fonts.gstatic.com\" crossorigin>\n"
      html << "<link href=\"https://fonts.googleapis.com/css2?#{font_params}&display=swap\" rel=\"stylesheet\">\n"
      icon_lib = (cfg("general", "icon_library") || "none").to_s
      case icon_lib
      when "fontawesome"
        html << "<link rel=\"stylesheet\" href=\"https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css\" crossorigin=\"anonymous\">\n"
      when "google"
        html << "<link rel=\"stylesheet\" href=\"https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200&display=swap\">\n"
      end
      html << "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, viewport-fit=cover\">\n"
      html << "<meta name=\"color-scheme\" content=\"dark light\">\n"
      accent_hex = hex(cfg("design", "accent_color")) || "#d4a24e"
      html << "<meta name=\"theme-color\" content=\"#{e(accent_hex)}\">\n"
      html << "<link rel=\"manifest\" href=\"/manifest.json\">\n"

      if favicon
        ftype = case favicon.to_s.split(".").last.downcase
                when "svg" then "image/svg+xml"
                when "png" then "image/png"
                else "image/x-icon"
                end
        html << "<link rel=\"icon\" type=\"#{ftype}\" href=\"#{e(favicon)}\">\n"
      end

      html << "<title>#{e(cfg("hero", "hero_title"))} | #{e(site_name)}</title>\n"
      html << "<meta name=\"description\" content=\"#{e(meta_desc)}\">\n"
      html << "<meta property=\"og:type\" content=\"website\">\n"
      html << "<meta property=\"og:title\" content=\"#{e(cfg("hero", "hero_title"))}\">\n"
      html << "<meta property=\"og:description\" content=\"#{e(meta_desc)}\">\n"
      html << "<meta property=\"og:url\" content=\"#{base_url}\">\n"
      html << "<meta property=\"og:site_name\" content=\"#{e(site_name)}\">\n"
      html << "<meta property=\"og:image\" content=\"#{og_image}\">\n" if og_image
      html << "<meta name=\"twitter:card\" content=\"summary_large_image\">\n"
      html << "<meta name=\"twitter:title\" content=\"#{e(cfg("hero", "hero_title"))}\">\n"
      html << "<meta name=\"twitter:description\" content=\"#{e(meta_desc)}\">\n"
      html << "<meta name=\"twitter:image\" content=\"#{og_image}\">\n" if og_image
      html << "<link rel=\"canonical\" href=\"#{base_url}\">\n"

      if cfg("general", "json_ld_enabled")
        html << "<script type=\"application/ld+json\">\n#{render_json_ld(site_name, base_url, og_logo)}\n</script>\n"
      end

      html << "<style>\n#{css}\n</style>\n"
      html << @styles.color_overrides
      html << @styles.section_backgrounds

      font_css = +""
      font_css << ":root { --dw-font-body: \"#{body_font}\", sans-serif;"
      font_css << (title_font ? " --dw-font-title: \"#{title_font}\", serif;" : " --dw-font-title: var(--dw-font-body);")
      font_css << " }\n"
      html << "<style>#{font_css}</style>\n"

      custom_css = cfg("general", "custom_css").to_s.presence
      html << "<style id=\"dw-custom-css\">\n#{custom_css}\n</style>\n" if custom_css

      html << "</head>\n"
      html
    end

    # ── PRELOADER ──

    def render_preloader
      logo_dark  = upload("preloader_logo_dark") || logo_dark_img
      logo_light = upload("preloader_logo_light") || logo_dark
      min_ms = (cfg("design", "preloader_min_duration") || 800).to_i.clamp(0, 5000)

      html = +""
      html << "<div id=\"dw-preloader\" class=\"dw-preloader\">\n"
      html << "  <div class=\"dw-preloader__content\">\n"
      if logo_dark
        html << "    <img class=\"dw-preloader__logo dw-preloader__logo--dark\" src=\"#{e(logo_dark)}\" alt=\"\">\n"
        html << "    <img class=\"dw-preloader__logo dw-preloader__logo--light\" src=\"#{e(logo_light)}\" alt=\"\">\n"
      end
      html << "    <div class=\"dw-preloader__counter\" id=\"dw-preloader-pct\">0%</div>\n"
      html << "    <div class=\"dw-preloader__bar\"><div class=\"dw-preloader__bar-fill\" id=\"dw-preloader-bar\"></div></div>\n"
      html << "  </div>\n</div>\n"
      html << "<script>\n(function() {\n"
      html << "  var el = document.getElementById('dw-preloader');\n"
      html << "  var pct = document.getElementById('dw-preloader-pct');\n"
      html << "  var bar = document.getElementById('dw-preloader-bar');\n"
      html << "  var minMs = #{min_ms}; var start = Date.now(); var current = 0; var target = 0; var done = false;\n"
      html << "  function update() {\n"
      html << "    if (current < target) { current += (target - current) * 0.15; if (target - current < 0.5) current = target; }\n"
      html << "    var v = Math.round(current); pct.textContent = v + '%'; bar.style.width = v + '%';\n"
      html << "    if (done && current >= 100) { var elapsed = Date.now() - start; var remaining = Math.max(0, minMs - elapsed);\n"
      html << "      setTimeout(function() { el.classList.add('dw-preloader--hide'); setTimeout(function() { el.remove(); }, 500); }, remaining); return; }\n"
      html << "    requestAnimationFrame(update); }\n"
      html << "  window.addEventListener('DOMContentLoaded', function() {\n"
      html << "    var imgs = document.querySelectorAll('img'); var total = imgs.length || 1; var loaded = 0;\n"
      html << "    function tick() { loaded++; target = Math.min(95, Math.round((loaded / total) * 95)); }\n"
      html << "    imgs.forEach(function(img) { if (img.complete) { tick(); return; } img.addEventListener('load', tick); img.addEventListener('error', tick); });\n"
      html << "    if (imgs.length === 0) target = 95; });\n"
      html << "  window.addEventListener('load', function() { target = 100; done = true; });\n"
      html << "  requestAnimationFrame(update);\n})();\n</script>\n"
      html
    end

    # ── NAVBAR ──

    def render_navbar
      site_name    = SiteSetting.title
      signin_label = cfg("navbar", "navbar_signin_label").to_s.presence || "Sign In"
      join_label   = cfg("navbar", "navbar_join_label").to_s.presence || "Get Started"
      navbar_bg    = hex(cfg("navbar", "navbar_bg_color"))
      navbar_border = cfg("navbar", "navbar_border_style") || "none"

      nav_style_parts = []
      nav_style_parts << "--dw-nav-bg: #{navbar_bg}" if navbar_bg
      nav_style_parts << "--dw-nav-border: 1px #{navbar_border} var(--dw-border)" if navbar_border != "none"
      nav_style = nav_style_parts.any? ? " style=\"#{nav_style_parts.join('; ')}\"" : ""

      html = +""
      html << "<nav class=\"dw-navbar\" id=\"dw-navbar\"#{nav_style}>\n"
      html << "<div class=\"dw-progress-bar\"></div>\n" if cfg("design", "scroll_progress_enabled")
      html << "<div class=\"dw-navbar__inner\">\n<div class=\"dw-navbar__left\">"
      html << "<a href=\"/\" class=\"dw-navbar__brand\">"
      logo_accent = cfg("design", "logo_use_accent_color")
      if has_logo?
        html << render_logo(logo_dark_img, logo_light_img, site_name, "dw-navbar__logo", logo_height_val, accent: logo_accent)
      else
        html << "<span class=\"dw-navbar__site-name\">#{e(site_name)}</span>"
      end
      html << "</a>\n</div>"

      signin_on = cfg("navbar", "navbar_signin_enabled") != false
      join_on   = cfg("navbar", "navbar_join_enabled") != false

      html << "<div class=\"dw-navbar__right\">"
      html << theme_toggle
      html << render_social_icons
      html << "<a href=\"/login\" class=\"dw-navbar__link dw-btn--ghost\">#{button_with_icon(signin_label)}</a>\n" if signin_on
      html << "<a href=\"/login\" class=\"dw-navbar__link dw-btn--primary\">#{button_with_icon(join_label)}</a>\n" if join_on
      html << "</div>"

      html << "<div class=\"dw-navbar__mobile-actions\">"
      html << theme_toggle
      html << "<button class=\"dw-navbar__hamburger\" id=\"dw-hamburger\" aria-label=\"Toggle menu\"><span></span><span></span><span></span></button>\n"
      html << "</div></div></nav>\n"
      html << "<div class=\"dw-navbar__mobile-menu\" id=\"dw-nav-links\">\n"
      html << "<a href=\"/login\" class=\"dw-navbar__link dw-btn--ghost\">#{button_with_icon(signin_label)}</a>\n" if signin_on
      html << "<a href=\"/login\" class=\"dw-navbar__link dw-btn--primary\">#{button_with_icon(join_label)}</a>\n" if join_on
      html << render_social_icons
      html << "</div>\n"
      html
    end

    # ── HERO ──

    def render_hero
      hero_card      = cfg("hero", "hero_card_enabled") != false
      hero_img_first = cfg("hero", "hero_image_first")
      hero_bg_img    = upload("hero_bg_image")
      hero_border    = cfg("hero", "hero_border_style") || "none"
      hero_min_h     = cfg("hero", "hero_min_height") || 0
      site_name      = SiteSetting.title

      html = +""
      hero_style_parts = []
      hero_style_parts << "border-bottom: 1px #{hero_border} var(--dw-border);" if hero_border.present? && hero_border != "none"
      hero_style_parts << "min-height: #{hero_min_h}vh;" if hero_min_h.to_i > 0
      hero_attr = hero_style_parts.any? ? " style=\"#{hero_style_parts.join(' ')}\"" : ""
      hero_align = (cfg("hero", "hero_content_alignment") || "left").to_s
      hero_classes = +"dw-hero"
      hero_classes << " dw-hero--card" if hero_card
      hero_classes << " dw-hero--image-first" if hero_img_first
      hero_classes << " dw-hero--align-#{hero_align}" if hero_align != "left"
      hero_classes << " dw-hero--text-shadow" if cfg("hero", "hero_text_shadow")
      hero_classes << " dw-hero--no-btn-shadow" unless cfg("hero", "hero_buttons_shadow") != false
      html << "<section class=\"#{hero_classes}\" id=\"dw-hero\"#{hero_attr}>\n"

      bg_effect = (cfg("hero", "hero_bg_effect") || "none").to_s
      if hero_bg_img
        bg_classes = +"dw-hero__bg"
        bg_classes << " dw-hero__bg--#{bg_effect}" if bg_effect != "none"
        html << "<div class=\"#{bg_classes}\" style=\"background-image: url('#{hero_bg_img}');\"></div>\n"
      end

      if hero_bg_img && cfg("hero", "hero_background_overlay")
        overlay_color = hex(cfg("hero", "hero_overlay_color")) || "#000000"
        overlay_opacity = (cfg("hero", "hero_overlay_opacity") || 60).to_i.clamp(0, 100) / 100.0
        overlay_rgb = hex_to_rgb(overlay_color)
        html << "<div class=\"dw-hero__overlay\" style=\"background: radial-gradient(ellipse 65% 55% at 50% 50%, rgba(#{overlay_rgb}, #{overlay_opacity}) 0%, transparent 100%);\"></div>\n"
      end

      html << "<div class=\"dw-hero__inner\">\n<div class=\"dw-hero__content\">\n"

      raw_title = cfg("hero", "hero_title").to_s.strip
      accent_on = cfg("hero", "hero_accent_enabled") != false
      tokens = raw_title.split(/(<br\s*\/?>)/).flat_map { |seg|
        seg.match?(/\A<br\s*\/?>\z/) ? [:br] : seg.split(" ").reject(&:empty?)
      }
      real_words = tokens.reject { |t| t == :br }
      accent_idx = (cfg("hero", "hero_accent_word") || 0).to_i
      if real_words.length > 1
        target = accent_on ? (accent_idx > 0 ? [accent_idx - 1, real_words.length - 1].min : real_words.length - 1) : -1
        word_counter = 0
        parts = +""
        accent_placed = false
        tokens.each do |tok|
          if tok == :br
            parts << "<br>"
          elsif !accent_placed && word_counter == target
            parts << " " unless parts.empty? || parts.end_with?("<br>")
            parts << "<span class=\"dw-hero__title-accent\">#{e(tok)}</span>"
            accent_placed = true
            word_counter += 1
          else
            parts << " " unless parts.empty? || parts.end_with?("<br>")
            parts << e(tok)
            word_counter += 1
          end
        end
        html << "<h1 class=\"dw-hero__title\"#{title_style_val("hero", "hero_title_size", "hero_title_letter_spacing")}>#{parts}</h1>\n"
      else
        single = e(raw_title)
        single = restore_br(single)
        if accent_on
          html << "<h1 class=\"dw-hero__title\"#{title_style_val("hero", "hero_title_size", "hero_title_letter_spacing")}><span class=\"dw-hero__title-accent\">#{single}</span></h1>\n"
        else
          html << "<h1 class=\"dw-hero__title\"#{title_style_val("hero", "hero_title_size", "hero_title_letter_spacing")}>#{single}</h1>\n"
        end
      end

      subtitle_html = restore_br(e(cfg("hero", "hero_subtitle").to_s))
      html << "<p class=\"dw-hero__subtitle\">#{subtitle_html}</p>\n"

      primary_on      = cfg("hero", "hero_primary_button_enabled") != false
      secondary_on    = cfg("hero", "hero_secondary_button_enabled") != false
      primary_label   = cfg("hero", "hero_primary_button_label").to_s.presence || "View Latest Topics"
      primary_url     = cfg("hero", "hero_primary_button_url").to_s.presence || "/latest"
      secondary_label = cfg("hero", "hero_secondary_button_label").to_s.presence || "Explore Our Spaces"
      secondary_url   = cfg("hero", "hero_secondary_button_url").to_s.presence || "/login"

      if primary_on || secondary_on
        html << "<div class=\"dw-hero__actions\">\n"
        html << "<a href=\"#{e(primary_url)}\" class=\"dw-btn dw-btn--primary dw-btn--lg\">#{button_with_icon(primary_label)}</a>\n" if primary_on
        html << "<a href=\"#{e(secondary_url)}\" class=\"dw-btn dw-btn--ghost dw-btn--lg\">#{button_with_icon(secondary_label)}</a>\n" if secondary_on
        html << "</div>\n"
      end

      # Contributors
      contributors = @data[:contributors]
      if cfg("hero", "contributors_enabled") && contributors&.any?
        top3 = contributors.first(3)
        rank_colors = ["#FFD700", "#C0C0C0", "#CD7F32"]
        creators_title = cfg("hero", "contributors_title").to_s.presence || "Top Creators"
        show_title = cfg("hero", "contributors_title_enabled") != false
        count_label = cfg("hero", "contributors_count_label").to_s.presence || ""
        show_count_label = cfg("hero", "contributors_count_label_enabled") != false
        alignment = cfg("hero", "contributors_alignment") || "center"
        pill_max_w = cfg("hero", "contributors_pill_max_width") || 340

        align_class = alignment == "left" ? " dw-hero__creators--left" : ""
        html << "<div class=\"dw-hero__creators#{align_class}\">\n"
        html << "<h3 class=\"dw-hero__creators-title\">#{e(creators_title)}</h3>\n" if show_title
        top3.each_with_index do |user, idx|
          avatar_url     = user.avatar_template.to_s.gsub("{size}", "120")
          activity_count = user.attributes["post_count"].to_i rescue 0
          rank_color     = rank_colors[idx]
          count_prefix = show_count_label && count_label.present? ? "#{e(count_label)} " : ""
          pill_style_parts = ["--rank-color: #{rank_color}"]
          pill_style_parts << "max-width: #{pill_max_w}px" if pill_max_w.to_i != 340
          html << "<a href=\"/login\" class=\"dw-creator-pill dw-creator-pill--rank-#{idx + 1}\" style=\"#{pill_style_parts.join('; ')}\">\n"
          html << "<span class=\"dw-creator-pill__rank\">Ranked ##{idx + 1}</span>\n"
          html << "<img src=\"#{avatar_url}\" alt=\"#{e(user.username)}\" class=\"dw-creator-pill__avatar\" loading=\"lazy\">\n"
          html << "<div class=\"dw-creator-pill__info\">\n"
          html << "<span class=\"dw-creator-pill__name\">@#{e(user.username)}</span>\n"
          html << "<span class=\"dw-creator-pill__count\">#{count_prefix}#{activity_count}</span>\n"
          html << "</div>\n</a>\n"
        end
        html << "</div>\n"
      end

      html << "</div>\n"

      # Hero image / video
      hero_image_url = upload("hero_image")
      hero_video = cfg("hero", "hero_video_url").to_s.presence
      blur_attr = cfg("hero", "hero_video_blur_on_hover") != false ? " data-blur-hover=\"true\"" : ""
      play_pos = (cfg("hero", "hero_video_button_position") || "center").to_s
      play_class = +"dw-hero-play"
      play_class << " dw-hero-play--bottom" if play_pos == "bottom"
      has_images = false

      if hero_image_url
        has_images = true
        img_max_h = (cfg("hero", "hero_image_max_height") || 60).to_i.clamp(10, 100)
        img_weight = (cfg("hero", "hero_image_weight") || 1).to_i.clamp(1, 3)
        img_style = img_weight > 1 ? " style=\"flex: #{img_weight}\"" : ""
        html << "<div class=\"dw-hero__image\"#{img_style}>\n"
        html << "<img src=\"#{hero_image_url}\" alt=\"#{e(site_name)}\" class=\"dw-hero__image-img\" style=\"max-height: #{img_max_h}vh;\">\n"
        if hero_video
          html << "<button class=\"#{play_class}\" data-video-url=\"#{e(hero_video)}\"#{blur_attr} aria-label=\"Play video\">"
          html << "<span class=\"dw-hero-play__icon\">#{PLAY_SVG}</span></button>\n"
        end
        html << "</div>\n"
      end

      if hero_video && !has_images
        html << "<div class=\"dw-hero__image dw-hero__image--video-only\">\n"
        html << "<button class=\"#{play_class}\" data-video-url=\"#{e(hero_video)}\"#{blur_attr} aria-label=\"Play video\">"
        html << "<span class=\"dw-hero-play__icon\">#{PLAY_SVG}</span></button>\n</div>\n"
      end

      html << "</div></section>\n"
      html
    end

    # ── STATS ──

    def render_stats
      return "" unless cfg("stats", "stats_enabled") != false

      stats       = @data[:stats]
      stats_title = cfg("stats", "stats_title").to_s.presence || "Premium Stats"
      show_title  = cfg("stats", "stats_title_enabled") != false
      border      = cfg("stats", "stats_border_style") || "none"
      min_h       = cfg("stats", "stats_min_height") || 0
      icon_shape  = cfg("stats", "stat_icon_shape") || "circle"
      card_style  = cfg("stats", "stat_card_style") || "rectangle"
      round_nums  = cfg("stats", "stat_round_numbers")
      show_labels = cfg("stats", "stat_labels_enabled") != false

      html = +""
      html << "<section class=\"dw-stats dw-anim\" id=\"dw-stats-row\"#{section_style(border, min_h)}><div class=\"dw-container\">\n"
      html << "<h2 class=\"dw-section-title\"#{title_style_val("stats", "stats_title_size")}>#{button_with_icon(stats_title)}</h2>\n" if show_title
      html << "<div class=\"dw-stats__grid\">\n"
      html << stat_card(STAT_MEMBERS_SVG, stats[:members], cfg("stats", "stat_members_label") || "Members", icon_shape, card_style, round_nums, show_labels)
      html << stat_card(STAT_TOPICS_SVG,  stats[:topics],  cfg("stats", "stat_topics_label") || "Topics",  icon_shape, card_style, round_nums, show_labels)
      html << stat_card(STAT_POSTS_SVG,   stats[:posts],   cfg("stats", "stat_posts_label") || "Posts",   icon_shape, card_style, round_nums, show_labels)
      html << stat_card(STAT_LIKES_SVG,   stats[:likes],   cfg("stats", "stat_likes_label") || "Likes",   icon_shape, card_style, round_nums, show_labels)
      html << stat_card(STAT_CHATS_SVG,   stats[:chats],   cfg("stats", "stat_chats_label") || "Chats",   icon_shape, card_style, round_nums, show_labels)
      html << "</div>\n</div></section>\n"
      html
    end

    # ── ABOUT ──

    def render_about
      return "" unless cfg("about", "about_enabled")

      about_body       = cfg("about", "about_body").to_s.presence || ""
      about_image      = upload("about_image")
      about_role       = cfg("about", "about_role").to_s.presence || SiteSetting.title
      about_heading_on = cfg("about", "about_heading_enabled") != false
      about_heading    = cfg("about", "about_heading").to_s.presence || "About Community"
      border           = cfg("about", "about_border_style") || "none"
      min_h            = cfg("about", "about_min_height") || 0

      html = +""
      html << "<section class=\"dw-about dw-anim\" id=\"dw-about\"#{section_style(border, min_h)}><div class=\"dw-container\">\n"
      html << "<div class=\"dw-about__card\">\n"
      html << "<div class=\"dw-about__left\">\n"
      html << "<img src=\"#{about_image}\" alt=\"#{e(cfg("about", "about_title"))}\" class=\"dw-about__image\">\n" if about_image
      html << "</div>\n<div class=\"dw-about__right\">\n"
      html << "<h2 class=\"dw-about__heading\"#{title_style_val("about", "about_title_size")}>#{button_with_icon(about_heading)}</h2>\n" if about_heading_on
      html << QUOTE_SVG
      html << "<div class=\"dw-about__body\">#{sanitize_html(about_body)}</div>\n" if about_body.present?
      html << "<div class=\"dw-about__meta\">\n<div class=\"dw-about__meta-text\">\n"
      html << "<span class=\"dw-about__author\">#{e(cfg("about", "about_title"))}</span>\n"
      html << "<span class=\"dw-about__role\">#{e(about_role)}</span>\n"
      html << "</div></div>\n</div>\n</div>\n</div></section>\n"
      html
    end

    # ── LEADERBOARD ──

    def render_leaderboard
      return "" unless cfg("leaderboard", "leaderboard_enabled")

      contributors = @data[:contributors]
      hero_contributors_on = cfg("hero", "contributors_enabled")

      if hero_contributors_on
        return "" unless contributors&.length.to_i > 3
        candidates = contributors[3..9] || []
      else
        return "" unless contributors&.any?
        candidates = contributors[0..9] || []
      end

      bio_max = (cfg("leaderboard", "leaderboard_bio_max_length") || 150).to_i
      users_with_bio = candidates.select { |u| u.user_profile&.bio_excerpt.present? rescue false }
      return "" if users_with_bio.empty?

      show_title  = cfg("leaderboard", "leaderboard_title_enabled") != false
      title_text  = cfg("leaderboard", "leaderboard_title").to_s.presence || "Leaderboard"
      border      = cfg("leaderboard", "leaderboard_border_style") || "none"
      min_h       = cfg("leaderboard", "leaderboard_min_height") || 0
      topics_label = cfg("leaderboard", "leaderboard_topics_label").to_s.presence || "Topics"
      posts_label  = cfg("leaderboard", "leaderboard_posts_label").to_s.presence || "Posts"
      likes_label  = cfg("leaderboard", "leaderboard_likes_label").to_s.presence || "Likes"

      html = +""
      html << "<section class=\"dw-leaderboard dw-anim\" id=\"dw-leaderboard\"#{section_style(border, min_h)}><div class=\"dw-container\">\n"
      html << "<h2 class=\"dw-section-title\"#{title_style_val("leaderboard", "leaderboard_title_size")}>#{button_with_icon(title_text)}</h2>\n" if show_title
      stagger_class = cfg("design", "staggered_reveal_enabled") ? " dw-stagger" : ""
      html << "<div class=\"dw-leaderboard__grid#{stagger_class}\">\n"

      users_with_bio.each do |user|
        avatar_url     = user.avatar_template.to_s.gsub("{size}", "120")
        bio_raw        = user.user_profile.bio_excerpt.to_s
        bio_text       = bio_raw.length > bio_max ? "#{bio_raw[0...bio_max]}..." : bio_raw
        join_date      = user.created_at.strftime("Joined %b %Y") rescue "Member"
        location       = (user.user_profile&.location.presence rescue nil)
        meta_line      = location ? "#{join_date} · #{e(location)}" : join_date
        topic_count    = (user.user_stat&.topic_count.to_i rescue 0)
        post_count     = (user.user_stat&.post_count.to_i rescue 0)
        likes_received = (user.user_stat&.likes_received.to_i rescue 0)

        html << "<div class=\"dw-leaderboard-card\">\n"
        html << "<div class=\"dw-leaderboard-card__header\">\n"
        html << "<div class=\"dw-leaderboard-card__quote\">#{QUOTE_SVG}</div>\n"
        html << "<p class=\"dw-leaderboard-card__bio\">#{e(bio_text)}</p>\n</div>\n"
        html << "<div class=\"dw-leaderboard-card__stats\">\n"
        html << leaderboard_stat(topic_count, topics_label, PART_TOPICS_SVG)
        html << leaderboard_stat(post_count, posts_label, PART_POSTS_SVG)
        html << leaderboard_stat(likes_received, likes_label, PART_LIKES_SVG)
        html << "</div>\n"
        html << "<div class=\"dw-leaderboard-card__footer\">\n"
        html << "<img src=\"#{avatar_url}\" alt=\"#{e(user.username)}\" class=\"dw-leaderboard-card__avatar\" loading=\"lazy\">\n"
        html << "<div class=\"dw-leaderboard-card__meta\">\n"
        html << "<span class=\"dw-leaderboard-card__name\">@#{e(user.username)}</span>\n"
        html << "<span class=\"dw-leaderboard-card__count\">#{e(meta_line)}</span>\n"
        html << "</div>\n</div>\n</div>\n"
      end

      html << "</div>\n</div></section>\n"
      html
    end

    # ── TOPICS ──

    def render_topics
      topics = @data[:topics]
      return "" unless cfg("topics", "topics_enabled") && topics&.any?

      border = cfg("topics", "topics_border_style") || "none"
      min_h  = cfg("topics", "topics_min_height") || 0
      show_title = cfg("topics", "topics_title_enabled") != false

      html = +""
      html << "<section class=\"dw-topics dw-anim\" id=\"dw-topics\"#{section_style(border, min_h)}><div class=\"dw-container\">\n"
      html << "<h2 class=\"dw-section-title\"#{title_style_val("topics", "topics_title_size")}>#{button_with_icon(cfg("topics", "topics_title") || "Trending Discussions")}</h2>\n" if show_title
      stagger_class = cfg("design", "staggered_reveal_enabled") ? " dw-stagger" : ""
      html << "<div class=\"dw-topics__grid#{stagger_class}\">\n"

      topics.each do |topic|
        topic_likes   = topic.like_count rescue 0
        topic_replies = topic.posts_count.to_i
        html << "<a href=\"/login\" class=\"dw-topic-card\">\n"
        html << "<span class=\"dw-topic-card__cat\">#{e(topic.category.name)}</span>\n" if topic.category
        html << "<span class=\"dw-topic-card__title\">#{e(topic.title)}</span>\n"
        html << "<div class=\"dw-topic-card__meta\">"
        html << "<span class=\"dw-topic-card__stat\">#{COMMENT_SVG} #{topic_replies}</span>"
        html << "<span class=\"dw-topic-card__stat\">#{HEART_SVG} #{topic_likes}</span>"
        html << "</div></a>\n"
      end

      html << "</div>\n</div></section>\n"
      html
    end

    # ── FAQ ──

    def render_faq_section
      return "" unless cfg("faq", "faq_enabled")

      border = cfg("faq", "faq_border_style") || "none"
      min_h  = cfg("faq", "faq_min_height") || 0
      faq_image = upload("faq_image")

      html = +""
      html << "<section class=\"dw-faq-section dw-anim\" id=\"dw-faq\"#{section_style(border, min_h)}><div class=\"dw-container\">\n"
      html << "<div class=\"dw-faq-section__inner\">\n"
      if faq_image
        html << "<div class=\"dw-faq-section__image\">\n"
        html << "<img src=\"#{e(faq_image)}\" alt=\"\" class=\"dw-faq-section__img\" loading=\"lazy\">\n</div>\n"
      end
      html << "<div class=\"dw-faq-section__content\">\n"
      html << render_faq
      html << "</div>\n</div>\n</div></section>\n"
      html
    end

    def render_faq
      faq_title_on = cfg("faq", "faq_title_enabled") != false
      faq_title    = cfg("faq", "faq_title").to_s.presence || "Frequently Asked Questions"
      faq_raw      = cfg("faq", "faq_items")

      html = +""
      html << "<h2 class=\"dw-section-title\"#{title_style_val("faq", "faq_title_size")}>#{button_with_icon(faq_title)}</h2>\n" if faq_title_on
      html << "<div class=\"dw-faq\">\n"

      if faq_raw.is_a?(Array)
        faq_raw.each do |item|
          q = item["q"].to_s
          a = item["a"].to_s
          next if q.blank?
          html << "<details class=\"dw-faq__card\" data-faq-exclusive>\n"
          html << "<summary class=\"dw-faq__question\">#{e(q)}</summary>\n"
          html << "<div class=\"dw-faq__answer\">#{sanitize_html(a)}</div>\n</details>\n"
        end
      elsif faq_raw.is_a?(String) && faq_raw.present?
        begin
          items = JSON.parse(faq_raw)
          items.each do |item|
            q = item["q"].to_s
            a = item["a"].to_s
            next if q.blank?
            html << "<details class=\"dw-faq__card\" data-faq-exclusive>\n"
            html << "<summary class=\"dw-faq__question\">#{e(q)}</summary>\n"
            html << "<div class=\"dw-faq__answer\">#{sanitize_html(a)}</div>\n</details>\n"
          end
        rescue JSON::ParserError
        end
      end

      html << "</div>\n"
      html
    end

    # ── APP CTA ──

    def render_app_cta
      return "" unless cfg("app_cta", "show_app_ctas")
      ios_url = cfg("app_cta", "ios_app_url").to_s.presence
      android_url = cfg("app_cta", "android_app_url").to_s.presence
      return "" unless ios_url || android_url

      badge_h        = cfg("app_cta", "app_badge_height") || 45
      badge_style    = cfg("app_cta", "app_badge_style") || "rounded"
      app_image      = upload("cta_image")
      ios_custom     = upload("ios_badge_image")
      android_custom = upload("android_badge_image")
      border         = cfg("app_cta", "app_cta_border_style") || "none"
      min_h          = cfg("app_cta", "app_cta_min_height") || 0

      html = +""
      html << "<section class=\"dw-app-cta dw-anim\" id=\"dw-app-cta\"#{section_style(border, min_h)}><div class=\"dw-container\">\n"
      html << "<div class=\"dw-app-cta__inner\">\n<div class=\"dw-app-cta__content\">\n"
      html << "<h2 class=\"dw-app-cta__headline\"#{title_style_val("app_cta", "app_cta_title_size")}>#{button_with_icon(cfg("app_cta", "app_cta_headline") || "Get the best experience on our app")}</h2>\n"
      subtext = cfg("app_cta", "app_cta_subtext").to_s
      html << "<p class=\"dw-app-cta__subtext\">#{e(subtext)}</p>\n" if subtext.present?
      html << "<div class=\"dw-app-cta__badges\">\n"
      html << app_badge(:ios, ios_url, ios_custom, badge_h, badge_style) if ios_url
      html << app_badge(:android, android_url, android_custom, badge_h, badge_style) if android_url
      html << "</div>\n</div>\n"
      if app_image
        html << "<div class=\"dw-app-cta__image\">\n<img src=\"#{app_image}\" alt=\"App preview\" class=\"dw-app-cta__img\">\n</div>\n"
      end
      html << "</div>\n</div></section>\n"
      html
    end

    # ── FOOTER DESC ──

    def render_footer_desc
      desc = cfg("footer", "footer_description").to_s
      return "" unless desc.present?
      "<div class=\"dw-footer-desc\"><div class=\"dw-container\">\n<p class=\"dw-footer-desc__text\">#{sanitize_html(desc)}</p>\n</div></div>\n"
    end

    # ── FOOTER ──

    def render_footer
      site_name     = SiteSetting.title
      footer_border = cfg("footer", "footer_border_style") || "solid"

      style_parts = []
      style_parts << "border-top: 1px #{footer_border} var(--dw-border);" if footer_border && footer_border != "none"
      style_attr = style_parts.any? ? " style=\"#{style_parts.join(' ')}\"" : ""

      html = +""
      html << "<footer class=\"dw-footer\" id=\"dw-footer\"#{style_attr}>\n<div class=\"dw-container\">\n"
      html << "<div class=\"dw-footer__row\">\n<div class=\"dw-footer__left\">\n<div class=\"dw-footer__brand\">"

      flogo = upload("footer_logo")
      footer_accent = cfg("design", "logo_use_accent_color")
      if flogo
        html << logo_img(flogo, site_name, "dw-footer__logo", logo_height_val, accent: footer_accent)
      elsif has_logo?
        html << render_logo(logo_dark_img, logo_light_img, site_name, "dw-footer__logo", logo_height_val, accent: footer_accent)
      else
        html << "<span class=\"dw-footer__site-name\">#{e(site_name)}</span>"
      end

      html << "</div>\n<div class=\"dw-footer__links\">\n"
      links_val = cfg("footer", "footer_links")
      if links_val.is_a?(Array)
        links_val.each { |link| html << "<a href=\"#{e(link['url'])}\" class=\"dw-footer__link\">#{e(link['label'])}</a>\n" }
      elsif links_val.is_a?(String) && links_val.present?
        begin
          links = JSON.parse(links_val)
          links.each { |link| html << "<a href=\"#{e(link['url'])}\" class=\"dw-footer__link\">#{e(link['label'])}</a>\n" }
        rescue JSON::ParserError
        end
      end
      html << "</div>\n</div>\n"

      html << "<div class=\"dw-footer__right\">\n"
      html << "<span class=\"dw-footer__copy\">&copy; #{Time.now.year} #{e(site_name)}</span>\n"
      html << "</div>\n</div>\n"

      footer_text = cfg("footer", "footer_text").to_s
      html << "<div class=\"dw-footer__text\">#{sanitize_html(footer_text)}</div>\n" if footer_text.present?

      html << "</div></footer>\n"
      html
    end

    # ── Shared helpers ──

    def stat_card(icon_svg, count, label, icon_shape = "circle", card_style = "rectangle", round_numbers = false, show_label = true)
      shape_class = icon_shape == "rounded" ? "dw-stat-icon--rounded" : "dw-stat-icon--circle"
      style_class = "dw-stat-card--#{card_style}"
      round_attr = round_numbers ? ' data-round="true"' : ''
      label_html = show_label ? "<span class=\"dw-stat-card__label\">#{e(label)}</span>\n" : ""
      "<div class=\"dw-stat-card #{style_class}\">\n" \
      "<div class=\"dw-stat-card__icon-wrap #{shape_class}\">#{icon_svg}</div>\n" \
      "<div class=\"dw-stat-card__text\">\n" \
      "<span class=\"dw-stat-card__value\" data-count=\"#{count}\"#{round_attr}>0</span>\n" \
      "#{label_html}</div>\n</div>\n"
    end

    def app_badge(platform, url, custom_img, badge_h, badge_style)
      label = platform == :ios ? "App Store" : "Google Play"
      icon  = platform == :ios ? IOS_BADGE_SVG : ANDROID_BADGE_SVG
      style_class = case badge_style.to_s
                    when "pill" then "dw-app-badge--pill"
                    when "square" then "dw-app-badge--square"
                    else "dw-app-badge--rounded"
                    end
      if custom_img
        "<a href=\"#{e(url)}\" class=\"dw-app-badge-img #{style_class}\" target=\"_blank\" rel=\"noopener noreferrer\">" \
        "<img src=\"#{e(custom_img)}\" alt=\"#{e(label)}\" style=\"height: #{badge_h}px; width: auto;\"></a>\n"
      else
        "<a href=\"#{e(url)}\" class=\"dw-app-badge #{style_class}\" target=\"_blank\" rel=\"noopener noreferrer\">" \
        "<span class=\"dw-app-badge__icon\">#{icon}</span><span class=\"dw-app-badge__label\">#{label}</span></a>\n"
      end
    end

    def render_video_modal
      return "" unless cfg("hero", "hero_video_url").to_s.present?
      "<div class=\"dw-video-modal\" id=\"dw-video-modal\">\n" \
      "<div class=\"dw-video-modal__backdrop\"></div>\n" \
      "<div class=\"dw-video-modal__content\">\n" \
      "<button class=\"dw-video-modal__close\" aria-label=\"Close video\">&times;</button>\n" \
      "<div class=\"dw-video-modal__player\" id=\"dw-video-player\"></div>\n" \
      "</div>\n</div>\n"
    end

    def render_designer_badge
      return "" if defined?(DomniqWebPage::LicenseChecker) && DomniqWebPage::LicenseChecker.badge_hidden?

      logo_path = File.join(DomniqWebPage::PLUGIN_DIR, "assets", "images", "badge.png")
      begin
        logo_b64 = Base64.strict_encode64(File.binread(logo_path))
      rescue StandardError
        return ""
      end

      "<div class=\"dw-designer-badge\" id=\"dw-designer-badge\">\n" \
      "  <div class=\"dw-designer-badge__tooltip\" id=\"dw-designer-tooltip\">\n" \
      "    <a href=\"https://domniq.app\" target=\"_blank\" rel=\"noopener noreferrer\">Powered by Domniq.app</a>\n" \
      "  </div>\n" \
      "  <img class=\"dw-designer-badge__logo\" src=\"data:image/png;base64,#{logo_b64}\" alt=\"Designer\">\n" \
      "</div>\n"
    end

    def render_theme_sounds
      sound_dir = File.join(DomniqWebPage::PLUGIN_DIR, "assets", "sounds")
      on_b64  = Base64.strict_encode64(File.binread(File.join(sound_dir, "switch-on.mp3"))) rescue nil
      off_b64 = Base64.strict_encode64(File.binread(File.join(sound_dir, "switch-off.mp3"))) rescue nil
      return "" unless on_b64 && off_b64

      "<script>" \
      "window.__dwSoundOn=\"data:audio/mpeg;base64,#{on_b64}\";" \
      "window.__dwSoundOff=\"data:audio/mpeg;base64,#{off_b64}\";" \
      "</script>\n"
    end

    def render_social_icons
      icons = {
        "social_twitter_url"   => SOCIAL_TWITTER_SVG,
        "social_facebook_url"  => SOCIAL_FACEBOOK_SVG,
        "social_instagram_url" => SOCIAL_INSTAGRAM_SVG,
        "social_youtube_url"   => SOCIAL_YOUTUBE_SVG,
        "social_tiktok_url"    => SOCIAL_TIKTOK_SVG,
        "social_github_url"    => SOCIAL_GITHUB_SVG,
      }
      links = +""
      icons.each do |key, svg|
        url = cfg("navbar", key).to_s.presence
        next unless url
        platform = key.split("_")[1].capitalize
        links << "<a href=\"#{e(url)}\" class=\"dw-social-icon\" target=\"_blank\" rel=\"noopener noreferrer\" aria-label=\"#{platform}\">#{svg}</a>\n"
      end
      return "" if links.empty?
      "<div class=\"dw-social-icons\">#{links}</div>\n"
    end

    def theme_toggle
      "<button class=\"dw-theme-toggle\" aria-label=\"Toggle theme\">#{SUN_SVG}#{MOON_SVG}</button>\n"
    end

    def render_json_ld(site_name, base_url, logo_url)
      org = { "@type" => "Organization", "name" => site_name, "url" => base_url }
      org["logo"] = logo_url if logo_url
      website = { "@type" => "WebSite", "name" => site_name, "url" => base_url }
      { "@context" => "https://schema.org", "@graph" => [org, website] }.to_json
    end

    def logo_dark_img
      return @logo_dark_img if defined?(@logo_dark_img)
      dark  = upload("logo_dark")
      light = upload("logo_light")
      @logo_dark_img = dark || (light.nil? ? nil : nil)
    end

    def logo_light_img
      return @logo_light_img if defined?(@logo_light_img)
      @logo_light_img = upload("logo_light")
    end

    def has_logo?
      logo_dark_img.present? || logo_light_img.present?
    end

    def logo_height_val
      @logo_height_val ||= (cfg("design", "logo_height") || 30).to_i
    end

    def title_style_val(type, size_key, letter_spacing_key = nil)
      parts = []
      size = (cfg(type, size_key) || 0).to_i
      parts << "font-size: #{size}px" if size > 0
      if letter_spacing_key
        ls = (cfg(type, letter_spacing_key) || 0).to_i
        parts << "letter-spacing: #{ls}px" if ls != 0
      end
      parts.any? ? " style=\"#{parts.join('; ')}\"" : ""
    end

    def icon_tag(name, extra_class = nil, size = nil)
      lib = (cfg("general", "icon_library") || "none").to_s
      cls = extra_class ? " #{extra_class}" : ""
      style = size ? " style=\"font-size: #{size.to_i}px\"" : ""
      case lib
      when "fontawesome"
        "<i class=\"fa-solid fa-#{e(name)}#{cls}\"#{style}></i>"
      when "google"
        "<span class=\"material-symbols-outlined#{cls}\"#{style}>#{e(name)}</span>"
      else
        nil
      end
    end

    def parse_icon_label(raw)
      parts = raw.split("|").map(&:strip)
      return nil if parts.length < 2
      if parts.length >= 3
        if parts[0].match?(/\A[\w-]+\z/) && parts[0].length < 30
          size = parts[1].match?(/\A\d+\z/) ? parts[1].to_i : nil
          label = size ? parts[2..].join(" | ") : parts[1..].join(" | ")
          return [parts[0], size, label]
        elsif parts[-1].match?(/\A[\w-]+\z/) && parts[-1].length < 30
          size = parts[-2].match?(/\A\d+\z/) ? parts[-2].to_i : nil
          label = size ? parts[0..-3].join(" | ") : parts[0..-2].join(" | ")
          return [parts[-1], size, label, :after]
        end
      else
        left, right = parts
        if left.match?(/\A[\w-]+\z/) && left.length < 30
          return [left, nil, right]
        elsif right.match?(/\A[\w-]+\z/) && right.length < 30
          return [right, nil, left, :after]
        end
      end
      nil
    end

    def leaderboard_stat(count, raw_label, default_svg)
      lib = (cfg("general", "icon_library") || "none").to_s
      if lib != "none" && raw_label.include?("|")
        parsed = parse_icon_label(raw_label)
        if parsed && (icon_html = icon_tag(parsed[0], "dw-leaderboard-stat__icon", parsed[1]))
          label = parsed[2]
        else
          icon_html = default_svg
          label = raw_label
        end
      else
        icon_html = default_svg
        label = raw_label
      end
      "<div class=\"dw-leaderboard-stat\">" \
        "<span class=\"dw-leaderboard-stat__value\">#{icon_html}#{count}</span>" \
        "<span class=\"dw-leaderboard-stat__label\">#{e(label)}</span></div>\n"
    end

    def button_with_icon(raw_label)
      raw_label = raw_label.to_s
      lib = (cfg("general", "icon_library") || "none").to_s
      return e(raw_label) unless lib != "none" && raw_label.include?("|")
      parsed = parse_icon_label(raw_label)
      return e(raw_label) unless parsed
      icon = icon_tag(parsed[0], nil, parsed[1])
      return e(raw_label) unless icon
      label = e(parsed[2])
      parsed[3] == :after ? "#{label} #{icon}" : "#{icon} #{label}"
    end

    # ── CSS & JS assets (minified and cached) ──

    def landing_css
      @@cached_css ||= begin
        css_path = File.join(DomniqWebPage::PLUGIN_DIR, "assets", "stylesheets", "dwp", "landing.css")
        raw = File.read(css_path)
        minify_css(raw)
      rescue Errno::ENOENT
        ""
      end
    end

    def landing_js
      @@cached_js ||= begin
        js_path = File.join(DomniqWebPage::PLUGIN_DIR, "assets", "javascripts", "dwp", "landing.js")
        raw = File.read(js_path)
        minify_js(raw)
      rescue Errno::ENOENT
        ""
      end
    end

    def minify_css(css)
      css = css.gsub(%r{/\*.*?\*/}m, "")        # remove block comments
      css = css.gsub(%r{//[^\n]*}, "")           # remove line comments
      css = css.gsub(/\s*\n\s*/, "\n")           # collapse blank lines
      css = css.gsub(/\n+/, "\n")                # multiple newlines → one
      css = css.gsub(/:\s+/, ":")                # space after colon
      css = css.gsub(/;\s+/, ";")                # space after semicolon
      css = css.gsub(/\s*\{\s*/, "{")            # space around {
      css = css.gsub(/\s*\}\s*/, "}")            # space around }
      css = css.gsub(/\s*,\s*/, ",")             # space around comma
      css = css.gsub(/;\}/, "}")                 # remove trailing semicolons
      css.strip
    end

    def minify_js(js)
      js = js.gsub(%r{/\*.*?\*/}m, "")           # remove block comments
      js = js.gsub(%r{(?<![:"'])//[^\n]*}, "")   # remove line comments (not in strings)
      js = js.gsub(/[ \t]+/, " ")                # collapse horizontal whitespace
      js = js.gsub(/\n\s*\n+/, "\n")             # collapse blank lines
      js = js.gsub(/\n\s*/, "\n")                # trim leading whitespace on lines
      js.strip
    end
  end
end
