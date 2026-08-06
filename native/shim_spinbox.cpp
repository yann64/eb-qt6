#include "shim_spinbox.h"

#include <QObject>
#include <QSpinBox>

extern "C" {

void* eb_qt6_spinbox_create() { return new QSpinBox(); }

void eb_qt6_spinbox_set_range(void* spinBox, int min, int max) {
    static_cast<QSpinBox*>(spinBox)->setRange(min, max);
}

int eb_qt6_spinbox_value(void* spinBox) { return static_cast<QSpinBox*>(spinBox)->value(); }

void eb_qt6_spinbox_set_value(void* spinBox, int value) {
    static_cast<QSpinBox*>(spinBox)->setValue(value);
}

void eb_qt6_spinbox_connect_value_changed(void* spinBox, EbQt6IntCallback cb, void* userData) {
    // Unlike QSlider's single-shape valueChanged, QSpinBox still keeps
    // both valueChanged(int) and valueChanged(const QString&) in Qt6 -
    // qOverload<int>(...) picks the int one unambiguously.
    QObject::connect(static_cast<QSpinBox*>(spinBox), qOverload<int>(&QSpinBox::valueChanged),
                      [cb, userData](int value) {
                          if (cb) cb(userData, value);
                      });
}

}
