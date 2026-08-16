#include "shim_shortcut.h"

#include <QKeySequence>
#include <QObject>
#include <QShortcut>
#include <QString>
#include <QWidget>

extern "C" {

void* eb_qt6_shortcut_create(const char* keySequence, void* parent) {
    return new QShortcut(QKeySequence(QString::fromUtf8(keySequence)), static_cast<QWidget*>(parent));
}

void eb_qt6_shortcut_connect_activated(void* shortcut, EbQt6VoidCallback cb, void* userData) {
    QObject::connect(static_cast<QShortcut*>(shortcut), &QShortcut::activated, [cb, userData]() {
        if (cb) cb(userData);
    });
}

}
