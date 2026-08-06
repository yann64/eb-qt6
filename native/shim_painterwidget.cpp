#include "shim_painterwidget.h"

#include <QPainter>

void ShimWidget::paintEvent(QPaintEvent*) {
    QPainter painter(this);
    if (fPaintCallback) fPaintCallback(fPaintUserData, &painter);
}

extern "C" {

void* eb_qt6_painterwidget_create() { return new ShimWidget(); }

void eb_qt6_painterwidget_set_paint_callback(void* widget, EbQt6PaintCallback cb, void* userData) {
    static_cast<ShimWidget*>(widget)->SetPaintCallback(cb, userData);
}

}
