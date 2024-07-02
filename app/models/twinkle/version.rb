require 'uri'

module Twinkle
  class Version < ApplicationRecord
    belongs_to :app, foreign_key: 'twinkle_app_id', class_name: 'Twinkle::App'

    scope :published, -> { where(published: true) }

    before_save :set_published_at

    validates :number, presence: true
    validates :build, numericality: { only_integer: true, greater_than: 0 }
    validates :description, presence: true, if: -> { published }
    validates :binary_url, presence: true, if: -> { published }
    validates :length, presence: true, if: -> { published }
    validates :length, numericality: { only_integer: true, greater_than: 0 }, allow_blank: true
    validates :phased_rollout_interval, numericality: { only_integer: true, greater_than: 0 }, allow_blank: true

    # validates that the binary_url is a valid URL
    validate :binary_url_is_url

    # validates that the release_notes_link is a valid URL
    validate :release_notes_link_is_url

    # validates that the full_release_notes_link is a valid URL
    validate :full_release_notes_link_is_url

    # validates that one of the two signatures is present
    validate :signature_present, if: -> { published }

    private 

    def binary_url_is_url
      return true if binary_url.blank?
      errors.add(:binary_url, "is not a valid URL") unless is_url?(binary_url)
    end

    def release_notes_link_is_url
      return true if release_notes_link.blank?
      errors.add(:release_notes_link, "is not a valid URL") unless is_url?(release_notes_link)
    end

    def full_release_notes_link_is_url
      return true if full_release_notes_link.blank?
      errors.add(:full_release_notes_link, "is not a valid URL") unless is_url?(full_release_notes_link)
    end

    def signature_present
      if dsa_signature.blank? && ed_signature.blank?
        errors.add(:base, "At least one of the two signatures must be present")
      end
    end

    def is_url?(url)
      uri = URI.parse(url)
      uri.is_a?(URI::HTTP) && uri.host.present?
    rescue URI::InvalidURIError
      false
    end

    def set_published_at
      if published && published_at.nil?
        self.published_at = Time.now
      elsif !published && published_at.present?
        self.published_at = nil
      end
    end
  end
end
