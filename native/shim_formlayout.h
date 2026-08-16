// eb-qt6 native shim - QFormLayout. Applied to a widget via the
// existing generic eb_qt6_widget_set_layout (shim_widget.h).
#pragma once

extern "C" {

void* eb_qt6_formlayout_create();
// The layout now owns `widget` - the same "container now owns it"
// convention as QBoxLayout::addWidget.
void eb_qt6_formlayout_add_row(void* layout, const char* labelText, void* widget);

}
