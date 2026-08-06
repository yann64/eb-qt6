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

}
