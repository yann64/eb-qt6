#include "shim_mainwindow.h"

#include <QCloseEvent>

void ShimMainWindow::closeEvent(QCloseEvent* event) {
    if (!fCloseCallback) {
        QMainWindow::closeEvent(event);
        return;
    }
    if (fCloseCallback(fCloseUserData)) {
        event->accept();
    } else {
        event->ignore();
    }
}

extern "C" {

void* eb_qt6_mainwindow_create() {
    // Qt::WA_DeleteOnClose deliberately left unset - closing hides, does
    // not delete, matching eb-gtk4's own explicit-lifetime philosophy
    // (see shim_widget.h's own top comment).
    return new ShimMainWindow();
}

void eb_qt6_mainwindow_set_central_widget(void* window, void* widget) {
    static_cast<ShimMainWindow*>(window)->setCentralWidget(static_cast<QWidget*>(widget));
}

void eb_qt6_mainwindow_set_close_callback(void* window, EbQt6CloseCallback cb, void* userData) {
    static_cast<ShimMainWindow*>(window)->SetCloseCallback(cb, userData);
}

}
