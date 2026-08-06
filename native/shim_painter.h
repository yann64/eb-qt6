// eb-qt6 native shim - QPainter drawing primitives. Only ever valid to
// call with a `painter` handle received from an active
// EbQt6PaintCallback (see shim_painterwidget.h's own top comment on why
// - the handle is invalid the instant that callback returns).
#pragma once

extern "C" {

void eb_qt6_painter_set_pen_color(void* painter, unsigned char r, unsigned char g, unsigned char b);
void eb_qt6_painter_set_brush_color(void* painter, unsigned char r, unsigned char g, unsigned char b);
void eb_qt6_painter_fill_rect(void* painter, int x, int y, int width, int height,
                               unsigned char r, unsigned char g, unsigned char b);
void eb_qt6_painter_draw_rect(void* painter, int x, int y, int width, int height);
void eb_qt6_painter_draw_line(void* painter, int x1, int y1, int x2, int y2);
void eb_qt6_painter_draw_text(void* painter, int x, int y, const char* text);

}
