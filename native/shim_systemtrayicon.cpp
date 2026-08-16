#include "shim_systemtrayicon.h"

#include <QIcon>
#include <QMenu>
#include <QObject>
#include <QString>
#include <QSystemTrayIcon>

extern "C" {

void* eb_qt6_systemtrayicon_create() { return new QSystemTrayIcon(); }

void eb_qt6_systemtrayicon_set_icon_from_theme(void* tray, const char* themeIconName) {
    static_cast<QSystemTrayIcon*>(tray)->setIcon(QIcon::fromTheme(QString::fromUtf8(themeIconName)));
}

void eb_qt6_systemtrayicon_set_tooltip(void* tray, const char* text) {
    static_cast<QSystemTrayIcon*>(tray)->setToolTip(QString::fromUtf8(text));
}

void eb_qt6_systemtrayicon_set_context_menu(void* tray, void* menu) {
    static_cast<QSystemTrayIcon*>(tray)->setContextMenu(static_cast<QMenu*>(menu));
}

void eb_qt6_systemtrayicon_show(void* tray) { static_cast<QSystemTrayIcon*>(tray)->show(); }

void eb_qt6_systemtrayicon_hide(void* tray) { static_cast<QSystemTrayIcon*>(tray)->hide(); }

void eb_qt6_systemtrayicon_connect_activated(void* tray, EbQt6IntCallback cb, void* userData) {
    QObject::connect(static_cast<QSystemTrayIcon*>(tray), &QSystemTrayIcon::activated,
                      [cb, userData](QSystemTrayIcon::ActivationReason reason) {
                          if (cb) cb(userData, static_cast<int>(reason));
                      });
}

}
