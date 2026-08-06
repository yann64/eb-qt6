#include "shim_toolbar.h"

#include <QAction>
#include <QMainWindow>
#include <QString>
#include <QToolBar>

extern "C" {

void* eb_qt6_mainwindow_add_toolbar(void* window, const char* title) {
    return static_cast<QMainWindow*>(window)->addToolBar(QString::fromUtf8(title));
}

void* eb_qt6_toolbar_add_action(void* toolBar, const char* text) {
    return static_cast<QToolBar*>(toolBar)->addAction(QString::fromUtf8(text));
}

}
