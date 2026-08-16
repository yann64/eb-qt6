' Raw FFI layer: QCompleter (`ebqt6shim`).

Extern "C" Lib "ebqt6shim"
    Declare Function eb_qt6_completer_create(ByVal items AS ANY PTR) AS ANY PTR
    Declare Sub eb_qt6_lineedit_set_completer(ByVal lineEdit AS ANY PTR, ByVal completer AS ANY PTR)
End Extern
