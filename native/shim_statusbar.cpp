#include "shim_statusbar.h"

#include <QMainWindow>
#include <QStatusBar>
#include <QString>
#include <QWidget>

extern "C" {

void* eb_qt6_mainwindow_status_bar(void* window) {
    return static_cast<QMainWindow*>(window)->statusBar();
}

void eb_qt6_statusbar_show_message(void* statusBar, const char* text, int timeout) {
    static_cast<QStatusBar*>(statusBar)->showMessage(QString::fromUtf8(text), timeout);
}

void eb_qt6_statusbar_add_permanent_widget(void* statusBar, void* widget) {
    static_cast<QStatusBar*>(statusBar)->addPermanentWidget(static_cast<QWidget*>(widget));
}

}
