' Idiomatic layer: QSlider.
'
' QtHorizontal/QtVertical (Qt::Orientation values, also used by
' NewSplitter) live in common.bas.

#include once "widget.bas"
#include once "common.bas"
#include once "raw/qt6_slider.bas"

TYPE Slider EXTENDS QtWidget
END TYPE

FUNCTION NewSlider(orientation AS INTEGER) AS Slider
    DIM s AS Slider
    s.handle = eb_qt6_slider_create(orientation)
    NewSlider = s
END FUNCTION

SUB SliderSetRange(BYVAL s AS Slider, min AS INTEGER, max AS INTEGER)
    CALL eb_qt6_slider_set_range(s.handle, min, max)
END SUB

FUNCTION SliderValue(BYVAL s AS Slider) AS INTEGER
    SliderValue = eb_qt6_slider_value(s.handle)
END FUNCTION

SUB SliderSetValue(BYVAL s AS Slider, value AS INTEGER)
    CALL eb_qt6_slider_set_value(s.handle, value)
END SUB

''' Connects `handler` (a top-level `SUB YourName(userData AS ANY PTR,
''' value AS INTEGER)`) to the slider's `valueChanged` signal.
SUB SliderConnectValueChanged(BYVAL s AS Slider, handler AS ANY PTR, userData AS ANY PTR)
    CALL eb_qt6_slider_connect_value_changed(s.handle, handler, userData)
END SUB
