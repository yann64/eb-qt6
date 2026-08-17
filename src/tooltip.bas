' Idiomatic layer: QToolTip, shown programmatically rather than
' attached to a widget's own hover behavior (WidgetSetToolTip,
' widget.bas, already covers the passive "hover this widget" case).
' Useful for showing a tooltip-style hint in response to something
' other than mouse hover (e.g. after a validation error, or a
' keyboard-driven action).

#include once "raw/qt6_tooltip.bas"

''' `x`/`y` are global (whole-screen) pixel coordinates, not relative
''' to any widget.
SUB ToolTipShowText(x AS INTEGER, y AS INTEGER, text AS ZSTRING)
    CALL eb_qt6_tooltip_show_text(x, y, text)
END SUB

SUB ToolTipHide()
    CALL eb_qt6_tooltip_hide()
END SUB
