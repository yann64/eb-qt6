#include "shim_splashscreen.h"

#include <QPixmap>
#include <QSplashScreen>
#include <QString>
#include <QWidget>

extern "C" {

void* eb_qt6_splashscreen_create_from_file(const char* path) {
    return new QSplashScreen(QPixmap(QString::fromUtf8(path)));
}

void eb_qt6_splashscreen_show(void* splash) { static_cast<QSplashScreen*>(splash)->show(); }

void eb_qt6_splashscreen_finish(void* splash, void* mainWindow) {
    static_cast<QSplashScreen*>(splash)->finish(static_cast<QWidget*>(mainWindow));
}

void eb_qt6_splashscreen_show_message(void* splash, const char* message) {
    static_cast<QSplashScreen*>(splash)->showMessage(QString::fromUtf8(message));
}

}
