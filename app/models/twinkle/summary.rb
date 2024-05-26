module Twinkle
  class Summary < ApplicationRecord
    belongs_to :app, foreign_key: :twinkle_app_id, class_name: 'Twinkle::App'
    has_many :datapoints, foreign_key: :twinkle_summary_id, class_name: 'Twinkle::Datapoint'

    scope :week_of, -> (start_date, end_date) { where(period: :week).where("start_date >= ? AND end_date <= ?", start_date, end_date) }
    scope :with_datapoints, -> { includes(:datapoints) }

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
