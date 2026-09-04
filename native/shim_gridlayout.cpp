#include "shim_gridlayout.h"

#include <QGridLayout>
#include <QWidget>

extern "C" {

void* eb_qt6_gridlayout_create() { return new QGridLayout(); }

void eb_qt6_gridlayout_add_widget(void* layout, void* widget, int row, int col, int rowSpan, int colSpan) {
    static_cast<QGridLayout*>(layout)->addWidget(static_cast<QWidget*>(widget), row, col, rowSpan, colSpan);
}

void eb_qt6_gridlayout_add_widget_align(void* layout, void* widget, int row, int col, int rowSpan, int colSpan, int alignment) {
    static_cast<QGridLayout*>(layout)->addWidget(static_cast<QWidget*>(widget), row, col, rowSpan, colSpan, static_cast<Qt::Alignment>(alignment));
}

void eb_qt6_gridlayout_set_row_stretch(void* layout, int row, int stretch) {
    static_cast<QGridLayout*>(layout)->setRowStretch(row, stretch);
}

void eb_qt6_gridlayout_set_column_stretch(void* layout, int column, int stretch) {
    static_cast<QGridLayout*>(layout)->setColumnStretch(column, stretch);
}

}
