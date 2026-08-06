#include "shim_painter.h"

#include <QColor>
#include <QPainter>
#include <QString>

extern "C" {

void eb_qt6_painter_set_pen_color(void* painter, unsigned char r, unsigned char g, unsigned char b) {
    static_cast<QPainter*>(painter)->setPen(QColor(r, g, b));
}

void eb_qt6_painter_set_brush_color(void* painter, unsigned char r, unsigned char g, unsigned char b) {
    static_cast<QPainter*>(painter)->setBrush(QColor(r, g, b));
}

void eb_qt6_painter_fill_rect(void* painter, int x, int y, int width, int height,
                               unsigned char r, unsigned char g, unsigned char b) {
    static_cast<QPainter*>(painter)->fillRect(x, y, width, height, QColor(r, g, b));
}

void eb_qt6_painter_draw_rect(void* painter, int x, int y, int width, int height) {
    static_cast<QPainter*>(painter)->drawRect(x, y, width, height);
}

void eb_qt6_painter_draw_line(void* painter, int x1, int y1, int x2, int y2) {
    static_cast<QPainter*>(painter)->drawLine(x1, y1, x2, y2);
}

void eb_qt6_painter_draw_text(void* painter, int x, int y, const char* text) {
    static_cast<QPainter*>(painter)->drawText(x, y, QString::fromUtf8(text));
}

}
