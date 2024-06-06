module Twinkle
  class Summary < ApplicationRecord
    belongs_to :app, foreign_key: :twinkle_app_id, class_name: 'Twinkle::App'
    has_many :datapoints, foreign_key: :twinkle_summary_id, class_name: 'Twinkle::Datapoint', dependent: :delete_all

    # Virtual relationships
    has_one :latest_user_summary, -> { where(name: 'users').order('twinkle_datapoints.value desc').limit(1) }, foreign_key: :twinkle_summary_id, class_name: 'Twinkle::Datapoint'

    scope :since, ->(date) { where('twinkle_summaries.start_date >= ?', date).order('twinkle_summaries.start_date asc') }
    scope :week_of, -> (start_date, end_date) { where(period: :week).where("start_date >= ? AND end_date <= ?", start_date, end_date) }

    enum period: { week: 0, fortnight: 1, month: 2 }

    def hash_datapoints
      data = Event.fields.map { |name| [name, {}] }.append(['users', {}]).to_h
      datapoints.each do |datapoint|
        data[datapoint.name][datapoint.value] = datapoint.count
      end
      data
    end

    def self.empty_datapoints_hash
      Event.fields.map { |name| [name, {}] }.append(['users', {}]).to_h
    end
  end
end
