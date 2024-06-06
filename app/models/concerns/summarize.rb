module Summarize
  extend ActiveSupport::Concern

  included do
    def summarize_events(period, start_date, end_date)
      # Find or create a summary for the week
      summary = Twinkle::Summary.find_or_create_by(app: self, period: period, start_date: start_date, end_date: end_date)
      data_hash = get_data_hash(start_date, end_date)
      datapoints = get_datapoints(summary, data_hash)
      save_summary(datapoints)
    end

    def get_data_hash(start_date, end_date)
      data_hash = Twinkle::Summary.empty_datapoints_hash()
      
      # We're going to accumulate the data points for the summary
      events.created_between(start_date, end_date).find_each do |event|
        data_hash['users']['sessions'] = (data_hash.dig('users', 'sessions') || 0) + 1
        Twinkle::Event.fields.each do |field|
          data_hash[field][event[field]] = (data_hash.dig(field, event[field]) || 0) + 1 if event[field].present?
        end
      end
      data_hash
    end

    def get_datapoints(summary, data_hash)
      datapoints = []
      data_hash.each do |name, values|
        values.each do |value, count|
          datapoints << {twinkle_summary_id: summary.id, name: name, value: value, count: count}
        end
      end
      datapoints
    end

    def save_summary(datapoints)
      Twinkle::Datapoint.upsert_all(
        datapoints,
        unique_by: [:twinkle_summary_id, :name, :value],
        update_only: [:count]
      )
    end
  end
end