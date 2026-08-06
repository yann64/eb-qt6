' Raw FFI layer: shared helpers every other raw/*.bas file needs
' (`ebqt6shim`) - see native/shim_common.h's own top comment on the
' owned-heap-allocation string-return convention this frees.

Extern "C" Lib "ebqt6shim"
    Declare Sub eb_qt6_free_string(ByVal s AS ANY PTR)
End Extern
