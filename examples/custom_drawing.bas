' PainterWidget demo, promoted to the idiomatic layer with real drawing
' primitives: a green background, a red rectangle outline, a blue
' diagonal line, and drawn text - proves the full paint-callback
' forwarding pipeline, not just the Spike B hardcoded-red fill.
'
' Qt6 needs QT_QPA_PLATFORM=xcb explicitly set in this environment - see
' hello_window.bas's own top comment / this package's README.

#include once "qt6.iface.bas"

SUB OnPaint(userData AS ANY PTR, painter AS ANY PTR)
    CALL PainterFillRect(painter, 0, 0, 400, 300, 200, 255, 200)

    CALL PainterSetPenColor(painter, 255, 0, 0)
    CALL PainterDrawRect(painter, 20, 20, 150, 100)

    CALL PainterSetPenColor(painter, 0, 0, 255)
    CALL PainterDrawLine(painter, 20, 150, 380, 280)

    CALL PainterSetPenColor(painter, 0, 0, 0)
    CALL PainterDrawText(painter, 30, 200, "eb-qt6 custom drawing")
END SUB

DIM app AS Application
app = NewApplication("custom_drawing")

DIM win AS PainterWidget
win = NewPainterWidget()
CALL PainterWidgetConnectPaint(win, @OnPaint, 0)
CALL WidgetSetWindowTitle(win, "eb-qt6 custom drawing")
CALL WidgetResize(win, 400, 300)
CALL WidgetShow(win)

CALL ApplicationExec(app)
