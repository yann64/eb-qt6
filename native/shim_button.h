// eb-qt6 native shim - QPushButton. The first per-signal-connect
// exemplar - see shim_common.h's own top comment on why Qt6 needs one
// shim connect-function per (class, signal) pair, unlike eb-gtk4's
// single generic ObjConnect.
#pragma once

#include "shim_common.h"

extern "C" {

void* eb_qt6_button_create(const char* label);
void eb_qt6_button_set_text(void* button, const char* label);
// Caller frees the result via eb_qt6_free_string.
char* eb_qt6_button_get_text(void* button);
void eb_qt6_button_connect_clicked(void* button, EbQt6VoidCallback cb, void* userData);

}
