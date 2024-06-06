require 'uri'

module Twinkle
  class Version < ApplicationRecord
    belongs_to :app, foreign_key: 'twinkle_app_id', class_name: 'Twinkle::App'

    validates :number, presence: true
    validates :build, presence: true
    validates :description, presence: true, if: -> { published }
    validates :binary_url, presence: true, if: -> { published }
    validates :length, presence: true, if: -> { published }
    validates :length, numericality: { only_integer: true, greater_than: 0 }, allow_blank: true


    # validates that the binary_url is a valid URL
    validate :binary_url_is_url

    # validates that one of the two signatures is present
    validate :signature_present, if: -> { published }

    private 

    def binary_url_is_url
      return true if binary_url.blank?
      begin
        uri = URI.parse(binary_url)
        raise URI::InvalidURIError unless uri.is_a?(URI::HTTP) && uri.host.present?
      rescue URI::InvalidURIError
        errors.add(:binary_url, "is not a valid URL")
      end
    end

    def signature_present
      if dsa_signature.blank? && ed_signature.blank?
        errors.add(:base, "At least one of the two signatures must be present")
      end
    end
  end
end
