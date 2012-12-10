require 'ffi'

module PulseAudio
  extend FFI::Library
    
  ffi_lib 'pulse'

  typedef :pointer, :retval
  typedef :pointer, :userdata
  typedef :pointer, :pa_mainloop
  typedef :pointer, :pa_mainloop_api
  typedef :pointer, :pa_context

  class SourceInfo < FFI::Struct
    layout :name,        :string,
           :index,       :uint32,
           :description, :string    
  end

  enum :pa_context_flags, [:noflags,            0x0000,
                           :noautospawn,        0x0001,
                           :nofail,             0x0002]
    
  enum :pa_context_state, [:unconnected,
                           :connecting,
                           :authorizing,
                           :setting_name,
                           :ready,
                           :failed,
                           :terminated]

  callback :pa_context_notify_cb_t, [:pa_context, :userdata], :void
  callback :pa_source_info_cb_t, [:pointer, :pointer, :int, :pointer], :void

  attach_function :pa_mainloop_new, [], :pa_mainloop
  attach_function :pa_mainloop_free, [:pa_mainloop], :void
  attach_function :pa_mainloop_get_api, [:pa_mainloop], :pa_mainloop_api
  attach_function :pa_mainloop_run, [:pa_mainloop, :retval], :int
  attach_function :pa_mainloop_quit, [:pointer, :int], :void
  attach_function :pa_context_new, [:pointer, :string], :pa_context
  attach_function :pa_context_connect, [:pa_context, :string, :pa_context_flags, :pointer], :int
  attach_function :pa_context_disconnect, [:pa_context], :void
  attach_function :pa_context_set_state_callback, [:pa_context, :pa_context_notify_cb_t, :pointer], :void
  attach_function :pa_context_get_state, [:pa_context], :pa_context_state
  attach_function :pa_context_get_source_info_list, [:pa_context, :pa_source_info_cb_t, :pointer], :pointer

end

include PulseAudio

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
