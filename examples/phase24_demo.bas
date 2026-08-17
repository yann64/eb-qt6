' Phase 24: LineEdit/TextEdit ReadOnly, StatusBar permanent widget,
' ScrollArea scrollbar policy, and a standalone QToolButton with a
' popup menu.
'
' Qt6 needs QT_QPA_PLATFORM=xcb explicitly set in this environment - see
' hello_window.bas's own top comment / this package's README.

#include once "qt6.iface.bas"

DIM gStatus AS Label

SUB OnMenuOptionA(userData AS ANY PTR)
    CALL LabelSetText(gStatus, "toolbutton menu: Option A chosen")
END SUB

SUB OnMenuOptionB(userData AS ANY PTR)
    CALL LabelSetText(gStatus, "toolbutton menu: Option B chosen")
END SUB

DIM app AS Application
app = NewApplication("phase24_demo")

DIM win AS MainWindow
win = NewMainWindow()
CALL WidgetSetWindowTitle(win, "eb-qt6 Phase 24 demo")
CALL WidgetResize(win, 420, 420)

DIM central AS QtWidget
central = NewWidget()
DIM mainLayout AS BoxLayout
mainLayout = NewVBoxLayout()

gStatus = NewLabel("(nothing done yet)")
CALL BoxLayoutAddWidget(mainLayout, gStatus)

' --- Read-only LineEdit/TextEdit ---
DIM roEdit AS LineEdit
roEdit = NewLineEdit("You can select/copy this but not edit it")
CALL LineEditSetReadOnly(roEdit, 1)
CALL BoxLayoutAddWidget(mainLayout, roEdit)

DIM roText AS TextEdit
roText = NewTextEdit()
CALL TextEditSetText(roText, "Read-only text area." & Chr(10) & "Selectable, not editable.")
CALL TextEditSetReadOnly(roText, 1)
CALL WidgetSetMinimumSize(roText, 0, 60)
CALL BoxLayoutAddWidget(mainLayout, roText)

' --- ScrollArea with scrollbars always visible ---
DIM scroll AS ScrollArea
scroll = NewScrollArea()
CALL ScrollAreaSetHorizontalScrollBarPolicy(scroll, QtScrollBarAlwaysOn)
CALL ScrollAreaSetVerticalScrollBarPolicy(scroll, QtScrollBarAlwaysOn)
DIM scrollContent AS Label
scrollContent = NewLabel("scroll content")
CALL WidgetSetMinimumSize(scrollContent, 600, 400)
CALL ScrollAreaSetWidget(scroll, scrollContent)
CALL WidgetSetMinimumSize(scroll, 0, 100)
CALL BoxLayoutAddWidget(mainLayout, scroll)

' --- Standalone QToolButton with a popup menu ---
DIM optMenu AS Menu
optMenu = NewMenu()
DIM optA AS Action
optA = MenuAddAction(optMenu, "Option A")
CALL ActionConnectTriggered(optA, @OnMenuOptionA, 0)
DIM optB AS Action
optB = MenuAddAction(optMenu, "Option B")
CALL ActionConnectTriggered(optB, @OnMenuOptionB, 0)

DIM toolBtn AS ToolButton
toolBtn = NewToolButton()
CALL ToolButtonSetText(toolBtn, "Options...")
CALL ToolButtonSetMenu(toolBtn, optMenu)
CALL ToolButtonSetPopupMode(toolBtn, QtInstantPopup)
CALL BoxLayoutAddWidget(mainLayout, toolBtn)

CALL WidgetSetLayout(central, mainLayout)
CALL MainWindowSetCentralWidget(win, central)

' --- StatusBar permanent widget ---
DIM sb AS StatusBar
sb = MainWindowStatusBar(win)
CALL StatusBarShowMessage(sb, "ready", 0)
DIM permLabel AS Label
permLabel = NewLabel("v1.0")
CALL StatusBarAddPermanentWidget(sb, permLabel)

CALL WidgetShow(win)

CALL ApplicationExec(app)
