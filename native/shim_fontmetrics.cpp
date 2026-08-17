#include "shim_fontmetrics.h"

#include <QFont>
#include <QFontMetrics>
#include <QString>

namespace {

QFont MakeFont(const char* family, int pointSize, int bold, int italic) {
    QFont font(QString::fromUtf8(family), pointSize);
    font.setBold(bold != 0);
    font.setItalic(italic != 0);
    return font;
}

}  // namespace

extern "C" {

int eb_qt6_font_metrics_text_width(const char* family, int pointSize, int bold, int italic, const char* text) {
    QFontMetrics metrics(MakeFont(family, pointSize, bold, italic));
    return metrics.horizontalAdvance(QString::fromUtf8(text));
}

int eb_qt6_font_metrics_height(const char* family, int pointSize, int bold, int italic) {
    QFontMetrics metrics(MakeFont(family, pointSize, bold, italic));
    return metrics.height();
}

}
