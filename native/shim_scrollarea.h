// eb-qt6 native shim - QScrollArea.
#pragma once

extern "C" {

void* eb_qt6_scrollarea_create();
// The scroll area now owns `widget` - the same "container now owns it"
// convention already documented for layouts/central widgets.
void eb_qt6_scrollarea_set_widget(void* scrollArea, void* widget);
// Real Qt defaults this to false, which often looks wrong (the widget
// stays at its own sizeHint instead of filling the viewport) - most
// callers want true.
void eb_qt6_scrollarea_set_widget_resizable(void* scrollArea, int resizable);
// `policy` matches real Qt::ScrollBarPolicy values: 0=ScrollBarAsNeeded
// (the default), 1=ScrollBarAlwaysOff, 2=ScrollBarAlwaysOn.
void eb_qt6_scrollarea_set_horizontal_scrollbar_policy(void* scrollArea, int policy);
void eb_qt6_scrollarea_set_vertical_scrollbar_policy(void* scrollArea, int policy);

}
