// eb-qt6 native shim - QTabWidget.
#pragma once

#include "shim_common.h"

extern "C" {

void* eb_qt6_tabwidget_create();
// Returns the new tab's index. The tab widget now owns `page` (same
// "container now owns it" convention as QBoxLayout::addWidget) - do not
// call eb_qt6_widget_destroy on it afterwards.
int eb_qt6_tabwidget_add_tab(void* tabWidget, void* page, const char* title);
int eb_qt6_tabwidget_current_index(void* tabWidget);
void eb_qt6_tabwidget_set_current_index(void* tabWidget, int index);
void eb_qt6_tabwidget_connect_current_changed(void* tabWidget, EbQt6IntCallback cb, void* userData);

}
