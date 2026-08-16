#include "shim_icon.h"

#include <QAction>
#include <QIcon>
#include <QPushButton>
#include <QString>
#include <QWidget>

extern "C" {

void eb_qt6_button_set_icon_from_theme(void* button, const char* themeIconName) {
    static_cast<QPushButton*>(button)->setIcon(QIcon::fromTheme(QString::fromUtf8(themeIconName)));
}

void eb_qt6_button_set_icon_from_file(void* button, const char* path) {
    static_cast<QPushButton*>(button)->setIcon(QIcon(QString::fromUtf8(path)));
}

void eb_qt6_action_set_icon_from_theme(void* action, const char* themeIconName) {
    static_cast<QAction*>(action)->setIcon(QIcon::fromTheme(QString::fromUtf8(themeIconName)));
}

void eb_qt6_action_set_icon_from_file(void* action, const char* path) {
    static_cast<QAction*>(action)->setIcon(QIcon(QString::fromUtf8(path)));
}

void eb_qt6_widget_set_window_icon_from_theme(void* widget, const char* themeIconName) {
    static_cast<QWidget*>(widget)->setWindowIcon(QIcon::fromTheme(QString::fromUtf8(themeIconName)));
}

void eb_qt6_widget_set_window_icon_from_file(void* widget, const char* path) {
    static_cast<QWidget*>(widget)->setWindowIcon(QIcon(QString::fromUtf8(path)));
}

}
