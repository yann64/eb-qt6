#include "shim_slider.h"

#include <QObject>
#include <QSlider>

extern "C" {

void* eb_qt6_slider_create(int orientation) {
    return new QSlider(static_cast<Qt::Orientation>(orientation));
}

void eb_qt6_slider_set_range(void* slider, int min, int max) {
    static_cast<QSlider*>(slider)->setRange(min, max);
}

int eb_qt6_slider_value(void* slider) { return static_cast<QSlider*>(slider)->value(); }

void eb_qt6_slider_set_value(void* slider, int value) {
    static_cast<QSlider*>(slider)->setValue(value);
}

void eb_qt6_slider_connect_value_changed(void* slider, EbQt6IntCallback cb, void* userData) {
    // QSlider::valueChanged(int) has only one real shape, unlike
    // QSpinBox's own version - no QOverload disambiguation needed here.
    QObject::connect(static_cast<QSlider*>(slider), &QSlider::valueChanged,
                      [cb, userData](int value) {
                          if (cb) cb(userData, value);
                      });
}

}
