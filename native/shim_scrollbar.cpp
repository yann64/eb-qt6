#include "shim_scrollbar.h"

#include <QObject>
#include <QScrollBar>

extern "C" {

void* eb_qt6_scrollbar_create(int orientation) {
    return new QScrollBar(static_cast<Qt::Orientation>(orientation));
}

void eb_qt6_scrollbar_set_range(void* scrollBar, int min, int max) {
    static_cast<QScrollBar*>(scrollBar)->setRange(min, max);
}

int eb_qt6_scrollbar_value(void* scrollBar) { return static_cast<QScrollBar*>(scrollBar)->value(); }

void eb_qt6_scrollbar_set_value(void* scrollBar, int value) {
    static_cast<QScrollBar*>(scrollBar)->setValue(value);
}

void eb_qt6_scrollbar_connect_value_changed(void* scrollBar, EbQt6IntCallback cb, void* userData) {
    QObject::connect(static_cast<QScrollBar*>(scrollBar), &QScrollBar::valueChanged,
                      [cb, userData](int value) {
                          if (cb) cb(userData, value);
                      });
}

}
