#include "shim_scrollarea.h"

#include <QScrollArea>
#include <QWidget>

extern "C" {

void* eb_qt6_scrollarea_create() { return new QScrollArea(); }

void eb_qt6_scrollarea_set_widget(void* scrollArea, void* widget) {
    static_cast<QScrollArea*>(scrollArea)->setWidget(static_cast<QWidget*>(widget));
}

void eb_qt6_scrollarea_set_widget_resizable(void* scrollArea, int resizable) {
    static_cast<QScrollArea*>(scrollArea)->setWidgetResizable(resizable != 0);
}

}
