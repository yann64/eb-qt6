' Headless-ish verification of this package's newest Action/ToolBar
' additions (ActionSetEnabled/IsEnabled/ActionTrigger,
' MainWindowToolBar's own auto-created-once singleton) - every check is
' a direct function call + printed result, matching eb-gtk4's sibling
' verification discipline for the same eb-gui Menu/Toolbar round.

#include "qt6.iface.bas"

DIM triggerCount AS INTEGER

SUB OnTriggered(userData AS ANY PTR)
    triggerCount = triggerCount + 1
    PRINT "action triggered, count: ", triggerCount
END SUB

DIM app AS Application
app = NewApplication("menu_toolbar_verify")

DIM win AS MainWindow
win = NewMainWindow()

DIM bar AS MenuBar
bar = MainWindowMenuBar(win)
DIM fileMenu AS Menu
fileMenu = MenuBarAddMenu(bar, "File")
DIM act AS Action
act = MenuAddAction(fileMenu, "Test")
CALL ActionConnectTriggered(act, @OnTriggered, 0)

PRINT "before trigger: ", triggerCount
CALL ActionTrigger(act)
PRINT "after trigger: ", triggerCount

PRINT "action enabled by default: ", ActionIsEnabled(act)
CALL ActionSetEnabled(act, 0)
PRINT "action enabled after disable: ", ActionIsEnabled(act)
CALL ActionSetEnabled(act, 1)
PRINT "action enabled after re-enable: ", ActionIsEnabled(act)

DIM tb1 AS ToolBar
tb1 = MainWindowToolBar(win)
DIM tb2 AS ToolBar
tb2 = MainWindowToolBar(win)
PRINT "MainWindowToolBar returns the same handle both times: ", (tb1.handle = tb2.handle)

DIM tbAction AS Action
tbAction = ToolBarAddAction(tb1, "Go")
CALL ActionConnectTriggered(tbAction, @OnTriggered, 0)
CALL ActionTrigger(tbAction)
PRINT "after toolbar action trigger: ", triggerCount

PRINT "done"
