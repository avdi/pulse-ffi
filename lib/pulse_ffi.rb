require 'pulse_ffi/bindings'
require 'pulse_ffi/mainloop'

module PulseFFI
  def self.mainloop(&run_callback)
    loop = Mainloop.new
    loop.run(&run_callback)
  end
end
