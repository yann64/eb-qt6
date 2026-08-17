#include "shim_tooltip.h"

#include <QPoint>
#include <QString>
#include <QToolTip>

extern "C" {

void eb_qt6_tooltip_show_text(int x, int y, const char* text) {
    QToolTip::showText(QPoint(x, y), QString::fromUtf8(text));
}

void eb_qt6_tooltip_hide() { QToolTip::hideText(); }

}
