// eb-qt6 native shim - QProgressBar.
#pragma once

extern "C" {

void* eb_qt6_progressbar_create();
void eb_qt6_progressbar_set_range(void* bar, int min, int max);
int eb_qt6_progressbar_value(void* bar);
void eb_qt6_progressbar_set_value(void* bar, int value);

}
