#include "shim_lineedit.h"

#include <QDoubleValidator>
#include <QIntValidator>
#include <QLineEdit>
#include <QObject>
#include <QRegularExpression>
#include <QRegularExpressionValidator>
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

void eb_qt6_lineedit_set_int_validator(void* lineEdit, int bottom, int top) {
    QLineEdit* edit = static_cast<QLineEdit*>(lineEdit);
    edit->setValidator(new QIntValidator(bottom, top, edit));
}

void eb_qt6_lineedit_set_double_validator(void* lineEdit, double bottom, double top, int decimals) {
    QLineEdit* edit = static_cast<QLineEdit*>(lineEdit);
    edit->setValidator(new QDoubleValidator(bottom, top, decimals, edit));
}

void eb_qt6_lineedit_set_echo_mode(void* lineEdit, int mode) {
    static_cast<QLineEdit*>(lineEdit)->setEchoMode(static_cast<QLineEdit::EchoMode>(mode));
}

void eb_qt6_lineedit_set_regex_validator(void* lineEdit, const char* pattern) {
    QLineEdit* edit = static_cast<QLineEdit*>(lineEdit);
    edit->setValidator(new QRegularExpressionValidator(QRegularExpression(QString::fromUtf8(pattern)), edit));
}

void eb_qt6_lineedit_set_placeholder_text(void* lineEdit, const char* text) {
    static_cast<QLineEdit*>(lineEdit)->setPlaceholderText(QString::fromUtf8(text));
}

void eb_qt6_lineedit_set_max_length(void* lineEdit, int maxLength) {
    static_cast<QLineEdit*>(lineEdit)->setMaxLength(maxLength);
}

void eb_qt6_lineedit_select_all(void* lineEdit) { static_cast<QLineEdit*>(lineEdit)->selectAll(); }

void eb_qt6_lineedit_clear(void* lineEdit) { static_cast<QLineEdit*>(lineEdit)->clear(); }

void eb_qt6_lineedit_set_read_only(void* lineEdit, int readOnly) {
    static_cast<QLineEdit*>(lineEdit)->setReadOnly(readOnly != 0);
}

}
