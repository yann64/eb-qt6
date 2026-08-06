// eb-qt6 native shim - QDial. A QAbstractSlider subclass, so this
// mirrors QSlider's own function shape exactly (shim_slider.h) - no
// orientation parameter needed, a dial is always circular.
#pragma once

#include "shim_common.h"

extern "C" {

void* eb_qt6_dial_create();
void eb_qt6_dial_set_range(void* dial, int min, int max);
int eb_qt6_dial_value(void* dial);
void eb_qt6_dial_set_value(void* dial, int value);
void eb_qt6_dial_connect_value_changed(void* dial, EbQt6IntCallback cb, void* userData);

}
