// eb-qt6 native shim - QStackedWidget.
//
// Like QTabWidget (shim_tabwidget.h), adding the first page makes it
// current, so eb_qt6_stackedwidget_add_widget can fire
// currentChanged(0) SYNCHRONOUSLY, during the call itself - construct
// anything a connected handler touches before adding any pages, not
// after.
#pragma once

#include "shim_common.h"

extern "C" {

void* eb_qt6_stackedwidget_create();
// Returns the new page's index. The stack now owns `page` - the same
// "container now owns it" convention as QBoxLayout::addWidget.
int eb_qt6_stackedwidget_add_widget(void* stack, void* page);
int eb_qt6_stackedwidget_current_index(void* stack);
void eb_qt6_stackedwidget_set_current_index(void* stack, int index);
void eb_qt6_stackedwidget_connect_current_changed(void* stack, EbQt6IntCallback cb, void* userData);

}
