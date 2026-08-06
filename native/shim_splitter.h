// eb-qt6 native shim - QSplitter.
#pragma once

extern "C" {

// `orientation` matches real Qt::Orientation values: 1 = horizontal,
// 2 = vertical - same convention as eb_qt6_slider_create.
void* eb_qt6_splitter_create(int orientation);
// The splitter now owns `widget` - the same "container now owns it"
// convention already documented for layouts/central widgets.
void eb_qt6_splitter_add_widget(void* splitter, void* widget);

}
