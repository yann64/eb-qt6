#include "shim_fontdialog.h"

#include "shim_common.h"

#include <QFont>
#include <QFontDialog>
#include <QWidget>

extern "C" {

char* eb_qt6_fontdialog_get_font(void* parent, int* outPointSize, int* outValid) {
    bool ok = false;
    QFont result = QFontDialog::getFont(&ok, static_cast<QWidget*>(parent));
    *outValid = ok ? 1 : 0;
    if (!ok) return eb_qt6_dup_qstring(QString());
    *outPointSize = result.pointSize();
    return eb_qt6_dup_qstring(result.family());
}

}
