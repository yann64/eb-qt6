#include "shim_dockwidget.h"

#include <QDockWidget>
#include <QMainWindow>
#include <QString>
#include <QWidget>

extern "C" {

void* eb_qt6_dockwidget_create(const char* title) { return new QDockWidget(QString::fromUtf8(title)); }

void eb_qt6_dockwidget_set_widget(void* dockWidget, void* widget) {
    static_cast<QDockWidget*>(dockWidget)->setWidget(static_cast<QWidget*>(widget));
}

void eb_qt6_mainwindow_add_dock_widget(void* window, int area, void* dockWidget) {
    static_cast<QMainWindow*>(window)->addDockWidget(static_cast<Qt::DockWidgetArea>(area),
                                                       static_cast<QDockWidget*>(dockWidget));
}

}
