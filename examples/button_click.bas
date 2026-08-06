' The classic vertical-slice demo: a button whose click updates a label -
' proves the whole per-signal-connect pattern end to end (shim function
' -> raw Declare -> idiomatic wrapper -> a working example), composed
' via a real QVBoxLayout.
'
' Qt6 needs QT_QPA_PLATFORM=xcb explicitly set in this environment - see
' hello_window.bas's own top comment / this package's README.

#include once "qt6.iface.bas"

DIM gLabel AS Label
DIM gClickCount AS INTEGER

SUB OnClicked(userData AS ANY PTR)
    gClickCount = gClickCount + 1
    CALL LabelSetText(gLabel, "clicked!")
END SUB

DIM app AS Application
app = NewApplication("button_click")

DIM win AS MainWindow
win = NewMainWindow()
CALL WidgetSetWindowTitle(win, "eb-qt6 button click")
CALL WidgetResize(win, 300, 150)

DIM central AS QtWidget
central = NewWidget()

DIM layout AS BoxLayout
layout = NewVBoxLayout()

DIM btn AS Button
btn = NewButton("Click Me")
CALL ButtonConnectClicked(btn, @OnClicked, 0)
CALL BoxLayoutAddWidget(layout, btn)

gLabel = NewLabel("not clicked yet")
CALL BoxLayoutAddWidget(layout, gLabel)

CALL WidgetSetLayout(central, layout)
CALL MainWindowSetCentralWidget(win, central)
CALL WidgetShow(win)

CALL ApplicationExec(app)
