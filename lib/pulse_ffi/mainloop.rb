module PulseFFI
  class Mainloop
    attr_reader :pointer

    def initialize(options = {})
      @api     = options.fetch(:api) { Object.new.extend(Bindings) }
      @pointer = @api.pa_mainloop_new
    end
  end
end
