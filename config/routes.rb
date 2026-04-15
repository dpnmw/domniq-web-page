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
      get "/dwp-support"   => "domniq_web_page/admin#index"
    end

    scope format: :json do
      get  "/configs/:config_type" => "domniq_web_page/admin_configs#show"
      put  "/configs/:config_type" => "domniq_web_page/admin_configs#bulk_update"
      get  "/license/status"       => "domniq_web_page/admin_license#status"
      post "/license/check"        => "domniq_web_page/admin_license#check"
    end
  end
end
