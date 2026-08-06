#include "shim_progressbar.h"

#include <QProgressBar>

extern "C" {

void* eb_qt6_progressbar_create() { return new QProgressBar(); }

void eb_qt6_progressbar_set_range(void* bar, int min, int max) {
    static_cast<QProgressBar*>(bar)->setRange(min, max);
}

int eb_qt6_progressbar_value(void* bar) { return static_cast<QProgressBar*>(bar)->value(); }

void eb_qt6_progressbar_set_value(void* bar, int value) {
    static_cast<QProgressBar*>(bar)->setValue(value);
}

}
