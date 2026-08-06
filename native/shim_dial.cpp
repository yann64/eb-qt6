#include "shim_dial.h"

#include <QDial>
#include <QObject>

extern "C" {

void* eb_qt6_dial_create() { return new QDial(); }

void eb_qt6_dial_set_range(void* dial, int min, int max) {
    static_cast<QDial*>(dial)->setRange(min, max);
}

int eb_qt6_dial_value(void* dial) { return static_cast<QDial*>(dial)->value(); }

void eb_qt6_dial_set_value(void* dial, int value) {
    static_cast<QDial*>(dial)->setValue(value);
}

void eb_qt6_dial_connect_value_changed(void* dial, EbQt6IntCallback cb, void* userData) {
    // QDial::valueChanged(int) has only one real shape, like QSlider's
    // own version - no QOverload disambiguation needed here.
    QObject::connect(static_cast<QDial*>(dial), &QDial::valueChanged,
                      [cb, userData](int value) {
                          if (cb) cb(userData, value);
                      });
}

}
