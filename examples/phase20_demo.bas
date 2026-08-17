' Phase 20: QSpinBox suffix/prefix/single step, a checkable QGroupBox,
' WidgetUpdate (forced repaint), and stateless QFontMetrics text
' measurement.
'
' The font-metrics measurement drives the custom-paint widget below: a
' box exactly as wide as the measured text plus padding is drawn around
' it - proving the measurement is really used, not just computed and
' discarded.
'
' Qt6 needs QT_QPA_PLATFORM=xcb explicitly set in this environment - see
' hello_window.bas's own top comment / this package's README.

#include once "qt6.iface.bas"

DIM gStatus AS Label
DIM gCanvas AS PainterWidget
DIM gTickCount AS INTEGER

SUB OnPaint(userData AS ANY PTR, painter AS ANY PTR)
    DIM msg AS STRING
    msg = "tick " & Str(gTickCount)
    DIM textWidth AS INTEGER
    textWidth = FontMetricsTextWidth("Sans", 12, 0, 0, msg)
    DIM textHeight AS INTEGER
    textHeight = FontMetricsHeight("Sans", 12, 0, 0)
    CALL PainterFillRect(painter, 0, 0, 300, 80, 245, 245, 245)
    CALL PainterDrawRect(painter, 10, 10, textWidth + 20, textHeight + 10)
    CALL PainterDrawText(painter, 20, 10 + textHeight, msg)
END SUB

SUB OnTickClicked(userData AS ANY PTR)
    gTickCount = gTickCount + 1
    CALL WidgetUpdate(gCanvas)
    CALL LabelSetText(gStatus, "ticked, WidgetUpdate called")
END SUB

SUB OnGroupToggled(userData AS ANY PTR, checked AS INTEGER)
    CALL LabelSetText(gStatus, "group box toggled: " & Str(checked))
END SUB

DIM app AS Application
app = NewApplication("phase20_demo")

DIM win AS MainWindow
win = NewMainWindow()
CALL WidgetSetWindowTitle(win, "eb-qt6 Phase 20 demo")
CALL WidgetResize(win, 420, 460)

DIM central AS QtWidget
central = NewWidget()
DIM mainLayout AS BoxLayout
mainLayout = NewVBoxLayout()

gStatus = NewLabel("(nothing done yet)")
CALL BoxLayoutAddWidget(mainLayout, gStatus)

' --- FontMetrics-driven custom drawing + WidgetUpdate ---
gTickCount = 0
gCanvas = NewPainterWidget()
CALL WidgetSetMinimumSize(gCanvas, 300, 80)
CALL PainterWidgetConnectPaint(gCanvas, @OnPaint, 0)
CALL BoxLayoutAddWidget(mainLayout, gCanvas)

DIM tickBtn AS Button
tickBtn = NewButton("Tick")
CALL ButtonConnectClicked(tickBtn, @OnTickClicked, 0)
CALL BoxLayoutAddWidget(mainLayout, tickBtn)

' --- Checkable QGroupBox ---
DIM group AS GroupBox
group = NewGroupBox("Advanced options")
CALL GroupBoxSetCheckable(group, 1)
CALL GroupBoxSetChecked(group, 1)
CALL GroupBoxConnectToggled(group, @OnGroupToggled, 0)
DIM groupLayout AS BoxLayout
groupLayout = NewVBoxLayout()
CALL BoxLayoutAddWidget(groupLayout, NewLabel("Contents disable automatically when unchecked"))
CALL WidgetSetLayout(group, groupLayout)
CALL BoxLayoutAddWidget(mainLayout, group)

' --- QSpinBox suffix/prefix/single step ---
DIM spin AS SpinBox
spin = NewSpinBox()
CALL SpinBoxSetRange(spin, 0, 100)
CALL SpinBoxSetValue(spin, 50)
CALL SpinBoxSetSuffix(spin, " %")
CALL SpinBoxSetSingleStep(spin, 5)
CALL BoxLayoutAddWidget(mainLayout, spin)

CALL WidgetSetLayout(central, mainLayout)
CALL MainWindowSetCentralWidget(win, central)
CALL WidgetShow(win)

CALL ApplicationExec(app)
