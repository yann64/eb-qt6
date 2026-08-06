#include "shim_lcdnumber.h"

#include <QLCDNumber>

extern "C" {

void* eb_qt6_lcdnumber_create() { return new QLCDNumber(); }

void eb_qt6_lcdnumber_display(void* lcd, int value) {
    static_cast<QLCDNumber*>(lcd)->display(value);
}

}
