' Idiomatic layer: QFontDialog. A static convenience dialog, not a
' persistent widget, matching MessageBox/FileDialog (dialog.bas). Only
' exposes family name + point size, not the full QFont surface.

#include once "widget.bas"
#include once "common.bas"
#include once "raw/qt6_fontdialog.bas"

''' `parent` - pass an unassigned `DIM x AS QtWidget` (zero-initialized
''' handle) for "no parent window". Returns the family name as an owned
''' ANY PTR (see ButtonGetText's own doc comment on the FreeQtString
''' convention) - empty if the user cancelled, in which case
''' outPointSize is left untouched. Fills outValid with non-zero/zero
''' for picked/cancelled.
FUNCTION FontDialogGetFont(BYVAL parent AS QtWidget, BYREF outPointSize AS INTEGER, BYREF outValid AS INTEGER) AS ANY PTR
    DIM pointSize AS INTEGER
    DIM valid AS INTEGER
    DIM raw AS ANY PTR
    raw = eb_qt6_fontdialog_get_font(parent.handle, @pointSize, @valid)
    IF valid <> 0 THEN
        outPointSize = pointSize
    END IF
    outValid = valid
    FontDialogGetFont = raw
END FUNCTION
