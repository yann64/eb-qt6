#include "shim_groupbox.h"

#include <QGroupBox>
#include <QObject>
#include <QString>

extern "C" {

void* eb_qt6_groupbox_create(const char* title) { return new QGroupBox(QString::fromUtf8(title)); }

void eb_qt6_groupbox_set_checkable(void* groupBox, int checkable) {
    static_cast<QGroupBox*>(groupBox)->setCheckable(checkable != 0);
}

int eb_qt6_groupbox_is_checked(void* groupBox) {
    return static_cast<QGroupBox*>(groupBox)->isChecked() ? 1 : 0;
}

void eb_qt6_groupbox_set_checked(void* groupBox, int checked) {
    static_cast<QGroupBox*>(groupBox)->setChecked(checked != 0);
}

void eb_qt6_groupbox_connect_toggled(void* groupBox, EbQt6BoolCallback cb, void* userData) {
    QObject::connect(static_cast<QGroupBox*>(groupBox), &QGroupBox::toggled,
                      [cb, userData](bool checked) {
                          if (cb) cb(userData, checked ? 1 : 0);
                      });
}

}
