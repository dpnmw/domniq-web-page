# frozen_string_literal: true

module DomniqWebPage
  class Config < ActiveRecord::Base
    self.table_name = "dwp_configs"

    VALID_TYPES = %w[
      general design hero stats about leaderboard topics faq app_cta navbar footer
    ].freeze

    validates :config_type,  presence: true, inclusion: { in: VALID_TYPES }
    validates :config_key,   presence: true
    validates :config_key,   uniqueness: { scope: :config_type }

    scope :for_type, ->(type) { where(config_type: type) }
    scope :active,   -> { where(enabled: true) }
  end
end
