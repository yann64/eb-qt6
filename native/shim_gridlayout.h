// eb-qt6 native shim - QGridLayout. Applied to a widget via the
// existing generic eb_qt6_widget_set_layout (shim_widget.h) - no
// separate set-layout function needed, since that function already
// takes any real QLayout* handle.
#pragma once

extern "C" {

void* eb_qt6_gridlayout_create();
// The layout now owns `widget` - the same "container now owns it"
// convention as QBoxLayout::addWidget.
void eb_qt6_gridlayout_add_widget(void* layout, void* widget, int row, int col, int rowSpan, int colSpan);

}
