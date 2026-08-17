#include "shim_treewidget.h"

#include <QObject>
#include <QString>
#include <QStringList>
#include <QTreeWidget>
#include <QTreeWidgetItem>

extern "C" {

void* eb_qt6_treewidget_create() { return new QTreeWidget(); }

void* eb_qt6_treewidget_add_top_level_item(void* tree, const char* text) {
    QTreeWidgetItem* item = new QTreeWidgetItem(QStringList(QString::fromUtf8(text)));
    static_cast<QTreeWidget*>(tree)->addTopLevelItem(item);
    return item;
}

void* eb_qt6_treewidget_add_child_item(void* parentItem, const char* text) {
    QTreeWidgetItem* item = new QTreeWidgetItem(QStringList(QString::fromUtf8(text)));
    static_cast<QTreeWidgetItem*>(parentItem)->addChild(item);
    return item;
}

char* eb_qt6_treeitem_text(void* item) {
    return eb_qt6_dup_qstring(static_cast<QTreeWidgetItem*>(item)->text(0));
}

void* eb_qt6_treewidget_current_item(void* tree) {
    return static_cast<QTreeWidget*>(tree)->currentItem();
}

void eb_qt6_treewidget_connect_current_item_changed(void* tree, EbQt6PtrCallback cb, void* userData) {
    QObject::connect(static_cast<QTreeWidget*>(tree), &QTreeWidget::currentItemChanged,
                      [cb, userData](QTreeWidgetItem* current, QTreeWidgetItem*) {
                          if (cb) cb(userData, current);
                      });
}

void eb_qt6_treewidget_set_column_count(void* tree, int count) {
    static_cast<QTreeWidget*>(tree)->setColumnCount(count);
}

void eb_qt6_treewidget_set_header_labels(void* tree, void* labels) {
    QStringList* list = static_cast<QStringList*>(labels);
    static_cast<QTreeWidget*>(tree)->setHeaderLabels(*list);
    delete list;
}

void eb_qt6_treeitem_set_text(void* item, int column, const char* text) {
    static_cast<QTreeWidgetItem*>(item)->setText(column, QString::fromUtf8(text));
}

char* eb_qt6_treeitem_text_at(void* item, int column) {
    return eb_qt6_dup_qstring(static_cast<QTreeWidgetItem*>(item)->text(column));
}

int eb_qt6_treewidget_top_level_item_count(void* tree) {
    return static_cast<QTreeWidget*>(tree)->topLevelItemCount();
}

void eb_qt6_treewidget_clear(void* tree) { static_cast<QTreeWidget*>(tree)->clear(); }

}
