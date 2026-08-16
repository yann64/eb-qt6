#include "shim_timer.h"

#include <QObject>
#include <QTimer>
#include <QWidget>

extern "C" {

void* eb_qt6_timer_create(void* parent) { return new QTimer(static_cast<QWidget*>(parent)); }

void eb_qt6_timer_set_interval(void* timer, int milliseconds) {
    static_cast<QTimer*>(timer)->setInterval(milliseconds);
}

void eb_qt6_timer_set_single_shot(void* timer, int singleShot) {
    static_cast<QTimer*>(timer)->setSingleShot(singleShot != 0);
}

void eb_qt6_timer_start(void* timer) { static_cast<QTimer*>(timer)->start(); }

void eb_qt6_timer_stop(void* timer) { static_cast<QTimer*>(timer)->stop(); }

int eb_qt6_timer_is_active(void* timer) { return static_cast<QTimer*>(timer)->isActive() ? 1 : 0; }

void eb_qt6_timer_connect_timeout(void* timer, EbQt6VoidCallback cb, void* userData) {
    QObject::connect(static_cast<QTimer*>(timer), &QTimer::timeout, [cb, userData]() {
        if (cb) cb(userData);
    });
}

}
