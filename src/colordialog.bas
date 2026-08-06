' Idiomatic layer: QColorDialog. A static convenience dialog, not a
' persistent widget, matching MessageBox/FileDialog (dialog.bas).

#include once "widget.bas"
#include once "raw/qt6_colordialog.bas"

''' `parent` - pass an unassigned `DIM x AS QtWidget` (zero-initialized
''' handle) for "no parent window", the same convention MessageBox/
''' FileDialog functions already use. Fills outR/outG/outB and returns
''' non-zero if the user picked a color, zero if they cancelled (in
''' which case outR/outG/outB are left untouched).
FUNCTION ColorDialogGetColor(BYVAL parent AS QtWidget, title AS ZSTRING, initR AS UBYTE, initG AS UBYTE, initB AS UBYTE, BYREF outR AS UBYTE, BYREF outG AS UBYTE, BYREF outB AS UBYTE) AS INTEGER
    DIM r AS UBYTE
    DIM g AS UBYTE
    DIM b AS UBYTE
    DIM valid AS INTEGER
    valid = eb_qt6_colordialog_get_color(parent.handle, title, initR, initG, initB, @r, @g, @b)
    IF valid <> 0 THEN
        outR = r
        outG = g
        outB = b
    END IF
    ColorDialogGetColor = valid
END FUNCTION
