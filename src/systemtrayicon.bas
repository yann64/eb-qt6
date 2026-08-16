' Idiomatic layer: QSystemTrayIcon. Reuses the existing Menu TYPE
' (menu.bas) for its context menu.

#include once "widget.bas"
#include once "menu.bas"
#include once "raw/qt6_systemtrayicon.bas"

''' Matches real QSystemTrayIcon::ActivationReason values - compare
''' against these in a ConnectActivated handler.
CONST QtTrayUnknown = 0
CONST QtTrayContext = 1
CONST QtTrayDoubleClick = 2
CONST QtTrayTrigger = 3
CONST QtTrayMiddleClick = 4

TYPE SystemTrayIcon EXTENDS QtObject
END TYPE

FUNCTION NewSystemTrayIcon() AS SystemTrayIcon
    DIM t AS SystemTrayIcon
    t.handle = eb_qt6_systemtrayicon_create()
    NewSystemTrayIcon = t
END FUNCTION

''' Loads a named icon from the current desktop icon theme (e.g.
''' "dialog-information") - no file-based/embedded icon loading bound
''' yet.
SUB SystemTrayIconSetIconFromTheme(BYVAL t AS SystemTrayIcon, themeIconName AS ZSTRING)
    CALL eb_qt6_systemtrayicon_set_icon_from_theme(t.handle, themeIconName)
END SUB

SUB SystemTrayIconSetTooltip(BYVAL t AS SystemTrayIcon, text AS ZSTRING)
    CALL eb_qt6_systemtrayicon_set_tooltip(t.handle, text)
END SUB

''' The tray icon does NOT take ownership of `menu` - matching real Qt
''' semantics, unlike most "container now owns it" cases elsewhere in
''' this package.
SUB SystemTrayIconSetContextMenu(BYVAL t AS SystemTrayIcon, BYVAL menu AS Menu)
    CALL eb_qt6_systemtrayicon_set_context_menu(t.handle, menu.handle)
END SUB

SUB SystemTrayIconShow(BYVAL t AS SystemTrayIcon)
    CALL eb_qt6_systemtrayicon_show(t.handle)
END SUB

SUB SystemTrayIconHide(BYVAL t AS SystemTrayIcon)
    CALL eb_qt6_systemtrayicon_hide(t.handle)
END SUB

''' Connects `handler` (a top-level `SUB YourName(userData AS ANY PTR,
''' reason AS INTEGER)`) to the icon's `activated` signal - `reason` is
''' one of the QtTray* constants above.
SUB SystemTrayIconConnectActivated(BYVAL t AS SystemTrayIcon, handler AS ANY PTR, userData AS ANY PTR)
    CALL eb_qt6_systemtrayicon_connect_activated(t.handle, handler, userData)
END SUB
