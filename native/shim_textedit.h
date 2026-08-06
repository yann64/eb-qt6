// eb-qt6 native shim - QTextEdit (plain-text mode only; this package
// exposes no rich-text/formatting surface at all, matching
// eb-haiku's own BTextView scope). QTextEdit::textChanged() takes no
// arguments (unlike QLineEdit::textChanged(const QString&)) - reuses
// EbQt6VoidCallback, not EbQt6StringCallback; call
// eb_qt6_textedit_get_text yourself inside the callback if you need the
// new content.
#pragma once

#include "shim_common.h"

extern "C" {

void* eb_qt6_textedit_create();
void eb_qt6_textedit_set_text(void* textEdit, const char* text);
// Caller frees the result via eb_qt6_free_string.
char* eb_qt6_textedit_get_text(void* textEdit);
void eb_qt6_textedit_connect_text_changed(void* textEdit, EbQt6VoidCallback cb, void* userData);

}
