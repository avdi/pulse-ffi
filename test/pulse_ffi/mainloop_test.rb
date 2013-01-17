$LOAD_PATH.unshift(File.expand_path('../../../lib', __FILE__))
require 'minitest/autorun'
require 'pulse_ffi/mainloop'
require 'ostruct'

module PulseFFI
  class MainloopTest < MiniTest::Unit::TestCase
    def test_initialize_creates_mainloop
      api = OpenStruct.new(pa_mainloop_new: :mainloop_ptr)
      loop = Mainloop.new(api: api)
      assert_equal :mainloop_ptr, loop.pointer
    end

    def test_run_starts_mainloop
      api = MiniTest::Mock.new
      def api.pa_mainloop_new
        :mainloop_ptr
      end
      loop = Mainloop.new(api: api)
      api.expect(:pa_mainloop_run, nil, [:mainloop_ptr, nil])
      loop.run
      api.verify
    end
  end
end
