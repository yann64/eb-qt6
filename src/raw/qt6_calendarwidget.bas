' Raw FFI layer: QCalendarWidget (`ebqt6shim`).

Extern "C" Lib "ebqt6shim"
    Declare Function eb_qt6_calendarwidget_create() AS ANY PTR
    Declare Sub eb_qt6_calendarwidget_get_selected_date(ByVal cal AS ANY PTR, ByVal outYear AS ANY PTR, ByVal outMonth AS ANY PTR, ByVal outDay AS ANY PTR)
    Declare Sub eb_qt6_calendarwidget_connect_selection_changed(ByVal cal AS ANY PTR, ByVal cb AS ANY PTR, ByVal userData AS ANY PTR)
End Extern
