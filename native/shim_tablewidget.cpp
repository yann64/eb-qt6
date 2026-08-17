#include "shim_tablewidget.h"

#include <QObject>
#include <QString>
#include <QStringList>
#include <QTableWidget>
#include <QTableWidgetItem>

extern "C" {

void* eb_qt6_tablewidget_create() { return new QTableWidget(); }

void eb_qt6_tablewidget_set_row_count(void* table, int rows) {
    static_cast<QTableWidget*>(table)->setRowCount(rows);
}

void eb_qt6_tablewidget_set_column_count(void* table, int cols) {
    static_cast<QTableWidget*>(table)->setColumnCount(cols);
}

void eb_qt6_tablewidget_set_item_text(void* table, int row, int col, const char* text) {
    QTableWidget* t = static_cast<QTableWidget*>(table);
    QTableWidgetItem* item = t->item(row, col);
    if (!item) {
        item = new QTableWidgetItem();
        t->setItem(row, col, item);
    }
    item->setText(QString::fromUtf8(text));
}

char* eb_qt6_tablewidget_item_text(void* table, int row, int col) {
    QTableWidgetItem* item = static_cast<QTableWidget*>(table)->item(row, col);
    return eb_qt6_dup_qstring(item ? item->text() : QString());
}

void eb_qt6_tablewidget_connect_cell_clicked(void* table, EbQt6TwoIntCallback cb, void* userData) {
    QObject::connect(static_cast<QTableWidget*>(table), &QTableWidget::cellClicked,
                      [cb, userData](int row, int col) {
                          if (cb) cb(userData, row, col);
                      });
}

int eb_qt6_tablewidget_row_count(void* table) { return static_cast<QTableWidget*>(table)->rowCount(); }

int eb_qt6_tablewidget_column_count(void* table) { return static_cast<QTableWidget*>(table)->columnCount(); }

void eb_qt6_tablewidget_set_horizontal_header_labels(void* table, void* labels) {
    QStringList* list = static_cast<QStringList*>(labels);
    static_cast<QTableWidget*>(table)->setHorizontalHeaderLabels(*list);
    delete list;
}

}
