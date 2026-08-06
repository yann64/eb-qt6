// eb-qt6 native shim - QLineEdit. Introduces the deliberate three-step
// complexity ramp this package's own plan called for: create/setText/
// text (reusing nothing new), then `returnPressed` (reuses
// EbQt6VoidCallback - a cheap "does the pattern scale" checkpoint after
// QPushButton::clicked), then `textChanged` (the first signal needing
// EbQt6StringCallback's QString->const char* marshaling).
//
// The `text` an EbQt6StringCallback receives is BORROWED, valid only for
// the duration of that one call - freed by the shim itself right after
// the eBasic callback returns, unlike eb_qt6_lineedit_get_text's own
// OWNED-allocation result (which the caller must free via
// eb_qt6_free_string). Same distinction eb-gtk4 already draws between a
// signal handler's own borrowed parameters and an explicit getter's
// owned return value.
#pragma once

#include "shim_common.h"

extern "C" {

void* eb_qt6_lineedit_create(const char* text);
void eb_qt6_lineedit_set_text(void* lineEdit, const char* text);
// Caller frees the result via eb_qt6_free_string.
char* eb_qt6_lineedit_get_text(void* lineEdit);
void eb_qt6_lineedit_connect_return_pressed(void* lineEdit, EbQt6VoidCallback cb, void* userData);
void eb_qt6_lineedit_connect_text_changed(void* lineEdit, EbQt6StringCallback cb, void* userData);

}
