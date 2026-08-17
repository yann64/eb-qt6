#include "shim_pixmap.h"

#include <QPixmap>
#include <QString>

extern "C" {

void* eb_qt6_pixmap_create_from_file(const char* path) {
    return new QPixmap(QString::fromUtf8(path));
}

int eb_qt6_pixmap_is_null(void* pixmap) { return static_cast<QPixmap*>(pixmap)->isNull() ? 1 : 0; }

int eb_qt6_pixmap_width(void* pixmap) { return static_cast<QPixmap*>(pixmap)->width(); }

int eb_qt6_pixmap_height(void* pixmap) { return static_cast<QPixmap*>(pixmap)->height(); }

void eb_qt6_pixmap_destroy(void* pixmap) { delete static_cast<QPixmap*>(pixmap); }

int eb_qt6_pixmap_save(void* pixmap, const char* path) {
    return static_cast<QPixmap*>(pixmap)->save(QString::fromUtf8(path)) ? 1 : 0;
}

}
