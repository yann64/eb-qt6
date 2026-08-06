#include "shim_colordialog.h"

#include <QColor>
#include <QColorDialog>
#include <QString>
#include <QWidget>

extern "C" {

int eb_qt6_colordialog_get_color(void* parent, const char* title,
                                  unsigned char initR, unsigned char initG, unsigned char initB,
                                  unsigned char* outR, unsigned char* outG, unsigned char* outB) {
    QColor initial(initR, initG, initB);
    QColor result = QColorDialog::getColor(initial, static_cast<QWidget*>(parent), QString::fromUtf8(title));
    if (!result.isValid()) return 0;
    *outR = static_cast<unsigned char>(result.red());
    *outG = static_cast<unsigned char>(result.green());
    *outB = static_cast<unsigned char>(result.blue());
    return 1;
}

}
