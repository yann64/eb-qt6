' Idiomatic layer: QProgressBar.

#include once "widget.bas"
#include once "raw/qt6_progressbar.bas"

TYPE ProgressBar EXTENDS QtWidget
END TYPE

FUNCTION NewProgressBar() AS ProgressBar
    DIM p AS ProgressBar
    p.handle = eb_qt6_progressbar_create()
    NewProgressBar = p
END FUNCTION

SUB ProgressBarSetRange(BYVAL p AS ProgressBar, min AS INTEGER, max AS INTEGER)
    CALL eb_qt6_progressbar_set_range(p.handle, min, max)
END SUB

FUNCTION ProgressBarValue(BYVAL p AS ProgressBar) AS INTEGER
    ProgressBarValue = eb_qt6_progressbar_value(p.handle)
END FUNCTION

SUB ProgressBarSetValue(BYVAL p AS ProgressBar, value AS INTEGER)
    CALL eb_qt6_progressbar_set_value(p.handle, value)
END SUB
