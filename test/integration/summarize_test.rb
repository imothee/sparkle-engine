require "test_helper"

class SummarizeTest < ActionDispatch::IntegrationTest
  test "gets a valid empty datapoints hash" do
    summary = Twinkle::Summary.new

    assert_equal Twinkle::Summary.empty_datapoints_hash, {
      "version"=>{},
      "cpu64bit"=>{}, 
      "ncpu"=>{}, 
      "cpu_freq_mhz"=>{}, 
      "cputype"=>{}, 
      "cpusubtype"=>{}, 
      "model"=>{}, 
      "ram_mb"=>{}, 
      "os_version"=>{}, 
      "lang"=>{}, 
      "users"=>{}
    }
  end

  test "gets a valid data hash" do
    app = Twinkle::App.create(name: "Test App", slug: "test-app", description: "Test Description")
    event = Twinkle::Event.create(app: app, version: "1.0.0", cpu64bit: true, ncpu: 4, cpu_freq_mhz: 2800, cputype: "Intel", cpusubtype: "Core i7", model: "MacBook Pro", ram_mb: 16384, os_version: "11.5", lang: "en-US")
    week_start = Time.now.beginning_of_week
    week_end = Time.now.end_of_week

    data_hash = app.get_data_hash(week_start, week_end)

    assert_equal data_hash, {
      "version"=>{"1.0.0"=>1},
      "cpu64bit"=>{true=>1}, 
      "ncpu"=>{4=>1}, 
      "cpu_freq_mhz"=>{"2800"=>1}, 
      "cputype"=>{"Intel"=>1}, 
      "cpusubtype"=>{"Core i7"=>1}, 
      "model"=>{"MacBook Pro"=>1}, 
      "ram_mb"=>{"16384"=>1}, 
      "os_version"=>{"11.5"=>1}, 
      "lang"=>{"en-US"=>1}, 
      "users"=>{"sessions"=>1}
    }
  end

  test "properly sums up datapoints" do
    app = Twinkle::App.create(name: "Test App", slug: "test-app", description: "Test Description")
    Twinkle::Event.create(app: app, version: "1.0.0", cpu64bit: true, ncpu: 4, cpu_freq_mhz: 2800, cputype: "Intel", cpusubtype: "Core i7", model: "MacBook Pro", ram_mb: 16384, os_version: "11.5", lang: "en-US")
    Twinkle::Event.create(app: app, version: "1.0.0", cpu64bit: true, ncpu: 4, cpu_freq_mhz: 2800, cputype: "Intel", cpusubtype: "Core i7", model: "MacBook Pro", ram_mb: 16384, os_version: "11.5", lang: "en-US")
    week_start = Time.now.beginning_of_week
    week_end = Time.now.end_of_week

    data_hash = app.get_data_hash(week_start, week_end)

    assert_equal data_hash, {
      "version"=>{"1.0.0"=>2},
      "cpu64bit"=>{true=>2}, 
      "ncpu"=>{4=>2}, 
      "cpu_freq_mhz"=>{"2800"=>2}, 
      "cputype"=>{"Intel"=>2}, 
      "cpusubtype"=>{"Core i7"=>2}, 
      "model"=>{"MacBook Pro"=>2}, 
      "ram_mb"=>{"16384"=>2}, 
      "os_version"=>{"11.5"=>2},
      "lang"=>{"en-US"=>2},
      "users"=>{"sessions"=>2}
    }
  end

  test "saves a summary" do
    app = Twinkle::App.create(name: "Test App", slug: "test-app", description: "Test Description")
    Twinkle::Event.create(app: app, version: "1.0.0", cpu64bit: true, ncpu: 4, cpu_freq_mhz: 2800, cputype: "Intel", cpusubtype: "Core i7", model: "MacBook Pro", ram_mb: 16384, os_version: "11.5", lang: "en-US")
    Twinkle::Event.create(app: app, version: "1.0.0", cpu64bit: true, ncpu: 4, cpu_freq_mhz: 2800, cputype: "Intel", cpusubtype: "Core i7", model: "MacBook Pro", ram_mb: 16384, os_version: "11.5", lang: "en-US")
    week_start = Time.now.beginning_of_week
    week_end = Time.now.end_of_week

    app.summarize_events(:week, week_start, week_end)
    assert_equal Twinkle::Summary.count, 1
    assert_equal Twinkle::Datapoint.count, 11
    assert_equal Twinkle::Summary.first.datapoints.count, 11
    assert_equal Twinkle::Summary.first.datapoints.first.name, "version"
    assert_equal Twinkle::Summary.first.datapoints.first.value, "1.0.0"
    assert_equal Twinkle::Summary.first.datapoints.first.count, 2
  end

  test "updates a summary" do
    app = Twinkle::App.create(name: "Test App", slug: "test-app", description: "Test Description")
    Twinkle::Event.create(app: app, version: "1.0.0", cpu64bit: true, ncpu: 4, cpu_freq_mhz: 2800, cputype: "Intel", cpusubtype: "Core i7", model: "MacBook Pro", ram_mb: 16384, os_version: "11.5", lang: "en-US")
    Twinkle::Event.create(app: app, version: "1.0.0", cpu64bit: true, ncpu: 4, cpu_freq_mhz: 2800, cputype: "Intel", cpusubtype: "Core i7", model: "MacBook Pro", ram_mb: 16384, os_version: "11.5", lang: "en-US")
    week_start = Time.now.beginning_of_week
    week_end = Time.now.end_of_week

    app.summarize_events(:week, week_start, week_end)
    app.summarize_events(:week, week_start, week_end)
    assert_equal Twinkle::Summary.count, 1
    assert_equal Twinkle::Datapoint.count, 11
    assert_equal Twinkle::Summary.first.datapoints.count, 11
    assert_equal Twinkle::Summary.first.datapoints.first.name, "version"
    assert_equal Twinkle::Summary.first.datapoints.first.value, "1.0.0"
    assert_equal Twinkle::Summary.first.datapoints.first.count, 2
  end
end
