' Phase 9 combined demo: icons on a button/menu action/window title, an
' ActionGroup of mutually-exclusive checkable menu items, a Frame for
' visual grouping, and a tooltip - all wired to a shared status label.
'
' Qt6 needs QT_QPA_PLATFORM=xcb explicitly set in this environment - see
' hello_window.bas's own top comment / this package's README.

#include once "qt6.iface.bas"

DIM gStatus AS Label
DIM gLeftAction AS Action
DIM gCenterAction AS Action
DIM gRightAction AS Action
DIM app AS Application

SUB OnSaveClicked(userData AS ANY PTR)
    CALL LabelSetText(gStatus, "save clicked")
END SUB

SUB OnAlignmentChanged(userData AS ANY PTR, action AS ANY PTR)
    IF action = gLeftAction.handle THEN
        CALL LabelSetText(gStatus, "alignment: Left")
    ELSEIF action = gCenterAction.handle THEN
        CALL LabelSetText(gStatus, "alignment: Center")
    ELSEIF action = gRightAction.handle THEN
        CALL LabelSetText(gStatus, "alignment: Right")
    END IF
END SUB

app = NewApplication("phase9_demo")

' Constructed before anything below that could conceivably touch it
' synchronously - the same defensive discipline established across
' several earlier phases (QTabWidget/QTreeWidget/QStackedWidget/
' LineEditSetText all fired a connected signal as a side effect of
' their own setup calls).
gStatus = NewLabel("(nothing yet)")

DIM win AS MainWindow
win = NewMainWindow()
CALL WidgetSetWindowTitle(win, "eb-qt6 Phase 9 demo")
CALL WidgetSetWindowIconFromTheme(win, "document-save")
CALL WidgetResize(win, 380, 260)

DIM winMenuBar AS MenuBar
winMenuBar = MainWindowMenuBar(win)
DIM viewMenu AS Menu
viewMenu = MenuBarAddMenu(winMenuBar, "View")

gLeftAction = MenuAddAction(viewMenu, "Align Left")
CALL ActionSetCheckable(gLeftAction, 1)
CALL ActionSetChecked(gLeftAction, 1)

gCenterAction = MenuAddAction(viewMenu, "Align Center")
CALL ActionSetCheckable(gCenterAction, 1)

gRightAction = MenuAddAction(viewMenu, "Align Right")
CALL ActionSetCheckable(gRightAction, 1)

DIM alignGroup AS ActionGroup
alignGroup = NewActionGroup(win)
CALL ActionGroupAddAction(alignGroup, gLeftAction)
CALL ActionGroupAddAction(alignGroup, gCenterAction)
CALL ActionGroupAddAction(alignGroup, gRightAction)
CALL ActionGroupConnectTriggered(alignGroup, @OnAlignmentChanged, 0)

DIM central AS QtWidget
central = NewWidget()
DIM mainLayout AS BoxLayout
mainLayout = NewVBoxLayout()

DIM box AS Frame
box = NewFrame()
CALL FrameSetFrameStyle(box, QtFrameStyledPanel, QtFrameSunken)
DIM frameLayout AS BoxLayout
frameLayout = NewVBoxLayout()

DIM saveButton AS Button
saveButton = NewButton("Save")
CALL ButtonSetIconFromTheme(saveButton, "document-save")
CALL ButtonConnectClicked(saveButton, @OnSaveClicked, 0)
CALL WidgetSetToolTip(saveButton, "Save the current document")
CALL BoxLayoutAddWidget(frameLayout, saveButton)

CALL WidgetSetLayout(box, frameLayout)
CALL BoxLayoutAddWidget(mainLayout, box)

DIM hintLabel AS Label
hintLabel = NewLabel("Hover the button for a tooltip. Use View menu for alignment.")
CALL BoxLayoutAddWidget(mainLayout, hintLabel)

CALL BoxLayoutAddWidget(mainLayout, gStatus)

CALL WidgetSetLayout(central, mainLayout)
CALL MainWindowSetCentralWidget(win, central)
CALL WidgetShow(win)

CALL ApplicationExec(app)
