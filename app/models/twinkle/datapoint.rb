module Twinkle
  class Datapoint < ApplicationRecord
    belongs_to :summary, foreign_key: :twinkle_summary_id, class_name: 'Twinkle::Summary'
  end
end
