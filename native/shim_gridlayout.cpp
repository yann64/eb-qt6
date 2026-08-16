#include "shim_gridlayout.h"

#include <QGridLayout>
#include <QWidget>

extern "C" {

void* eb_qt6_gridlayout_create() { return new QGridLayout(); }

void eb_qt6_gridlayout_add_widget(void* layout, void* widget, int row, int col, int rowSpan, int colSpan) {
    static_cast<QGridLayout*>(layout)->addWidget(static_cast<QWidget*>(widget), row, col, rowSpan, colSpan);
}

}
