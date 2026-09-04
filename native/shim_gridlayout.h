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
// Real QGridLayout's own align-aware addWidget overload - `alignment`
// is a Qt::Alignment bitmask (see src/label.bas's QtAlign* constants).
void eb_qt6_gridlayout_add_widget_align(void* layout, void* widget, int row, int col, int rowSpan, int colSpan, int alignment);
// Per-column/row relative growth weight - real, independent of which
// widget(s) occupy that column/row (unlike GTK4's GtkGrid, which has
// no such concept at all).
void eb_qt6_gridlayout_set_row_stretch(void* layout, int row, int stretch);
void eb_qt6_gridlayout_set_column_stretch(void* layout, int column, int stretch);

}
