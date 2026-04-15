# frozen_string_literal: true

module DomniqWebPage
  class AdminLicenseController < ::Admin::AdminController
    requires_plugin DomniqWebPage::PLUGIN_NAME

    def status
      checker = defined?(DomniqWebPage::LicenseChecker) ? DomniqWebPage::LicenseChecker : nil
      render json: {
        licensed:    checker&.licensed?    || false,
        license_key: checker&.license_key_masked,
        expires_at:  checker&.expires_at,
      }
    end

    def check
      checker = defined?(DomniqWebPage::LicenseChecker) ? DomniqWebPage::LicenseChecker : nil
      render json: checker&.check || { licensed: false, error: "License checker not available." }
    end
  end
end
