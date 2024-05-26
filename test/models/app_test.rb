require "test_helper"

class AppTest < ActiveSupport::TestCase
  test "apps require a name, description, and slug" do
    app = Twinkle::App.new
    assert_not app.save
    assert_equal ["can't be blank"], app.errors[:name]
    assert_equal ["can't be blank"], app.errors[:description]
    assert_equal ["can't be blank"], app.errors[:slug]
  end

  test "apps require a unique slug" do
    Twinkle::App.create!(name: "Test App", description: "Test Description", slug: "test-app")
    app = Twinkle::App.new(name: "Test App", description: "Test Description", slug: "test-app")
    assert_not app.save
    assert_equal ["has already been taken"], app.errors[:slug]
  end
end
