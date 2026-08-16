' Idiomatic layer: QShortcut. Unlike QTimer/Settings, `parent` is not
' optional here - real QShortcut is scoped to a window via its parent
' widget (Qt::WindowShortcut context, the real Qt default) and has no
' meaningful null-parent case.

#include once "widget.bas"
#include once "raw/qt6_shortcut.bas"

TYPE Shortcut EXTENDS QtObject
END TYPE

''' `keySequence` is parsed the same way real Qt does - e.g. "Ctrl+Q",
''' "Alt+F4", "F5".
FUNCTION NewShortcut(keySequence AS ZSTRING, BYVAL parent AS QtWidget) AS Shortcut
    DIM s AS Shortcut
    s.handle = eb_qt6_shortcut_create(keySequence, parent.handle)
    NewShortcut = s
END FUNCTION

''' Connects `handler` (a top-level `SUB YourName(userData AS ANY
''' PTR)`) to the shortcut's `activated` signal (fires when the key
''' sequence is pressed anywhere in the parent window).
SUB ShortcutConnectActivated(BYVAL s AS Shortcut, handler AS ANY PTR, userData AS ANY PTR)
    CALL eb_qt6_shortcut_connect_activated(s.handle, handler, userData)
END SUB
