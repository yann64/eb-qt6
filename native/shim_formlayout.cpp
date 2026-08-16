#include "shim_formlayout.h"

#include <QFormLayout>
#include <QString>
#include <QWidget>

extern "C" {

void* eb_qt6_formlayout_create() { return new QFormLayout(); }

void eb_qt6_formlayout_add_row(void* layout, const char* labelText, void* widget) {
    static_cast<QFormLayout*>(layout)->addRow(QString::fromUtf8(labelText), static_cast<QWidget*>(widget));
}

}
