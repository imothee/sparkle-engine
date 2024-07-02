require "test_helper"

class VersionTest < ActiveSupport::TestCase
  test "versions require a version number, build, description, binary_url, and length when published" do
    version = Twinkle::Version.new(published: true)
    assert_not version.save
    assert_equal ["can't be blank"], version.errors[:number]
    assert_equal ["is not a number"], version.errors[:build]
    assert_equal ["can't be blank"], version.errors[:description]
    assert_equal ["can't be blank"], version.errors[:binary_url]
    assert_equal ["can't be blank"], version.errors[:length]
  end

  test "only requires a version number and build when not published" do
    version = Twinkle::Version.new(published: false)
    assert_not version.save
    assert_equal ["can't be blank"], version.errors[:number]
    assert_equal ["is not a number"], version.errors[:build]
    assert_equal [], version.errors[:description]
    assert_equal [], version.errors[:binary_url]
    assert_equal [], version.errors[:length]
  end

  test "versions require a valid URL for the binary_url" do
    version = Twinkle::Version.new(binary_url: "not-a-url")
    assert_not version.save
    assert_equal ["is not a valid URL"], version.errors[:binary_url]
  end

  test "versions require a valid URL for the release_notes_link" do
    version = Twinkle::Version.new(release_notes_link: "not-a-url")
    assert_not version.save
    assert_equal ["is not a valid URL"], version.errors[:release_notes_link]
  end

  test "versions require a valid URL for the full_release_notes_link" do
    version = Twinkle::Version.new(full_release_notes_link: "not-a-url")
    assert_not version.save
    assert_equal ["is not a valid URL"], version.errors[:full_release_notes_link]
  end

  test "versions require a positive integer for the length" do
    version = Twinkle::Version.new(length: -1)
    assert_not version.save
    assert_equal ["must be greater than 0"], version.errors[:length]
  end

  test "versions require at least one of the two signatures" do
    version = Twinkle::Version.new(published: true)
    assert_not version.save
    assert_equal ["At least one of the two signatures must be present"], version.errors[:base]
  end

  test "versions accept a valid URL for the binary_url" do
    version = Twinkle::Version.new(binary_url: "https://example.com")
    assert_not version.save
    assert_equal [], version.errors[:binary_url]
  end

  test "versions accept a valid URL for the release_notes_link" do
    version = Twinkle::Version.new(release_notes_link: "https://example.com")
    assert_not version.save
    assert_equal [], version.errors[:release_notes_link]
  end

  test "versions accept a valid URL for the full_release_notes_link" do
    version = Twinkle::Version.new(full_release_notes_link: "https://example.com")
    assert_not version.save
    assert_equal [], version.errors[:full_release_notes_link]
  end

  test "published at should be set when a version is published" do
    version = twinkle_versions(:unpublished)
    assert_nil version.published_at
    version.published = true
    version.save
    assert_not_nil version.published_at
  end

  test "published at should not be set when a version is unpublished" do
    version = twinkle_versions(:latest)
    assert_not_nil version.published_at
    version.published = false
    version.save
    assert_nil version.published_at
  end

  test "published at should not change when re-saving a published version" do
    version = twinkle_versions(:latest)
    published_at = version.published_at
    version.save
    assert_equal published_at, version.published_at
  end

  test "phased rollout interval must be a positive integer" do
    version = Twinkle::Version.new(phased_rollout_interval: -1)
    assert_not version.save
    assert_equal ["must be greater than 0"], version.errors[:phased_rollout_interval]
  end
end
