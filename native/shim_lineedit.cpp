#include "shim_lineedit.h"

#include <QLineEdit>
#include <QObject>
#include <QString>

extern "C" {

void* eb_qt6_lineedit_create(const char* text) {
    return new QLineEdit(QString::fromUtf8(text));
}

void eb_qt6_lineedit_set_text(void* lineEdit, const char* text) {
    static_cast<QLineEdit*>(lineEdit)->setText(QString::fromUtf8(text));
}

char* eb_qt6_lineedit_get_text(void* lineEdit) {
    return eb_qt6_dup_qstring(static_cast<QLineEdit*>(lineEdit)->text());
}

void eb_qt6_lineedit_connect_return_pressed(void* lineEdit, EbQt6VoidCallback cb, void* userData) {
    QObject::connect(static_cast<QLineEdit*>(lineEdit), &QLineEdit::returnPressed,
                      [cb, userData]() {
                          if (cb) cb(userData);
                      });
}

void eb_qt6_lineedit_connect_text_changed(void* lineEdit, EbQt6StringCallback cb, void* userData) {
    QObject::connect(static_cast<QLineEdit*>(lineEdit), &QLineEdit::textChanged,
                      [cb, userData](const QString& text) {
                          if (cb) {
                              char* utf8 = eb_qt6_dup_qstring(text);
                              cb(userData, utf8);
                              eb_qt6_free_string(utf8);
                          }
                      });
}

}
