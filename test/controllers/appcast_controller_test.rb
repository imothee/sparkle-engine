require "test_helper"

class AppcastControllerTest < ActionDispatch::IntegrationTest
  test "should get a valid appcast" do
    get '/twinkle/updates/tmpdisk'
    assert_response :success
    assert_equal 'application/xml', @response.media_type
    
    xml_doc  = Nokogiri::XML(@response.body)
    assert_equal 'TmpDisk', xml_doc.at_xpath('/rss/channel/title').text
    assert_equal twinkle_versions(:latest).build.to_s, xml_doc.at_xpath('/rss/channel/item/sparkle:version').text
  end

  test "should order the appcast by build" do
    get '/twinkle/updates/tmpdisk'
    assert_response :success
    assert_equal 'application/xml', @response.media_type
    
    xml_doc  = Nokogiri::XML(@response.body)
    builds = xml_doc.xpath('/rss/channel/item/sparkle:version').map(&:text)
    assert_equal twinkle_versions(:latest).build.to_s, builds.first
    assert_equal twinkle_versions(:oldest).build.to_s, builds.last
  end

  test "should handle minimum system version" do
    get '/twinkle/updates/tmpdisk'
    assert_response :success
    assert_equal 'application/xml', @response.media_type
    
    xml_doc  = Nokogiri::XML(@response.body)
    assert_equal twinkle_versions(:latest).min_system_version, xml_doc.at_xpath('/rss/channel/item/sparkle:minimumSystemVersion').text
  end

  test "should handle maximum system version" do
    get '/twinkle/updates/tmpdisk'
    assert_response :success
    assert_equal 'application/xml', @response.media_type
    
    xml_doc  = Nokogiri::XML(@response.body)
    assert_equal twinkle_versions(:oldest).max_system_version, xml_doc.at_xpath('/rss/channel/item/sparkle:maximumSystemVersion').text
  end

  test "should handle minimum auto update version" do
    get '/twinkle/updates/tmpdisk'
    assert_response :success
    assert_equal 'application/xml', @response.media_type
    
    xml_doc  = Nokogiri::XML(@response.body)
    assert_equal twinkle_versions(:latest).minimum_auto_update_version, xml_doc.at_xpath('/rss/channel/item/sparkle:minimumAutoupdateVersion').text
  end

  test "should handle ignore skipped upgrades below version" do
    get '/twinkle/updates/tmpdisk'
    assert_response :success
    assert_equal 'application/xml', @response.media_type
    
    xml_doc  = Nokogiri::XML(@response.body)
    assert_equal twinkle_versions(:latest).ignore_skipped_upgrades_below_version, xml_doc.at_xpath('/rss/channel/item/sparkle:ignoreSkippedUpgradesBelowVersion').text
  end

  test "should handle informational update below version" do
    get '/twinkle/updates/tmpdisk'
    assert_response :success
    assert_equal 'application/xml', @response.media_type
    
    xml_doc  = Nokogiri::XML(@response.body)
    assert_equal twinkle_versions(:latest).informational_update_below_version, xml_doc.at_xpath('/rss/channel/item/sparkle:informationalUpdate/sparkle:belowVersion').text
  end

  test "should handle critical updates sparkle 1" do
    get '/twinkle/updates/tmpdisk'
    assert_response :success
    assert_equal 'application/xml', @response.media_type
    
    xml_doc  = Nokogiri::XML(@response.body)
    assert_not_nil xml_doc.at_xpath('/rss/channel/item/sparkle:tags/sparkle:criticalUpdate')
  end

  test "should handle critical updates sparkle 2" do
    twinkle_versions(:critical).update(sparkle_two: true)
    get '/twinkle/updates/tmpdisk'
    assert_response :success
    assert_equal 'application/xml', @response.media_type
    
    xml_doc  = Nokogiri::XML(@response.body)
    assert_not_nil xml_doc.at_xpath('/rss/channel/item/sparkle:criticalUpdate')
    assert_nil xml_doc.at_xpath('/rss/channel/item/sparkle:criticalUpdate')['sparkle:version']
  end

  test "should handle critical version" do
    twinkle_versions(:critical).update(sparkle_two: true, critical_version: '1.0.0')
    get '/twinkle/updates/tmpdisk'
    assert_response :success
    assert_equal 'application/xml', @response.media_type
    
    xml_doc  = Nokogiri::XML(@response.body)
    assert_equal '1.0.0', xml_doc.at_xpath('/rss/channel/item/sparkle:criticalUpdate')['sparkle:version']
  end

  test "should handle phased rollout interval" do
    get '/twinkle/updates/tmpdisk'
    assert_response :success
    assert_equal 'application/xml', @response.media_type
    
    xml_doc  = Nokogiri::XML(@response.body)
    assert_equal twinkle_versions(:latest).phased_rollout_interval.to_s, xml_doc.at_xpath('/rss/channel/item/sparkle:phasedRolloutInterval').text
  end

  test "should handle channel" do
    twinkle_versions(:latest).update(channel: 'beta')
    get '/twinkle/updates/tmpdisk'
    assert_response :success
    assert_equal 'application/xml', @response.media_type
    
    xml_doc  = Nokogiri::XML(@response.body)
    assert_equal 'beta', xml_doc.at_xpath('/rss/channel/item/sparkle:channel').text
  end

  test "should handle release notes link" do
    get '/twinkle/updates/tmpdisk'
    assert_response :success
    assert_equal 'application/xml', @response.media_type
    
    xml_doc  = Nokogiri::XML(@response.body)
    assert_equal twinkle_versions(:latest).release_notes_link, xml_doc.at_xpath('/rss/channel/item/sparkle:releaseNotesLink').text
  end

  test "should handle full release notes link" do
    get '/twinkle/updates/tmpdisk'
    assert_response :success
    assert_equal 'application/xml', @response.media_type
    
    xml_doc  = Nokogiri::XML(@response.body)
    assert_equal twinkle_versions(:latest).full_release_notes_link, xml_doc.at_xpath('/rss/channel/item/sparkle:fullReleaseNotesLink').text
  end

  test "should handle profile information" do
    get '/twinkle/updates/tmpdisk.xml?osVersion=14.5.0&cputype=16777228&cpu64bit=1&cpusubtype=2&model=MacBookPro18,2&ncpu=10&lang=en-US&appName=TmpDisk&appVersion=1013&ramMB=32768'
    assert_response :success
    
    event = Twinkle::Event.last
    assert_equal '14.5.0', event.os_version
    assert_equal "16777228", event.cputype
    assert_equal true, event.cpu64bit
    assert_equal "2", event.cpusubtype
    assert_equal 'MacBookPro18,2', event.model
    assert_equal 10, event.ncpu
    assert_equal 'en-US', event.lang
    assert_equal "32768", event.ram_mb
    assert_equal '1013', event.version
  end
end