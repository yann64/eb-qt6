' Raw FFI layer: QDateEdit/QTimeEdit (`ebqt6shim`).

Extern "C" Lib "ebqt6shim"
    Declare Function eb_qt6_dateedit_create() AS ANY PTR
    Declare Sub eb_qt6_dateedit_set_date(ByVal edit AS ANY PTR, ByVal year AS INTEGER, ByVal month AS INTEGER, ByVal day AS INTEGER)
    Declare Sub eb_qt6_dateedit_get_date(ByVal edit AS ANY PTR, ByVal outYear AS ANY PTR, ByVal outMonth AS ANY PTR, ByVal outDay AS ANY PTR)

    Declare Function eb_qt6_timeedit_create() AS ANY PTR
    Declare Sub eb_qt6_timeedit_set_time(ByVal edit AS ANY PTR, ByVal hour AS INTEGER, ByVal minute AS INTEGER, ByVal second AS INTEGER)
    Declare Sub eb_qt6_timeedit_get_time(ByVal edit AS ANY PTR, ByVal outHour AS ANY PTR, ByVal outMinute AS ANY PTR, ByVal outSecond AS ANY PTR)
End Extern
