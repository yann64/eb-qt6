' Idiomatic layer: QToolButton, standalone (usable in any layout, not
' just a QToolBar - QToolBar's own action buttons, toolbar.bas, are
' real QToolButtons created internally by Qt itself; this is for
' wanting one directly, most commonly to show a popup Menu on click,
' e.g. a "..." options button).

#include once "widget.bas"
#include once "menu.bas"
#include once "raw/qt6_toolbutton.bas"

TYPE ToolButton EXTENDS QtWidget
END TYPE

FUNCTION NewToolButton() AS ToolButton
    DIM b AS ToolButton
    b.handle = eb_qt6_toolbutton_create()
    NewToolButton = b
END FUNCTION

SUB ToolButtonSetText(BYVAL b AS ToolButton, text AS ZSTRING)
    CALL eb_qt6_toolbutton_set_text(b.handle, text)
END SUB

SUB ToolButtonConnectClicked(BYVAL b AS ToolButton, handler AS ANY PTR, userData AS ANY PTR)
    CALL eb_qt6_toolbutton_connect_clicked(b.handle, handler, userData)
END SUB

''' Attaches `menu` to show on click - the button does NOT take
''' ownership of `menu` (real QToolButton::setMenu semantics), unlike
''' this package's usual "container now owns it" convention, so `menu`
''' needs its own lifetime management if not otherwise parented.
SUB ToolButtonSetMenu(BYVAL b AS ToolButton, BYVAL menu AS Menu)
    CALL eb_qt6_toolbutton_set_menu(b.handle, menu.handle)
END SUB

''' Matches real QToolButton::ToolButtonPopupMode values - pass to
''' ToolButtonSetPopupMode.
CONST QtDelayedPopup = 0
CONST QtMenuButtonPopup = 1
CONST QtInstantPopup = 2

''' QtInstantPopup is the common choice for a menu-only button with no
''' independent default action (clicking anywhere shows the menu
''' immediately, ConnectClicked's handler never fires on its own).
SUB ToolButtonSetPopupMode(BYVAL b AS ToolButton, mode AS INTEGER)
    CALL eb_qt6_toolbutton_set_popup_mode(b.handle, mode)
END SUB
