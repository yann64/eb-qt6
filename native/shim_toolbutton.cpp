#include "shim_toolbutton.h"

#include <QMenu>
#include <QObject>
#include <QString>
#include <QToolButton>

extern "C" {

void* eb_qt6_toolbutton_create() { return new QToolButton(); }

void eb_qt6_toolbutton_set_text(void* button, const char* text) {
    static_cast<QToolButton*>(button)->setText(QString::fromUtf8(text));
}

void eb_qt6_toolbutton_connect_clicked(void* button, EbQt6VoidCallback cb, void* userData) {
    QObject::connect(static_cast<QToolButton*>(button), &QToolButton::clicked,
                      [cb, userData](bool) {
                          if (cb) cb(userData);
                      });
}

void eb_qt6_toolbutton_set_menu(void* button, void* menu) {
    static_cast<QToolButton*>(button)->setMenu(static_cast<QMenu*>(menu));
}

void eb_qt6_toolbutton_set_popup_mode(void* button, int mode) {
    static_cast<QToolButton*>(button)->setPopupMode(static_cast<QToolButton::ToolButtonPopupMode>(mode));
}

}
