# frozen_string_literal: true

module DomniqWebPage
  class AdminController < ::Admin::AdminController
    requires_plugin DomniqWebPage::PLUGIN_NAME
    def index; end
  end
end
