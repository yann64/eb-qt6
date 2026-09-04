#include "shim_toolbar.h"

#include <QAction>
#include <QMainWindow>
#include <QString>
#include <QToolBar>
#include <unordered_map>

extern "C" {

void* eb_qt6_mainwindow_add_toolbar(void* window, const char* title) {
    return static_cast<QMainWindow*>(window)->addToolBar(QString::fromUtf8(title));
}

void* eb_qt6_toolbar_add_action(void* toolBar, const char* text) {
    return static_cast<QToolBar*>(toolBar)->addAction(QString::fromUtf8(text));
}

// Known, accepted limitation: entries are never removed when a window
// is destroyed, so a later window allocated at the same freed address
// would incorrectly reuse a stale toolbar handle. Not observed in
// practice (this package has no long-running create/destroy/recreate
// loop anywhere), and the same address-reuse risk already exists
// wherever GObj-based handle identity is used as a lookup key elsewhere
// in this ecosystem (e.g. eb-gtk4's WindowContentBox).
void* eb_qt6_mainwindow_get_or_create_toolbar(void* window) {
    static std::unordered_map<void*, void*> perWindowToolBar;
    auto it = perWindowToolBar.find(window);
    if (it != perWindowToolBar.end()) return it->second;
    void* tb = static_cast<QMainWindow*>(window)->addToolBar(QString());
    perWindowToolBar[window] = tb;
    return tb;
}

}
