' Idiomatic layer: QFrame - a simple bordered/shadowed container widget
' for visual grouping, distinct from GroupBox (groupbox.bas) in having
' no title. A real QWidget subclass, so WidgetShow/WidgetSetLayout/etc.
' (widget.bas) already work on its handle.

#include once "widget.bas"
#include once "raw/qt6_frame.bas"

''' Matches real Qt::QFrame::Shape values - pass to FrameSetFrameStyle.
CONST QtFrameNoFrame = 0
CONST QtFrameBox = 1
CONST QtFramePanel = 2
CONST QtFrameStyledPanel = 6
CONST QtFrameHLine = 4
CONST QtFrameVLine = 5

''' Matches real Qt::QFrame::Shadow values - pass to FrameSetFrameStyle.
CONST QtFramePlain = 16
CONST QtFrameRaised = 32
CONST QtFrameSunken = 48

TYPE Frame EXTENDS QtWidget
END TYPE

FUNCTION NewFrame() AS Frame
    DIM f AS Frame
    f.handle = eb_qt6_frame_create()
    NewFrame = f
END FUNCTION

''' Combines a shape (QtFrameBox/QtFramePanel/QtFrameStyledPanel/
''' QtFrameHLine/QtFrameVLine/QtFrameNoFrame) with a shadow
''' (QtFramePlain/QtFrameRaised/QtFrameSunken) - matching real Qt's own
''' `setFrameStyle(shape | shadow)` idiom.
SUB FrameSetFrameStyle(BYVAL f AS Frame, shape AS INTEGER, shadow AS INTEGER)
    CALL eb_qt6_frame_set_frame_style(f.handle, shape, shadow)
END SUB
