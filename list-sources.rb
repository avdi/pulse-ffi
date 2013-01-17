$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))
require 'pulse_ffi'

include PulseFFI::Bindings

mainloop = pa_mainloop_new
api      = pa_mainloop_get_api(mainloop)
context  = pa_context_new(api, "RubyTapas")

start_query_when_ready = ->(context, userdata) do
  state = pa_context_get_state(context)
  if state == :ready

  print_audio_source = ->(context, source_info_ptr, eol, userdata) do
    # End of list
    if eol == 1
      pa_context_disconnect(context)
      pa_mainloop_quit(mainloop, 0)
      return
    end

    source_info = SourceInfo.new(source_info_ptr)
      puts "#{source_info[:index]} #{source_info[:name]} "\
           "#{source_info[:description]}"
  end

    pa_context_get_source_info_list(context, print_audio_source, nil)
  end
end

pa_context_set_state_callback(context,
                              start_query_when_ready, nil)

pa_context_connect(context, nil, :noflags, nil)
pa_mainloop_run(mainloop, nil)

pa_mainloop_free(mainloop)
