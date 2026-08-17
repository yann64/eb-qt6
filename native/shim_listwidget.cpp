#include "shim_listwidget.h"

#include <QIcon>
#include <QListWidget>
#include <QListWidgetItem>
#include <QObject>
#include <QString>

extern "C" {

void* eb_qt6_listwidget_create() { return new QListWidget(); }

void eb_qt6_listwidget_add_item(void* list, const char* text) {
    static_cast<QListWidget*>(list)->addItem(QString::fromUtf8(text));
}

void eb_qt6_listwidget_add_item_with_icon_from_theme(void* list, const char* text, const char* themeIconName) {
    QListWidgetItem* item = new QListWidgetItem(QIcon::fromTheme(QString::fromUtf8(themeIconName)), QString::fromUtf8(text));
    static_cast<QListWidget*>(list)->addItem(item);
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

int eb_qt6_listwidget_count(void* list) { return static_cast<QListWidget*>(list)->count(); }

void eb_qt6_listwidget_clear(void* list) { static_cast<QListWidget*>(list)->clear(); }

void eb_qt6_listwidget_remove_row(void* list, int row) {
    delete static_cast<QListWidget*>(list)->takeItem(row);
}

}
