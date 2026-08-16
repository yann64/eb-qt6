' Idiomatic layer: QMenuBar/QMenu/QAction. A MainWindow always manages
' its own menu bar (auto-created on first access, matching real Qt
' idiom) - there is no NewMenuBar; use MainWindowMenuBar instead.
' MenuBarAddMenu/MenuAddAction both construct-and-own the returned
' object (the menu bar owns its menus, a menu owns its actions) - no
' separate destroy function, the same "container now owns it"
' convention widget.bas's own top comment already documents for
' layouts/central widgets.

#include once "widget.bas"
#include once "raw/qt6_menu.bas"

''' Real QMenuBar/QMenu are both QWidget subclasses.
TYPE MenuBar EXTENDS QtWidget
END TYPE

TYPE Menu EXTENDS QtWidget
END TYPE

''' Real QAction is a plain QObject, not a QWidget.
TYPE Action EXTENDS QtObject
END TYPE

''' A standalone, unparented top-level menu - needed for contexts with
''' no menu bar to hang it off of (e.g. SystemTrayIconSetContextMenu).
FUNCTION NewMenu() AS Menu
    DIM m AS Menu
    m.handle = eb_qt6_menu_create()
    NewMenu = m
END FUNCTION

''' Returns the window's own menu bar (auto-created by Qt the first time
''' this is called, matching real QMainWindow::menuBar() semantics).
FUNCTION MainWindowMenuBar(BYVAL win AS MainWindow) AS MenuBar
    DIM m AS MenuBar
    m.handle = eb_qt6_mainwindow_menu_bar(win.handle)
    MainWindowMenuBar = m
END FUNCTION

''' Creates a new top-level menu (e.g. "File") on the menu bar - owned
''' by the menu bar, see this file's own top comment.
FUNCTION MenuBarAddMenu(BYVAL menuBar AS MenuBar, title AS ZSTRING) AS Menu
    DIM m AS Menu
    m.handle = eb_qt6_menubar_add_menu(menuBar.handle, title)
    MenuBarAddMenu = m
END FUNCTION

''' Creates a new action (e.g. "Open...") on a menu - owned by the menu,
''' see this file's own top comment.
FUNCTION MenuAddAction(BYVAL menu AS Menu, text AS ZSTRING) AS Action
    DIM a AS Action
    a.handle = eb_qt6_menu_add_action(menu.handle, text)
    MenuAddAction = a
END FUNCTION

''' Connects `handler` (a top-level `SUB YourName(userData AS ANY
''' PTR)`) to the action's `triggered` signal (fires when the menu item
''' is chosen).
SUB ActionConnectTriggered(BYVAL a AS Action, handler AS ANY PTR, userData AS ANY PTR)
    CALL eb_qt6_action_connect_triggered(a.handle, handler, userData)
END SUB
