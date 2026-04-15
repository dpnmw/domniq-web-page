# frozen_string_literal: true

DomniqWebPage::Engine.routes.draw do
end

Discourse::Application.routes.draw do
  scope "/admin/plugins/domniq-web-page", constraints: AdminConstraint.new do
    scope format: false do
      get "/dwp-overview"  => "dwp/admin#index"
      get "/dwp-general"   => "dwp/admin#index"
      get "/dwp-design"    => "dwp/admin#index"
      get "/dwp-sections"  => "dwp/admin#index"
      get "/dwp-navbar"    => "dwp/admin#index"
      get "/dwp-footer"    => "dwp/admin#index"
      get "/dwp-support"   => "dwp/admin#index"
    end

    scope format: :json do
      get  "/configs/:config_type" => "dwp/admin_configs#show"
      put  "/configs/:config_type" => "dwp/admin_configs#bulk_update"
      get  "/license/status"       => "dwp/admin_license#status"
      post "/license/check"        => "dwp/admin_license#check"
    end
  end
end
