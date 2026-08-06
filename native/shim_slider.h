// eb-qt6 native shim - QSlider.
#pragma once

#include "shim_common.h"

extern "C" {

// `orientation` matches real Qt::Orientation values: 1 = horizontal,
// 2 = vertical - no separate eBasic-side enum needed.
void* eb_qt6_slider_create(int orientation);
void eb_qt6_slider_set_range(void* slider, int min, int max);
int eb_qt6_slider_value(void* slider);
void eb_qt6_slider_set_value(void* slider, int value);
void eb_qt6_slider_connect_value_changed(void* slider, EbQt6IntCallback cb, void* userData);

}
