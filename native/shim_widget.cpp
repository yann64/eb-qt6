#include "shim_widget.h"

#include <QBoxLayout>
#include <QCursor>
#include <QFont>
#include <QMainWindow>
#include <QString>
#include <QWidget>

extern "C" {

void* eb_qt6_widget_create() { return new QWidget(); }

void eb_qt6_widget_show(void* widget) { static_cast<QWidget*>(widget)->show(); }

void eb_qt6_widget_resize(void* widget, int width, int height) {
    static_cast<QWidget*>(widget)->resize(width, height);
}

void eb_qt6_widget_set_window_title(void* widget, const char* title) {
    static_cast<QWidget*>(widget)->setWindowTitle(QString::fromUtf8(title));
}

void eb_qt6_widget_set_style_sheet(void* widget, const char* styleSheet) {
    static_cast<QWidget*>(widget)->setStyleSheet(QString::fromUtf8(styleSheet));
}

void eb_qt6_widget_set_tool_tip(void* widget, const char* toolTip) {
    static_cast<QWidget*>(widget)->setToolTip(QString::fromUtf8(toolTip));
}

void eb_qt6_widget_set_minimum_size(void* widget, int width, int height) {
    static_cast<QWidget*>(widget)->setMinimumSize(width, height);
}

void eb_qt6_widget_set_maximum_size(void* widget, int width, int height) {
    static_cast<QWidget*>(widget)->setMaximumSize(width, height);
}

void eb_qt6_widget_set_focus(void* widget) { static_cast<QWidget*>(widget)->setFocus(); }

int eb_qt6_widget_has_focus(void* widget) { return static_cast<QWidget*>(widget)->hasFocus() ? 1 : 0; }

void eb_qt6_widget_set_enabled(void* widget, int enabled) {
    static_cast<QWidget*>(widget)->setEnabled(enabled != 0);
}

int eb_qt6_widget_is_enabled(void* widget) { return static_cast<QWidget*>(widget)->isEnabled() ? 1 : 0; }

void eb_qt6_widget_set_visible(void* widget, int visible) {
    static_cast<QWidget*>(widget)->setVisible(visible != 0);
}

int eb_qt6_widget_is_visible(void* widget) { return static_cast<QWidget*>(widget)->isVisible() ? 1 : 0; }

void eb_qt6_widget_set_font(void* widget, const char* family, int pointSize, int bold, int italic) {
    QFont font(QString::fromUtf8(family), pointSize);
    font.setBold(bold != 0);
    font.setItalic(italic != 0);
    static_cast<QWidget*>(widget)->setFont(font);
}

void eb_qt6_widget_set_cursor(void* widget, int shape) {
    static_cast<QWidget*>(widget)->setCursor(QCursor(static_cast<Qt::CursorShape>(shape)));
}

void eb_qt6_widget_destroy(void* widget) {
    // deleteLater(), never a raw `delete` - see this file's own header
    // comment on why (a common real pattern - "close this window when
    // this button is clicked" - is a use-after-free hazard with a raw
    // delete called from inside the widget's own signal callback).
    static_cast<QWidget*>(widget)->deleteLater();
}

void* eb_qt6_mainwindow_create() {
    // Qt::WA_DeleteOnClose deliberately left unset - closing hides, does
    // not delete, matching eb-gtk4's own explicit-lifetime philosophy
    // (see this file's own top comment).
    return new QMainWindow();
}

void eb_qt6_mainwindow_set_central_widget(void* window, void* widget) {
    static_cast<QMainWindow*>(window)->setCentralWidget(static_cast<QWidget*>(widget));
}

void* eb_qt6_vboxlayout_create() { return new QVBoxLayout(); }

void* eb_qt6_hboxlayout_create() { return new QHBoxLayout(); }

void eb_qt6_boxlayout_add_widget(void* layout, void* widget) {
    static_cast<QBoxLayout*>(layout)->addWidget(static_cast<QWidget*>(widget));
}

void eb_qt6_boxlayout_set_spacing(void* layout, int spacing) {
    static_cast<QBoxLayout*>(layout)->setSpacing(spacing);
}

void eb_qt6_boxlayout_set_contents_margins(void* layout, int left, int top, int right, int bottom) {
    static_cast<QBoxLayout*>(layout)->setContentsMargins(left, top, right, bottom);
}

void eb_qt6_widget_set_layout(void* widget, void* layout) {
    static_cast<QWidget*>(widget)->setLayout(static_cast<QLayout*>(layout));
}

}
