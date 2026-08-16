#include "shim_completer.h"

#include <QCompleter>
#include <QLineEdit>
#include <QStringList>

extern "C" {

void* eb_qt6_completer_create(void* items) {
    QStringList* list = static_cast<QStringList*>(items);
    QCompleter* completer = new QCompleter(*list);
    delete list;
    return completer;
}

void eb_qt6_lineedit_set_completer(void* lineEdit, void* completer) {
    static_cast<QLineEdit*>(lineEdit)->setCompleter(static_cast<QCompleter*>(completer));
}

}
