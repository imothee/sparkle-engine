module Twinkle
  module Concerns
    module Models
      module App
        extend ActiveSupport::Concern

        included do
          has_many :versions,  -> { order('twinkle_versions.build desc') }, foreign_key: 'twinkle_app_id', class_name: 'Twinkle::Version', dependent: :destroy
          has_many :events, foreign_key: 'twinkle_app_id', class_name: 'Twinkle::Event', dependent: :delete_all
          has_many :summaries, foreign_key: 'twinkle_app_id', class_name: 'Twinkle::Summary', dependent: :destroy
          has_one_attached :icon

          # Virtual relationships
          has_one :latest_version, -> { order('twinkle_versions.build desc').limit(1) }, foreign_key: 'twinkle_app_id', class_name: 'Twinkle::Version'
          has_one :latest_weekly_summary, -> { where(period: :week).order('twinkle_summaries.start_date desc').limit(1) }, foreign_key: 'twinkle_app_id', class_name: 'Twinkle::Summary'

          validates :name, presence: true
          validates :slug, presence: true, uniqueness: true
          validates :description, presence: true
        end
      end
    end
  end
end
