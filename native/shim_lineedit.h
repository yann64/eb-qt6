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

// Constructs a new QIntValidator/QDoubleValidator parented to
// `lineEdit` itself (so Qt manages its lifetime automatically, tied to
// the widget - no separate handle for the caller to track) and attaches
// it via QLineEdit::setValidator. Replaces any previously-set
// validator.
void eb_qt6_lineedit_set_int_validator(void* lineEdit, int bottom, int top);
void eb_qt6_lineedit_set_double_validator(void* lineEdit, double bottom, double top, int decimals);

// `mode` matches real QLineEdit::EchoMode values: 0=Normal (plain
// text, the default), 1=NoEcho (nothing shown at all, not even dots),
// 2=Password (masking characters, e.g. dots), 3=PasswordEchoOnEdit
// (shows characters while typing, masks once focus leaves).
void eb_qt6_lineedit_set_echo_mode(void* lineEdit, int mode);

// Constructs a new QRegularExpressionValidator parented to `lineEdit`
// itself (same lifetime convention as eb_qt6_lineedit_set_int_validator
// above) and attaches it via QLineEdit::setValidator. Replaces any
// previously-set validator. `pattern` is a real PCRE-like regular
// expression (QRegularExpression syntax) - an invalid pattern makes the
// validator accept nothing at all (real Qt behavior: an invalid
// QRegularExpression never matches), not a crash or silent no-op.
void eb_qt6_lineedit_set_regex_validator(void* lineEdit, const char* pattern);

// Grayed-out hint text shown only while the field is empty - real
// QLineEdit::setPlaceholderText, never part of the field's own real
// value (eb_qt6_lineedit_get_text never returns it).
void eb_qt6_lineedit_set_placeholder_text(void* lineEdit, const char* text);
// Caps how many characters can be typed/pasted in - real
// QLineEdit::setMaxLength (Qt's own default is a very large number,
// effectively unlimited, until this is called).
void eb_qt6_lineedit_set_max_length(void* lineEdit, int maxLength);
void eb_qt6_lineedit_select_all(void* lineEdit);
void eb_qt6_lineedit_clear(void* lineEdit);
// A read-only field still shows/selects/copies its text and scrolls,
// just rejects typed/pasted edits - real QLineEdit::setReadOnly. Off
// by default.
void eb_qt6_lineedit_set_read_only(void* lineEdit, int readOnly);

}
