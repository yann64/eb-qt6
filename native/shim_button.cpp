#include "shim_button.h"

#include <QObject>
#include <QPushButton>
#include <QString>

extern "C" {

void* eb_qt6_button_create(const char* label) {
    return new QPushButton(QString::fromUtf8(label));
}

void eb_qt6_button_set_text(void* button, const char* label) {
    static_cast<QPushButton*>(button)->setText(QString::fromUtf8(label));
}

char* eb_qt6_button_get_text(void* button) {
    return eb_qt6_dup_qstring(static_cast<QPushButton*>(button)->text());
}

void eb_qt6_button_connect_clicked(void* button, EbQt6VoidCallback cb, void* userData) {
    QObject::connect(static_cast<QPushButton*>(button), &QPushButton::clicked,
                      [cb, userData](bool) {
                          if (cb) cb(userData);
                      });
}

}
