# frozen_string_literal: true

module DomniqWebPage
  class AdminUploadsController < ::Admin::AdminController
    requires_plugin DomniqWebPage::PLUGIN_NAME

    ALLOWED_UPLOAD_SETTINGS = %w[
      og_image favicon logo_dark logo_light footer_logo
      hero_bg_image hero_image about_image
      about_bg_image faq_image cta_image
      ios_badge_image android_badge_image
      preloader_logo_dark preloader_logo_light
    ].freeze

    def pin_upload
      upload = Upload.find(params[:upload_id])
      setting_name = params[:setting_name].to_s
      raise Discourse::InvalidParameters unless ALLOWED_UPLOAD_SETTINGS.include?(setting_name)

      key = "upload_pin_#{setting_name}"
      existing = PluginStore.get(DomniqWebPage::PLUGIN_NAME, key)
      existing_ids = existing ? existing.to_s.split(",").map(&:to_i) : []
      existing_ids << upload.id unless existing_ids.include?(upload.id)
      PluginStore.set(DomniqWebPage::PLUGIN_NAME, key, existing_ids.join(","))

      row = PluginStoreRow.find_by(plugin_name: DomniqWebPage::PLUGIN_NAME, key: key)
      UploadReference.ensure_exist!(upload_ids: existing_ids, target: row) if row

      render json: { success: true, upload_id: upload.id }
    end
  end
end
