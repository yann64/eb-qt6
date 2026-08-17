#include "shim_application.h"

#include <QApplication>
#include <QObject>
#include <QRect>
#include <QScreen>

namespace {

// File-scope, process-lifetime storage - QApplication keeps a reference
// to argc/argv for as long as it exists, matching how be_app/be_roster
// are process-lifetime singletons in eb-haiku's own shim. argv[0] stays
// a fixed literal (no string-lifetime question); a friendly app name is
// set via setApplicationName() after construction instead.
int s_argc = 1;
char s_argv0[] = "ebqt6";
char* s_argv[] = {s_argv0, nullptr};
QApplication* s_app = nullptr;

}  // namespace

extern "C" {

void* eb_qt6_application_create(const char* appName) {
    if (!s_app) {
        s_app = new QApplication(s_argc, s_argv);
        if (appName && appName[0] != '\0') {
            s_app->setApplicationName(QString::fromUtf8(appName));
        }
    }
    return s_app;
}

int eb_qt6_application_exec(void* app) {
    return static_cast<QApplication*>(app)->exec();
}

void eb_qt6_application_quit(void* app) {
    static_cast<QApplication*>(app)->quit();
}

void eb_qt6_application_set_quit_on_last_window_closed(void* app, int quit) {
    static_cast<QApplication*>(app)->setQuitOnLastWindowClosed(quit != 0);
}

void eb_qt6_application_connect_about_to_quit(void* app, EbQt6VoidCallback cb, void* userData) {
    QObject::connect(static_cast<QApplication*>(app), &QApplication::aboutToQuit, [cb, userData]() {
        if (cb) cb(userData);
    });
}

int eb_qt6_primary_screen_width() {
    QScreen* screen = QApplication::primaryScreen();
    return screen ? screen->availableGeometry().width() : 0;
}

int eb_qt6_primary_screen_height() {
    QScreen* screen = QApplication::primaryScreen();
    return screen ? screen->availableGeometry().height() : 0;
}

}
