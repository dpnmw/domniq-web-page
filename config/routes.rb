# frozen_string_literal: true

DomniqWebPage::Engine.routes.draw do
end

Discourse::Application.routes.draw do
  scope "/admin/plugins/domniq-web-page", constraints: AdminConstraint.new do
    scope format: false do
      get "/dwp-overview"  => "domniq_web_page/admin#index"
      get "/dwp-general"   => "domniq_web_page/admin#index"
      get "/dwp-design"    => "domniq_web_page/admin#index"
      get "/dwp-sections"  => "domniq_web_page/admin#index"
      get "/dwp-navbar"    => "domniq_web_page/admin#index"
      get "/dwp-footer"    => "domniq_web_page/admin#index"
      get "/dwp-premium"   => "domniq_web_page/admin#index"
    end

    scope format: :json do
      get  "/configs/:config_type" => "domniq_web_page/admin_configs#show"
      put  "/configs/:config_type" => "domniq_web_page/admin_configs#bulk_update"
      get  "/license/status"       => "domniq_web_page/admin_license#status"
      post "/license/activate"    => "domniq_web_page/admin_license#activate"
      post "/license/check"        => "domniq_web_page/admin_license#check"
      put  "/license/telemetry"    => "domniq_web_page/admin_license#update_telemetry"
      post "/admin/pin-upload"     => "domniq_web_page/admin_uploads#pin_upload"
      get  "/landing-css"          => "domniq_web_page/admin#landing_css"
    end
  end
end
