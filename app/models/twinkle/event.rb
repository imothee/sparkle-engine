module Twinkle
  class Event < ApplicationRecord
    belongs_to :app, foreign_key: 'twinkle_app_id', class_name: 'Twinkle::App'

    scope :created_between, -> (start_date, end_date) {where("created_at >= ? AND created_at <= ?", start_date, end_date )}

    alias_attribute :appVersion, :version
    alias_attribute :cpuFreqMHz, :cpu_freq_mhz
    alias_attribute :osVersion, :os_version
    alias_attribute :ramMB,      :ram_mb

    def self.fields
      attribute_names.select{ |name| !['id', 'twinkle_app_id', 'created_at', 'updated_at'].include?(name) }
    end
  end
end
