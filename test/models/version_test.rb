require "test_helper"

class VersionTest < ActiveSupport::TestCase
  test "versions require a version number, build, description, binary_url, and length" do
    version = Twinkle::Version.new
    assert_not version.save
    assert_equal ["can't be blank"], version.errors[:number]
    assert_equal ["can't be blank"], version.errors[:build]
    assert_equal ["can't be blank"], version.errors[:description]
    assert_equal ["can't be blank", "is not a valid URL"], version.errors[:binary_url]
    assert_equal ["can't be blank", "is not a number"], version.errors[:length]
  end

  test "versions require a valid URL for the binary_url" do
    version = Twinkle::Version.new(binary_url: "not-a-url")
    assert_not version.save
    assert_equal ["is not a valid URL"], version.errors[:binary_url]
  end

  test "versions require a positive integer for the length" do
    version = Twinkle::Version.new(length: -1)
    assert_not version.save
    assert_equal ["must be greater than 0"], version.errors[:length]
  end

  test "versions require at least one of the two signatures" do
    version = Twinkle::Version.new
    assert_not version.save
    assert_equal ["At least one of the two signatures must be present"], version.errors[:base]
  end

  test "versions accept a valid URL for the binary_url" do
    version = Twinkle::Version.new(binary_url: "https://example.com")
    assert_not version.save
    assert_equal [], version.errors[:binary_url]
  end
end
