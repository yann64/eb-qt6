// eb-qt6 native shim - QGroupBox. A real QWidget subclass, so
// WidgetShow/WidgetResize/WidgetSetWindowTitle/WidgetSetLayout/
// WidgetDestroy (shim_widget.h) already work on its handle - only
// construction-with-a-title is new here.
#pragma once

extern "C" {

void* eb_qt6_groupbox_create(const char* title);

}
