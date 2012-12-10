# This is a sanity check.

require 'minitest/autorun'
require 'rake'                  # for FileUtils::RUBY

class SmokeTest < MiniTest::Unit::TestCase
  def test_list_sources
    # Check the output before loading test module
    output = `#{list_sources_command}`
    refute_match /TEST_SOURCE Sine source at 440 Hz/, output

    # Now load a test source module
    module_id = 
      `pactl load-module module-sine-source source_name=TEST_SOURCE`.strip
    output = `#{list_sources_command}`

    # This time the test module should be listed
    assert_match /TEST_SOURCE Sine source at 440 Hz/, output

  ensure
    # Clean up the test module and verify the cleanup succeeded
    `pactl unload-module #{module_id}` if module_id
  end

  def list_sources_command
    script_path= File.expand_path("../../list-sources.rb", __FILE__)
    "#{FileUtils::RUBY} #{script_path}"
  end
end
