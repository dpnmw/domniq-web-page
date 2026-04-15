# frozen_string_literal: true

module DomniqWebPage
  class AdminLicenseController < ::Admin::AdminController
    requires_plugin DomniqWebPage::PLUGIN_NAME

    def status
      result = DomniqWebPage::LicenseChecker.check
      render json: license_json(result)
    end

    def check
      result = DomniqWebPage::LicenseChecker.check(force: true)
      render json: license_json(result)
    end

    private

    def license_json(result)
      {
        licensed: result["license_active"] == true,
        domain: result["domain"],
        email: result["email"],
        paid_at: result["paid_at"],
        expires_at: result["expires_at"],
        last_checked: result["checked_at"],
        license_key: DomniqWebPage::LicenseChecker.license_key_masked,
      }
    end
  end
end
