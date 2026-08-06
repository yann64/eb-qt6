#include "shim_label.h"

#include "shim_common.h"

#include <QLabel>
#include <QString>

extern "C" {

void* eb_qt6_label_create(const char* text) { return new QLabel(QString::fromUtf8(text)); }

void eb_qt6_label_set_text(void* label, const char* text) {
    static_cast<QLabel*>(label)->setText(QString::fromUtf8(text));
}

char* eb_qt6_label_get_text(void* label) {
    return eb_qt6_dup_qstring(static_cast<QLabel*>(label)->text());
}

}
