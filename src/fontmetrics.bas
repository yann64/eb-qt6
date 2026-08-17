' Idiomatic layer: QFontMetrics, stateless text-measurement queries. No
' handle to manage - each call constructs a real QFont/QFontMetrics
' internally, reusing the same (family, pointSize, bold, italic) shape
' WidgetSetFont already uses to describe a font, so the same four
' values can be reused directly to measure text in it.

#include once "raw/qt6_fontmetrics.bas"

''' Pixel width `text` would occupy if drawn in the described font -
''' useful for custom-drawing layout (painter.bas) or sizing a widget
''' to fit its own content.
FUNCTION FontMetricsTextWidth(family AS ZSTRING, pointSize AS INTEGER, bold AS INTEGER, italic AS INTEGER, text AS ZSTRING) AS INTEGER
    FontMetricsTextWidth = eb_qt6_font_metrics_text_width(family, pointSize, bold, italic, text)
END FUNCTION

''' The font's line height in pixels (ascent + descent + leading) -
''' useful for vertically spacing multiple lines drawn manually via
''' PainterDrawText.
FUNCTION FontMetricsHeight(family AS ZSTRING, pointSize AS INTEGER, bold AS INTEGER, italic AS INTEGER) AS INTEGER
    FontMetricsHeight = eb_qt6_font_metrics_height(family, pointSize, bold, italic)
END FUNCTION
