#include "shim_clipboard.h"

#include "shim_common.h"

#include <QClipboard>
#include <QGuiApplication>
#include <QString>

extern "C" {

void* eb_qt6_application_clipboard(void* app) {
    (void)app;  // unused: QClipboard is a process-wide singleton, see this file's own header comment.
    return QGuiApplication::clipboard();
}

void eb_qt6_clipboard_set_text(void* clipboard, const char* text) {
    static_cast<QClipboard*>(clipboard)->setText(QString::fromUtf8(text));
}

char* eb_qt6_clipboard_get_text(void* clipboard) {
    return eb_qt6_dup_qstring(static_cast<QClipboard*>(clipboard)->text());
}

}
