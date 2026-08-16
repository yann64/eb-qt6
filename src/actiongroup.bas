' Idiomatic layer: QActionGroup - the QAction equivalent of ButtonGroup
' (buttongroup.bas) - mutually exclusive actions, e.g. a set of menu
' items where only one can be checked at a time. Actions added to a
' group must be checkable (ActionSetCheckable, menu.bas) for
' exclusivity to be visible/usable.

#include once "widget.bas"
#include once "menu.bas"
#include once "raw/qt6_actiongroup.bas"

TYPE ActionGroup EXTENDS QtObject
END TYPE

''' `parent` - pass a real parent widget so Qt manages the group's
''' lifetime automatically (matching ButtonGroup's own convention - a
''' plain `DIM x AS QtWidget` handle of 0 would leak, since QActionGroup
''' has no natural widget-tree owner otherwise).
FUNCTION NewActionGroup(BYVAL parent AS QtWidget) AS ActionGroup
    DIM g AS ActionGroup
    g.handle = eb_qt6_actiongroup_create(parent.handle)
    NewActionGroup = g
END FUNCTION

''' Adds `action` (must be checkable, see ActionSetCheckable) to the
''' group. The group does NOT take ownership - `action`'s actual menu
''' still owns it, matching ButtonGroupAddButton's own semantics.
SUB ActionGroupAddAction(BYVAL group AS ActionGroup, BYVAL action AS Action)
    CALL eb_qt6_actiongroup_add_action(group.handle, action.handle)
END SUB

''' Connects `handler` (a top-level `SUB YourName(userData AS ANY PTR,
''' action AS ANY PTR)`) to the group's `triggered` signal - `action` is
''' a raw handle, wrap it via WrapAction (menu.bas) before calling
''' ActionIsChecked/etc. on it.
SUB ActionGroupConnectTriggered(BYVAL group AS ActionGroup, handler AS ANY PTR, userData AS ANY PTR)
    CALL eb_qt6_actiongroup_connect_triggered(group.handle, handler, userData)
END SUB
