#include "shim_menu.h"

#include <QAction>
#include <QKeySequence>
#include <QMainWindow>
#include <QMenu>
#include <QMenuBar>
#include <QObject>
#include <QString>

extern "C" {

void* eb_qt6_menu_create() { return new QMenu(); }

void* eb_qt6_mainwindow_menu_bar(void* window) {
    return static_cast<QMainWindow*>(window)->menuBar();
}

void* eb_qt6_menubar_add_menu(void* menuBar, const char* title) {
    return static_cast<QMenuBar*>(menuBar)->addMenu(QString::fromUtf8(title));
}

void* eb_qt6_menu_add_action(void* menu, const char* text) {
    return static_cast<QMenu*>(menu)->addAction(QString::fromUtf8(text));
}

void eb_qt6_action_connect_triggered(void* action, EbQt6VoidCallback cb, void* userData) {
    QObject::connect(static_cast<QAction*>(action), &QAction::triggered,
                      [cb, userData](bool) {
                          if (cb) cb(userData);
                      });
}

void eb_qt6_action_set_checkable(void* action, int checkable) {
    static_cast<QAction*>(action)->setCheckable(checkable != 0);
}

void eb_qt6_action_set_checked(void* action, int checked) {
    static_cast<QAction*>(action)->setChecked(checked != 0);
}

int eb_qt6_action_is_checked(void* action) {
    return static_cast<QAction*>(action)->isChecked() ? 1 : 0;
}

void eb_qt6_action_set_shortcut(void* action, const char* keySequence) {
    static_cast<QAction*>(action)->setShortcut(QKeySequence(QString::fromUtf8(keySequence)));
}

}
