#include "shim_textedit.h"

#include <QObject>
#include <QString>
#include <QTextEdit>

extern "C" {

void* eb_qt6_textedit_create() { return new QTextEdit(); }

void eb_qt6_textedit_set_text(void* textEdit, const char* text) {
    static_cast<QTextEdit*>(textEdit)->setPlainText(QString::fromUtf8(text));
}

char* eb_qt6_textedit_get_text(void* textEdit) {
    return eb_qt6_dup_qstring(static_cast<QTextEdit*>(textEdit)->toPlainText());
}

void eb_qt6_textedit_set_html(void* textEdit, const char* html) {
    static_cast<QTextEdit*>(textEdit)->setHtml(QString::fromUtf8(html));
}

char* eb_qt6_textedit_get_html(void* textEdit) {
    return eb_qt6_dup_qstring(static_cast<QTextEdit*>(textEdit)->toHtml());
}

void eb_qt6_textedit_connect_text_changed(void* textEdit, EbQt6VoidCallback cb, void* userData) {
    QObject::connect(static_cast<QTextEdit*>(textEdit), &QTextEdit::textChanged, [cb, userData]() {
        if (cb) cb(userData);
    });
}

}
