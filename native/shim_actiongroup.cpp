#include "shim_actiongroup.h"

#include <QAction>
#include <QActionGroup>
#include <QObject>
#include <QWidget>

extern "C" {

void* eb_qt6_actiongroup_create(void* parent) { return new QActionGroup(static_cast<QWidget*>(parent)); }

void eb_qt6_actiongroup_add_action(void* group, void* action) {
    static_cast<QActionGroup*>(group)->addAction(static_cast<QAction*>(action));
}

void eb_qt6_actiongroup_connect_triggered(void* group, EbQt6PtrCallback cb, void* userData) {
    QObject::connect(static_cast<QActionGroup*>(group), &QActionGroup::triggered,
                      [cb, userData](QAction* action) {
                          if (cb) cb(userData, action);
                      });
}

}
