' Idiomatic layer: QPainter drawing primitives.
'
' Every function here takes the raw `painter AS ANY PTR` a
' PainterWidgetConnectPaint callback receives directly - only valid for
' the duration of that one callback invocation (see
' native/shim_painterwidget.h's own top comment: calling one of these
' after the callback has returned doesn't crash, but silently does
' nothing and prints a Qt warning to stderr - confirmed by direct
' reproduction, not assumed).

#include once "pixmap.bas"
#include once "raw/qt6_painter.bas"

SUB PainterSetPenColor(BYVAL painter AS ANY PTR, r AS UBYTE, g AS UBYTE, b AS UBYTE)
    CALL eb_qt6_painter_set_pen_color(painter, r, g, b)
END SUB

SUB PainterSetBrushColor(BYVAL painter AS ANY PTR, r AS UBYTE, g AS UBYTE, b AS UBYTE)
    CALL eb_qt6_painter_set_brush_color(painter, r, g, b)
END SUB

SUB PainterFillRect(BYVAL painter AS ANY PTR, x AS INTEGER, y AS INTEGER, width AS INTEGER, height AS INTEGER, r AS UBYTE, g AS UBYTE, b AS UBYTE)
    CALL eb_qt6_painter_fill_rect(painter, x, y, width, height, r, g, b)
END SUB

''' Draws an unfilled rectangle outline using the current pen color (see
''' PainterSetPenColor) - PainterFillRect above ignores the pen entirely
''' (it always fills solid), so use this for an outline instead.
SUB PainterDrawRect(BYVAL painter AS ANY PTR, x AS INTEGER, y AS INTEGER, width AS INTEGER, height AS INTEGER)
    CALL eb_qt6_painter_draw_rect(painter, x, y, width, height)
END SUB

SUB PainterDrawLine(BYVAL painter AS ANY PTR, x1 AS INTEGER, y1 AS INTEGER, x2 AS INTEGER, y2 AS INTEGER)
    CALL eb_qt6_painter_draw_line(painter, x1, y1, x2, y2)
END SUB

SUB PainterDrawText(BYVAL painter AS ANY PTR, x AS INTEGER, y AS INTEGER, text AS ZSTRING)
    CALL eb_qt6_painter_draw_text(painter, x, y, text)
END SUB

''' Loads an image file fresh on every call (no caching) and draws it
''' at (x, y) at its natural size - fine for one-off demos, but a real
''' app repainting often (animation, resize) should prefer
''' LabelSetPixmapFromFile instead, which only loads once. Returns
''' non-zero on success, zero if the file couldn't be loaded as an
''' image - nothing is drawn on failure.
FUNCTION PainterDrawPixmap(BYVAL painter AS ANY PTR, x AS INTEGER, y AS INTEGER, path AS ZSTRING) AS INTEGER
    PainterDrawPixmap = eb_qt6_painter_draw_pixmap(painter, x, y, path)
END FUNCTION

''' Draws an already-loaded Pixmap (pixmap.bas) at (x, y) at its
''' natural size - no file I/O on this call at all, the preferred
''' choice over PainterDrawPixmap for anything repainting often
''' (animation, resize).
SUB PainterDrawPixmapHandle(BYVAL painter AS ANY PTR, x AS INTEGER, y AS INTEGER, BYVAL p AS Pixmap)
    CALL eb_qt6_painter_draw_pixmap_handle(painter, x, y, p.handle)
END SUB
