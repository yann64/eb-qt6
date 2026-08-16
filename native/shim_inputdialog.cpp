#include "shim_inputdialog.h"

#include "shim_common.h"

#include <QInputDialog>
#include <QLineEdit>
#include <QStringList>
#include <QWidget>

extern "C" {

char* eb_qt6_inputdialog_get_text(void* parent, const char* title, const char* label, const char* initialText, int* outValid) {
    bool ok = false;
    QString result = QInputDialog::getText(static_cast<QWidget*>(parent), QString::fromUtf8(title),
                                            QString::fromUtf8(label), QLineEdit::Normal,
                                            QString::fromUtf8(initialText), &ok);
    *outValid = ok ? 1 : 0;
    return eb_qt6_dup_qstring(ok ? result : QString());
}

void eb_qt6_inputdialog_get_int(void* parent, const char* title, const char* label, int initialValue, int min, int max, int* outValue, int* outValid) {
    bool ok = false;
    int result = QInputDialog::getInt(static_cast<QWidget*>(parent), QString::fromUtf8(title),
                                       QString::fromUtf8(label), initialValue, min, max, 1, &ok);
    *outValid = ok ? 1 : 0;
    if (ok) *outValue = result;
}

void* eb_qt6_stringlist_create() { return new QStringList(); }

void eb_qt6_stringlist_add(void* list, const char* text) {
    static_cast<QStringList*>(list)->append(QString::fromUtf8(text));
}

char* eb_qt6_inputdialog_get_item(void* parent, const char* title, const char* label, void* items, int currentIndex, int editable, int* outValid) {
    QStringList* list = static_cast<QStringList*>(items);
    bool ok = false;
    QString result = QInputDialog::getItem(static_cast<QWidget*>(parent), QString::fromUtf8(title),
                                            QString::fromUtf8(label), *list, currentIndex, editable != 0, &ok);
    delete list;
    *outValid = ok ? 1 : 0;
    return eb_qt6_dup_qstring(ok ? result : QString());
}

}
