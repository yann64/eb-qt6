' Raw FFI layer: QInputDialog (`ebqt6shim`).

Extern "C" Lib "ebqt6shim"
    Declare Function eb_qt6_inputdialog_get_text(ByVal parent AS ANY PTR, ByVal title AS ZSTRING, ByVal label AS ZSTRING, ByVal initialText AS ZSTRING, ByVal outValid AS ANY PTR) AS ANY PTR
    Declare Sub eb_qt6_inputdialog_get_int(ByVal parent AS ANY PTR, ByVal title AS ZSTRING, ByVal label AS ZSTRING, ByVal initialValue AS INTEGER, ByVal min AS INTEGER, ByVal max AS INTEGER, ByVal outValue AS ANY PTR, ByVal outValid AS ANY PTR)

    Declare Function eb_qt6_stringlist_create() AS ANY PTR
    Declare Sub eb_qt6_stringlist_add(ByVal list AS ANY PTR, ByVal text AS ZSTRING)
    Declare Function eb_qt6_inputdialog_get_item(ByVal parent AS ANY PTR, ByVal title AS ZSTRING, ByVal label AS ZSTRING, ByVal items AS ANY PTR, ByVal currentIndex AS INTEGER, ByVal editable AS INTEGER, ByVal outValid AS ANY PTR) AS ANY PTR
End Extern
