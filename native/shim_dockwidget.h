// eb-qt6 native shim - QDockWidget. A real QWidget subclass, so
// WidgetShow/WidgetResize/WidgetSetWindowTitle/WidgetDestroy
// (shim_widget.h) already work on its handle.
#pragma once

extern "C" {

void* eb_qt6_dockwidget_create(const char* title);
// The dock widget now owns `widget` - the same "container now owns it"
// convention already documented for layouts/central widgets.
void eb_qt6_dockwidget_set_widget(void* dockWidget, void* widget);
// `area` matches real Qt::DockWidgetArea values (1=left, 2=right,
// 4=top, 8=bottom) - no separate eBasic-side enum needed. The window
// now owns `dockWidget`.
void eb_qt6_mainwindow_add_dock_widget(void* window, int area, void* dockWidget);

}
