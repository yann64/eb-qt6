#include "shim_listwidget.h"

#include <QListWidget>
#include <QListWidgetItem>
#include <QObject>
#include <QString>

extern "C" {

void* eb_qt6_listwidget_create() { return new QListWidget(); }

void eb_qt6_listwidget_add_item(void* list, const char* text) {
    static_cast<QListWidget*>(list)->addItem(QString::fromUtf8(text));
}

int eb_qt6_listwidget_current_row(void* list) {
    return static_cast<QListWidget*>(list)->currentRow();
}

void eb_qt6_listwidget_set_current_row(void* list, int row) {
    static_cast<QListWidget*>(list)->setCurrentRow(row);
}

char* eb_qt6_listwidget_current_text(void* list) {
    // QListWidget has no currentText() of its own (unlike QComboBox) -
    // go through currentItem(), which is null when nothing is selected.
    QListWidgetItem* item = static_cast<QListWidget*>(list)->currentItem();
    return eb_qt6_dup_qstring(item ? item->text() : QString());
}

void eb_qt6_listwidget_connect_current_row_changed(void* list, EbQt6IntCallback cb, void* userData) {
    QObject::connect(static_cast<QListWidget*>(list), &QListWidget::currentRowChanged,
                      [cb, userData](int row) {
                          if (cb) cb(userData, row);
                      });
}

}
