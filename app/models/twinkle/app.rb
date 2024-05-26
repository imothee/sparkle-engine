module Twinkle
  class App < ApplicationRecord
    include Summarize
    
    has_many :versions, foreign_key: 'twinkle_app_id', class_name: 'Twinkle::Version'
    has_many :events, foreign_key: 'twinkle_app_id', class_name: 'Twinkle::Event'
    has_many :summaries, foreign_key: 'twinkle_app_id', class_name: 'Twinkle::Summary'
    has_one_attached :icon

    scope :with_versions, -> { includes(:versions).order('twinkle_versions.build desc') }
    scope :with_latest_version, -> { includes(:versions).order('twinkle_versions.build desc').limit(1) }
    scope :with_latest_summary, -> { includes(:summaries).order('twinkle_summaries.created_at desc').limit(1) }
    scope :with_summaries_since, ->(date) { includes(:summaries).where('twinkle_summaries.start >= ?', date).order('twinkle_summaries.start asc') }

    validates :name, presence: true
    validates :slug, presence: true, uniqueness: true
    validates :description, presence: true
  end
end
