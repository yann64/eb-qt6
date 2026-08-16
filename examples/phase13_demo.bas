' Phase 13: drag-and-drop. A draggable label (press and drag it) and a
' drop-target frame that shows whatever plain text was dropped onto it.
'
' Qt6 needs QT_QPA_PLATFORM=xcb explicitly set in this environment - see
' hello_window.bas's own top comment / this package's README.

#include once "qt6.iface.bas"

DIM gStatus AS Label

SUB OnDropped(userData AS ANY PTR, text AS ZSTRING)
    DIM s AS STRING
    s = text
    CALL LabelSetText(gStatus, "dropped: " & s)
END SUB

DIM app AS Application
app = NewApplication("phase13_demo")

DIM win AS MainWindow
win = NewMainWindow()
CALL WidgetSetWindowTitle(win, "eb-qt6 Phase 13 demo")
CALL WidgetResize(win, 380, 300)

DIM central AS QtWidget
central = NewWidget()
DIM mainLayout AS BoxLayout
mainLayout = NewVBoxLayout()

DIM sourceLabel AS Label
sourceLabel = NewLabel("Drag me!")
CALL WidgetSetStyleSheet(sourceLabel, "background-color: #dfd; padding: 12px;")
CALL WidgetSetCursor(sourceLabel, QtPointingHandCursor)
CALL WidgetEnableDragSource(sourceLabel, "Hello from eb-qt6!")
CALL BoxLayoutAddWidget(mainLayout, sourceLabel)

DIM targetFrame AS Frame
targetFrame = NewFrame()
CALL FrameSetFrameStyle(targetFrame, QtFrameStyledPanel, QtFrameSunken)
CALL WidgetSetMinimumSize(targetFrame, 0, 100)
CALL WidgetEnableDropTarget(targetFrame, @OnDropped, 0)
DIM targetLayout AS BoxLayout
targetLayout = NewVBoxLayout()
DIM targetLabel AS Label
targetLabel = NewLabel("Drop here")
CALL BoxLayoutAddWidget(targetLayout, targetLabel)
CALL WidgetSetLayout(targetFrame, targetLayout)
CALL BoxLayoutAddWidget(mainLayout, targetFrame)

gStatus = NewLabel("(nothing dropped yet)")
CALL BoxLayoutAddWidget(mainLayout, gStatus)

CALL WidgetSetLayout(central, mainLayout)
CALL MainWindowSetCentralWidget(win, central)
CALL WidgetShow(win)

CALL ApplicationExec(app)
