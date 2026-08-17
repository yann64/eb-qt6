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

void eb_qt6_scrollarea_set_horizontal_scrollbar_policy(void* scrollArea, int policy) {
    static_cast<QScrollArea*>(scrollArea)->setHorizontalScrollBarPolicy(static_cast<Qt::ScrollBarPolicy>(policy));
}

void eb_qt6_scrollarea_set_vertical_scrollbar_policy(void* scrollArea, int policy) {
    static_cast<QScrollArea*>(scrollArea)->setVerticalScrollBarPolicy(static_cast<Qt::ScrollBarPolicy>(policy));
}

}
