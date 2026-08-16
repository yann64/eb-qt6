#include "shim_widget.h"

#include <QBoxLayout>
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

void eb_qt6_widget_set_layout(void* widget, void* layout) {
    static_cast<QWidget*>(widget)->setLayout(static_cast<QLayout*>(layout));
}

}
