#include "shim_checkbox.h"

#include <QAbstractButton>
#include <QCheckBox>
#include <QObject>
#include <QRadioButton>
#include <QString>

extern "C" {

void* eb_qt6_checkbox_create(const char* text) {
    return new QCheckBox(QString::fromUtf8(text));
}

void* eb_qt6_radiobutton_create(const char* text) {
    return new QRadioButton(QString::fromUtf8(text));
}

void eb_qt6_abstractbutton_set_checked(void* button, int checked) {
    static_cast<QAbstractButton*>(button)->setChecked(checked != 0);
}

int eb_qt6_abstractbutton_is_checked(void* button) {
    return static_cast<QAbstractButton*>(button)->isChecked() ? 1 : 0;
}

void eb_qt6_abstractbutton_connect_toggled(void* button, EbQt6BoolCallback cb, void* userData) {
    QObject::connect(static_cast<QAbstractButton*>(button), &QAbstractButton::toggled,
                      [cb, userData](bool checked) {
                          if (cb) cb(userData, checked ? 1 : 0);
                      });
}

}
