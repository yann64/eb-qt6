// eb-qt6 native shim - QSpinBox.
#pragma once

#include "shim_common.h"

extern "C" {

void* eb_qt6_spinbox_create();
void eb_qt6_spinbox_set_range(void* spinBox, int min, int max);
int eb_qt6_spinbox_value(void* spinBox);
void eb_qt6_spinbox_set_value(void* spinBox, int value);
void eb_qt6_spinbox_connect_value_changed(void* spinBox, EbQt6IntCallback cb, void* userData);
// Text shown after the number (e.g. " %", " px") - part of the
// displayed text only, never part of eb_qt6_spinbox_value's own
// integer value.
void eb_qt6_spinbox_set_suffix(void* spinBox, const char* suffix);
// Text shown before the number (e.g. "$") - same "display only" rule
// as the suffix above.
void eb_qt6_spinbox_set_prefix(void* spinBox, const char* prefix);
// How much the value changes per up/down arrow click or scroll tick -
// real Qt's own default is 1.
void eb_qt6_spinbox_set_single_step(void* spinBox, int step);

}
