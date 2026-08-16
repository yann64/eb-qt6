// eb-qt6 native shim - QScrollBar, used standalone (distinct from
// QScrollArea's own internal scroll bars, shim_scrollarea.h). Mirrors
// QSlider's own function shape (shim_slider.h) - both are real
// QAbstractSlider subclasses.
#pragma once

#include "shim_common.h"

extern "C" {

// `orientation` matches real Qt::Orientation values: 1 = horizontal,
// 2 = vertical - same convention as eb_qt6_slider_create.
void* eb_qt6_scrollbar_create(int orientation);
void eb_qt6_scrollbar_set_range(void* scrollBar, int min, int max);
int eb_qt6_scrollbar_value(void* scrollBar);
void eb_qt6_scrollbar_set_value(void* scrollBar, int value);
void eb_qt6_scrollbar_connect_value_changed(void* scrollBar, EbQt6IntCallback cb, void* userData);

}
