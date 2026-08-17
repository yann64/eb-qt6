' Raw FFI layer: QMenuBar/QMenu/QAction (`ebqt6shim`).

Extern "C" Lib "ebqt6shim"
    Declare Function eb_qt6_menu_create() AS ANY PTR
    Declare Function eb_qt6_mainwindow_menu_bar(ByVal window AS ANY PTR) AS ANY PTR
    Declare Function eb_qt6_menubar_add_menu(ByVal menuBar AS ANY PTR, ByVal title AS ZSTRING) AS ANY PTR
    Declare Function eb_qt6_menu_add_action(ByVal menu AS ANY PTR, ByVal text AS ZSTRING) AS ANY PTR
    Declare Sub eb_qt6_action_connect_triggered(ByVal action AS ANY PTR, ByVal cb AS ANY PTR, ByVal userData AS ANY PTR)
    Declare Sub eb_qt6_action_set_checkable(ByVal action AS ANY PTR, ByVal checkable AS INTEGER)
    Declare Sub eb_qt6_action_set_checked(ByVal action AS ANY PTR, ByVal checked AS INTEGER)
    Declare Function eb_qt6_action_is_checked(ByVal action AS ANY PTR) AS INTEGER
    Declare Sub eb_qt6_action_set_shortcut(ByVal action AS ANY PTR, ByVal keySequence AS ZSTRING)
End Extern
