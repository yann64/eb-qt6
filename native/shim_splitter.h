// eb-qt6 native shim - QSplitter.
#pragma once

extern "C" {

// `orientation` matches real Qt::Orientation values: 1 = horizontal,
// 2 = vertical - same convention as eb_qt6_slider_create.
void* eb_qt6_splitter_create(int orientation);
// The splitter now owns `widget` - the same "container now owns it"
// convention already documented for layouts/central widgets.
void eb_qt6_splitter_add_widget(void* splitter, void* widget);
// Sets the first two panes' initial pixel sizes (real
// QSplitter::setSizes takes an arbitrary-length list; this covers the
// overwhelmingly common two-pane case without needing an int-array
// marshaling mechanism this package doesn't otherwise have). Any panes
// beyond the first two keep their default size. Real Qt treats the
// given sizes as proportional weights, not hard pixel constraints - the
// splitter still respects each widget's own minimum size.
void eb_qt6_splitter_set_sizes_2(void* splitter, int firstSize, int secondSize);

}
