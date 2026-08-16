// eb-qt6 native shim - QTextEdit. Plain-text get/set/signal (below)
// matches eb-haiku's own BTextView scope; eb_qt6_textedit_set_html/
// _get_html add real Qt rich-text (a small HTML subset - see Qt's own
// "Supported HTML Subset" docs) as an explicit opt-in, not the default.
// QTextEdit::textChanged() takes no arguments (unlike
// QLineEdit::textChanged(const QString&)) - reuses EbQt6VoidCallback,
// not EbQt6StringCallback; call eb_qt6_textedit_get_text/_get_html
// yourself inside the callback if you need the new content.
#pragma once

#include "shim_common.h"

extern "C" {

void* eb_qt6_textedit_create();
void eb_qt6_textedit_set_text(void* textEdit, const char* text);
// Caller frees the result via eb_qt6_free_string.
char* eb_qt6_textedit_get_text(void* textEdit);
// Sets rich-text content from an HTML string (Qt's own supported
// subset) - overwrites any plain-text content set via
// eb_qt6_textedit_set_text.
void eb_qt6_textedit_set_html(void* textEdit, const char* html);
// Caller frees the result via eb_qt6_free_string. Returns the content
// as Qt's own generated HTML, even if it was set as plain text.
char* eb_qt6_textedit_get_html(void* textEdit);
void eb_qt6_textedit_connect_text_changed(void* textEdit, EbQt6VoidCallback cb, void* userData);

}
