// eb-qt6 native shim - QTimer. A plain QObject, like QButtonGroup (see
// shim_buttongroup.h's own top comment) - needs a real parent at
// construction so Qt manages its lifetime, or it would leak silently
// if never parented or destroyed.
#pragma once

#include "shim_common.h"

extern "C" {

// `parent` may be a null ANY PTR, but passing a real parent widget is
// strongly recommended - see this file's own top comment.
void* eb_qt6_timer_create(void* parent);
void eb_qt6_timer_set_interval(void* timer, int milliseconds);
void eb_qt6_timer_set_single_shot(void* timer, int singleShot);
// Starts (or restarts) the timer using its currently-set interval.
void eb_qt6_timer_start(void* timer);
void eb_qt6_timer_stop(void* timer);
int eb_qt6_timer_is_active(void* timer);
void eb_qt6_timer_connect_timeout(void* timer, EbQt6VoidCallback cb, void* userData);

}
