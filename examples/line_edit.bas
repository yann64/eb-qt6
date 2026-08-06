' QLineEdit demo: a text field whose returnPressed/textChanged signals
' both update a status label - proves the deliberate three-step
' complexity ramp (EbQt6VoidCallback reused from clicked, then
' EbQt6StringCallback's own QString marshaling).
'
' Qt6 needs QT_QPA_PLATFORM=xcb explicitly set in this environment - see
' hello_window.bas's own top comment / this package's README.

#include once "qt6.iface.bas"

DIM gField AS LineEdit
DIM gStatus AS Label

SUB OnReturnPressed(userData AS ANY PTR)
    CALL LabelSetText(gStatus, "Enter pressed")
END SUB

SUB OnTextChanged(userData AS ANY PTR, text AS ZSTRING)
    DIM s AS STRING
    s = text
    CALL LabelSetText(gStatus, "typing: " & s)
END SUB

DIM app AS Application
app = NewApplication("line_edit")

DIM win AS MainWindow
win = NewMainWindow()
CALL WidgetSetWindowTitle(win, "eb-qt6 line edit")
CALL WidgetResize(win, 300, 150)

DIM central AS QtWidget
central = NewWidget()

DIM layout AS BoxLayout
layout = NewVBoxLayout()

gField = NewLineEdit("")
CALL LineEditConnectReturnPressed(gField, @OnReturnPressed, 0)
CALL LineEditConnectTextChanged(gField, @OnTextChanged, 0)
CALL BoxLayoutAddWidget(layout, gField)

gStatus = NewLabel("(nothing yet)")
CALL BoxLayoutAddWidget(layout, gStatus)

CALL WidgetSetLayout(central, layout)
CALL MainWindowSetCentralWidget(win, central)
CALL WidgetShow(win)

CALL ApplicationExec(app)
