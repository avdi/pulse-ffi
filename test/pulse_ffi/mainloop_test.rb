$LOAD_PATH.unshift(File.expand_path('../../../lib', __FILE__))
require 'minitest/autorun'
require 'pulse_ffi/mainloop'
require 'rspec/mocks'

module PulseFFI
  class MainloopTest < MiniTest::Unit::TestCase
    def setup
      RSpec::Mocks.setup(self)
    end

    def teardown
      RSpec::Mocks.verify
    ensure
      RSpec::Mocks.teardown
    end

    def test_initialize_creates_mainloop
      api = double(pa_mainloop_new: :mainloop_ptr)
      loop = Mainloop.new(api: api)
      assert_equal :mainloop_ptr, loop.pointer
    end

    def test_run_starts_mainloop
      api = double(pa_mainloop_new: mainloop_ptr = double)
      loop = Mainloop.new(api: api)
      api.should_receive(:pa_mainloop_run).with(mainloop_ptr, nil)
      loop.run
    end

    def test_free_frees_mainloop
      api = double(pa_mainloop_new: mainloop_ptr = double)
      loop = Mainloop.new(api: api)
      api.should_receive(:pa_mainloop_free).with(mainloop_ptr)
      loop.free
    end
  end
end
