' Raw FFI layer: QWidget/QMainWindow and the two stock box layouts
' (`ebqt6shim`).

Extern "C" Lib "ebqt6shim"
    Declare Function eb_qt6_widget_create() AS ANY PTR
    Declare Sub eb_qt6_widget_show(ByVal widget AS ANY PTR)
    Declare Sub eb_qt6_widget_resize(ByVal widget AS ANY PTR, ByVal width AS INTEGER, ByVal height AS INTEGER)
    Declare Sub eb_qt6_widget_set_window_title(ByVal widget AS ANY PTR, ByVal title AS ZSTRING)
    Declare Sub eb_qt6_widget_set_style_sheet(ByVal widget AS ANY PTR, ByVal styleSheet AS ZSTRING)
    Declare Sub eb_qt6_widget_set_tool_tip(ByVal widget AS ANY PTR, ByVal toolTip AS ZSTRING)
    Declare Sub eb_qt6_widget_set_minimum_size(ByVal widget AS ANY PTR, ByVal width AS INTEGER, ByVal height AS INTEGER)
    Declare Sub eb_qt6_widget_set_maximum_size(ByVal widget AS ANY PTR, ByVal width AS INTEGER, ByVal height AS INTEGER)
    Declare Sub eb_qt6_widget_set_focus(ByVal widget AS ANY PTR)
    Declare Function eb_qt6_widget_has_focus(ByVal widget AS ANY PTR) AS INTEGER
    Declare Sub eb_qt6_widget_set_enabled(ByVal widget AS ANY PTR, ByVal enabled AS INTEGER)
    Declare Function eb_qt6_widget_is_enabled(ByVal widget AS ANY PTR) AS INTEGER
    Declare Sub eb_qt6_widget_set_visible(ByVal widget AS ANY PTR, ByVal visible AS INTEGER)
    Declare Function eb_qt6_widget_is_visible(ByVal widget AS ANY PTR) AS INTEGER
    Declare Sub eb_qt6_widget_set_font(ByVal widget AS ANY PTR, ByVal family AS ZSTRING, ByVal pointSize AS INTEGER, ByVal bold AS INTEGER, ByVal italic AS INTEGER)
    Declare Sub eb_qt6_widget_set_cursor(ByVal widget AS ANY PTR, ByVal shape AS INTEGER)
    Declare Sub eb_qt6_widget_destroy(ByVal widget AS ANY PTR)
    Declare Sub eb_qt6_widget_move(ByVal widget AS ANY PTR, ByVal x AS INTEGER, ByVal y AS INTEGER)
    Declare Sub eb_qt6_widget_set_geometry(ByVal widget AS ANY PTR, ByVal x AS INTEGER, ByVal y AS INTEGER, ByVal width AS INTEGER, ByVal height AS INTEGER)
    Declare Function eb_qt6_widget_x(ByVal widget AS ANY PTR) AS INTEGER
    Declare Function eb_qt6_widget_y(ByVal widget AS ANY PTR) AS INTEGER
    Declare Function eb_qt6_widget_width(ByVal widget AS ANY PTR) AS INTEGER
    Declare Function eb_qt6_widget_height(ByVal widget AS ANY PTR) AS INTEGER
    Declare Sub eb_qt6_widget_raise(ByVal widget AS ANY PTR)
    Declare Sub eb_qt6_widget_update(ByVal widget AS ANY PTR)

    Declare Function eb_qt6_mainwindow_create() AS ANY PTR
    Declare Sub eb_qt6_mainwindow_set_central_widget(ByVal window AS ANY PTR, ByVal widget AS ANY PTR)

    Declare Function eb_qt6_vboxlayout_create() AS ANY PTR
    Declare Function eb_qt6_hboxlayout_create() AS ANY PTR
    Declare Sub eb_qt6_boxlayout_add_widget(ByVal layout AS ANY PTR, ByVal widget AS ANY PTR)
    Declare Sub eb_qt6_boxlayout_set_spacing(ByVal layout AS ANY PTR, ByVal spacing AS INTEGER)
    Declare Sub eb_qt6_boxlayout_set_contents_margins(ByVal layout AS ANY PTR, ByVal left AS INTEGER, ByVal top AS INTEGER, ByVal right AS INTEGER, ByVal bottom AS INTEGER)
    Declare Sub eb_qt6_widget_set_layout(ByVal widget AS ANY PTR, ByVal layout AS ANY PTR)
End Extern
