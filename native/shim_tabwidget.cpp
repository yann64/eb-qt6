#include "shim_tabwidget.h"

#include <QObject>
#include <QString>
#include <QTabWidget>
#include <QWidget>

extern "C" {

void* eb_qt6_tabwidget_create() { return new QTabWidget(); }

int eb_qt6_tabwidget_add_tab(void* tabWidget, void* page, const char* title) {
    return static_cast<QTabWidget*>(tabWidget)->addTab(static_cast<QWidget*>(page), QString::fromUtf8(title));
}

int eb_qt6_tabwidget_current_index(void* tabWidget) {
    return static_cast<QTabWidget*>(tabWidget)->currentIndex();
}

void eb_qt6_tabwidget_set_current_index(void* tabWidget, int index) {
    static_cast<QTabWidget*>(tabWidget)->setCurrentIndex(index);
}

void eb_qt6_tabwidget_connect_current_changed(void* tabWidget, EbQt6IntCallback cb, void* userData) {
    QObject::connect(static_cast<QTabWidget*>(tabWidget), &QTabWidget::currentChanged,
                      [cb, userData](int index) {
                          if (cb) cb(userData, index);
                      });
}

}
