// eb-qt6 native shim - QFontMetrics, stateless text-measurement
// queries. No handle to manage - each call constructs a real QFont/
// QFontMetrics internally and returns a plain number, matching
// eb_qt6_widget_set_font's own (family, pointSize, bold, italic) shape
// for describing a font, so the same four values used to set a
// widget's font can be reused directly to measure text in it.
#pragma once

extern "C" {

// Pixel width `text` would occupy if drawn in the described font -
// useful for custom-drawing layout (shim_painter.h) or sizing a
// widget to fit its own content.
int eb_qt6_font_metrics_text_width(const char* family, int pointSize, int bold, int italic, const char* text);
// The font's line height in pixels (ascent + descent + leading) -
// useful for vertically spacing multiple lines drawn manually via
// eb_qt6_painter_draw_text.
int eb_qt6_font_metrics_height(const char* family, int pointSize, int bold, int italic);

}
