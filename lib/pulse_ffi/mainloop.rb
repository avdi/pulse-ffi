module PulseFFI
  class Mainloop
    attr_reader :pointer

    def initialize(options = {})
      @api     = options.fetch(:api) { Object.new.extend(Bindings) }
      @pointer = @api.pa_mainloop_new
    end

    def run
      @api.pa_mainloop_run(@pointer, nil)
      @api.pa_mainloop_free(@pointer)
    end
  end
end
