# frozen_string_literal: true

module ::DomniqWebPage
  PLUGIN_NAME = "domniq-web-page"
  PLUGIN_DIR = File.expand_path("..", __dir__)

  def self.enabled?
    SiteSetting.dwp_enabled
  end
end

require_relative "dwp/engine"
