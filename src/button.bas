' Idiomatic layer: QPushButton - the first per-signal-connect exemplar
' (see shim_common.h's own top comment on why Qt6 needs one shim
' connect-function per (class, signal) pair, unlike eb-gtk4's single
' generic ObjConnect).

#include once "widget.bas"
#include once "raw/qt6_button.bas"

TYPE Button EXTENDS QtWidget
END TYPE

FUNCTION NewButton(label AS ZSTRING) AS Button
    DIM b AS Button
    b.handle = eb_qt6_button_create(label)
    NewButton = b
END FUNCTION

SUB ButtonSetText(BYVAL b AS Button, label AS ZSTRING)
    CALL eb_qt6_button_set_text(b.handle, label)
END SUB

''' Returns a newly allocated string the caller must free via
''' FreeQtString once read - **not** exported as `STRING`: no top-level
''' `STRING`-returning function can cross this package's own `--lib`
''' boundary (same restriction, and same fix, as eb-gtk4's own
''' TextBufferGetText - see that package's own README).
''' `DIM raw AS ANY PTR : raw = ButtonGetText(b)`
''' `DIM z AS ZSTRING : z = raw`
''' `DIM s AS STRING : s = z`
''' `CALL FreeQtString(raw)`
FUNCTION ButtonGetText(BYVAL b AS Button) AS ANY PTR
    ButtonGetText = eb_qt6_button_get_text(b.handle)
END FUNCTION

''' Connects `handler` (a top-level `SUB YourName(userData AS ANY PTR)` -
''' see eBasic's own `@ProcName` doc) to the button's `clicked` signal.
''' `userData` must outlive the button itself - the same convention
''' eb-gtk4/eb-haiku already require for their own callback setters.
SUB ButtonConnectClicked(BYVAL b AS Button, handler AS ANY PTR, userData AS ANY PTR)
    CALL eb_qt6_button_connect_clicked(b.handle, handler, userData)
END SUB
