#include "shim_stackedwidget.h"

#include <QObject>
#include <QStackedWidget>
#include <QWidget>

extern "C" {

void* eb_qt6_stackedwidget_create() { return new QStackedWidget(); }

int eb_qt6_stackedwidget_add_widget(void* stack, void* page) {
    return static_cast<QStackedWidget*>(stack)->addWidget(static_cast<QWidget*>(page));
}

int eb_qt6_stackedwidget_current_index(void* stack) {
    return static_cast<QStackedWidget*>(stack)->currentIndex();
}

void eb_qt6_stackedwidget_set_current_index(void* stack, int index) {
    static_cast<QStackedWidget*>(stack)->setCurrentIndex(index);
}

void eb_qt6_stackedwidget_connect_current_changed(void* stack, EbQt6IntCallback cb, void* userData) {
    QObject::connect(static_cast<QStackedWidget*>(stack), &QStackedWidget::currentChanged,
                      [cb, userData](int index) {
                          if (cb) cb(userData, index);
                      });
}

}
