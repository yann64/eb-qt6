// eb-qt6 native shim - QLCDNumber. Only integer display is bound (real
// Qt also supports double/QString) - the overwhelmingly common case.
#pragma once

extern "C" {

void* eb_qt6_lcdnumber_create();
void eb_qt6_lcdnumber_display(void* lcd, int value);

}
