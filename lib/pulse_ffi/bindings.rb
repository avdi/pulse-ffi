require 'ffi'

module PulseFFI
  module Bindings
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
end
