' Raw FFI layer: QSplitter (`ebqt6shim`).

Extern "C" Lib "ebqt6shim"
    Declare Function eb_qt6_splitter_create(ByVal orientation AS INTEGER) AS ANY PTR
    Declare Sub eb_qt6_splitter_add_widget(ByVal splitter AS ANY PTR, ByVal widget AS ANY PTR)
End Extern
