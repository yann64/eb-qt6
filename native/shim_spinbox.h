// eb-qt6 native shim - QSpinBox.
#pragma once

#include "shim_common.h"

extern "C" {

void* eb_qt6_spinbox_create();
void eb_qt6_spinbox_set_range(void* spinBox, int min, int max);
int eb_qt6_spinbox_value(void* spinBox);
void eb_qt6_spinbox_set_value(void* spinBox, int value);
void eb_qt6_spinbox_connect_value_changed(void* spinBox, EbQt6IntCallback cb, void* userData);

}
