#include "shim_label.h"

#include "shim_common.h"

#include <QLabel>
#include <QPixmap>
#include <QString>

extern "C" {

void* eb_qt6_label_create(const char* text) { return new QLabel(QString::fromUtf8(text)); }

void eb_qt6_label_set_text(void* label, const char* text) {
    static_cast<QLabel*>(label)->setText(QString::fromUtf8(text));
}

char* eb_qt6_label_get_text(void* label) {
    return eb_qt6_dup_qstring(static_cast<QLabel*>(label)->text());
}

int eb_qt6_label_set_pixmap_from_file(void* label, const char* path) {
    QPixmap pixmap(QString::fromUtf8(path));
    if (pixmap.isNull()) return 0;
    static_cast<QLabel*>(label)->setPixmap(pixmap);
    return 1;
}

void eb_qt6_label_set_alignment(void* label, int alignment) {
    static_cast<QLabel*>(label)->setAlignment(static_cast<Qt::Alignment>(alignment));
}

void eb_qt6_label_set_word_wrap(void* label, int wordWrap) {
    static_cast<QLabel*>(label)->setWordWrap(wordWrap != 0);
}

}
