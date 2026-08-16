#include "shim_frame.h"

#include <QFrame>

extern "C" {

void* eb_qt6_frame_create() { return new QFrame(); }

void eb_qt6_frame_set_frame_style(void* frame, int shape, int shadow) {
    static_cast<QFrame*>(frame)->setFrameStyle(shape | shadow);
}

}
