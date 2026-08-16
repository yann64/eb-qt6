' Raw FFI layer: QPainter drawing primitives (`ebqt6shim`). Only ever
' valid to call with a `painter` handle received from an active paint
' callback (see PainterWidget's own doc comment).

Extern "C" Lib "ebqt6shim"
    Declare Sub eb_qt6_painter_set_pen_color(ByVal painter AS ANY PTR, ByVal r AS UBYTE, ByVal g AS UBYTE, ByVal b AS UBYTE)
    Declare Sub eb_qt6_painter_set_brush_color(ByVal painter AS ANY PTR, ByVal r AS UBYTE, ByVal g AS UBYTE, ByVal b AS UBYTE)
    Declare Sub eb_qt6_painter_fill_rect(ByVal painter AS ANY PTR, ByVal x AS INTEGER, ByVal y AS INTEGER, ByVal width AS INTEGER, ByVal height AS INTEGER, ByVal r AS UBYTE, ByVal g AS UBYTE, ByVal b AS UBYTE)
    Declare Sub eb_qt6_painter_draw_rect(ByVal painter AS ANY PTR, ByVal x AS INTEGER, ByVal y AS INTEGER, ByVal width AS INTEGER, ByVal height AS INTEGER)
    Declare Sub eb_qt6_painter_draw_line(ByVal painter AS ANY PTR, ByVal x1 AS INTEGER, ByVal y1 AS INTEGER, ByVal x2 AS INTEGER, ByVal y2 AS INTEGER)
    Declare Sub eb_qt6_painter_draw_text(ByVal painter AS ANY PTR, ByVal x AS INTEGER, ByVal y AS INTEGER, ByVal text AS ZSTRING)
    Declare Function eb_qt6_painter_draw_pixmap(ByVal painter AS ANY PTR, ByVal x AS INTEGER, ByVal y AS INTEGER, ByVal path AS ZSTRING) AS INTEGER
End Extern
