' Idiomatic layer: QGroupBox. A real QWidget subclass, so
' WidgetSetLayout (widget.bas) already works to compose its contents.

#include once "widget.bas"
#include once "raw/qt6_groupbox.bas"

TYPE GroupBox EXTENDS QtWidget
END TYPE

FUNCTION NewGroupBox(title AS ZSTRING) AS GroupBox
    DIM g AS GroupBox
    g.handle = eb_qt6_groupbox_create(title)
    NewGroupBox = g
END FUNCTION

''' Adds a checkbox in the title area - when checkable, real Qt also
''' disables/enables all of the group box's own child widgets to match
''' the checked state automatically, no extra wiring needed for that
''' part.
SUB GroupBoxSetCheckable(BYVAL g AS GroupBox, checkable AS INTEGER)
    CALL eb_qt6_groupbox_set_checkable(g.handle, checkable)
END SUB

FUNCTION GroupBoxIsChecked(BYVAL g AS GroupBox) AS INTEGER
    GroupBoxIsChecked = eb_qt6_groupbox_is_checked(g.handle)
END FUNCTION

SUB GroupBoxSetChecked(BYVAL g AS GroupBox, checked AS INTEGER)
    CALL eb_qt6_groupbox_set_checked(g.handle, checked)
END SUB

''' Connects `handler` (a top-level `SUB YourName(userData AS ANY PTR,
''' checked AS INTEGER)`) to the group box's `toggled` signal - only
''' fires when GroupBoxSetCheckable(g, 1) has been called.
SUB GroupBoxConnectToggled(BYVAL g AS GroupBox, handler AS ANY PTR, userData AS ANY PTR)
    CALL eb_qt6_groupbox_connect_toggled(g.handle, handler, userData)
END SUB
