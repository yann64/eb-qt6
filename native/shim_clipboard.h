// eb-qt6 native shim - QClipboard. Accessed via QApplication's own
// process-wide singleton (QGuiApplication::clipboard()) - there is no
// separate create function, matching QMainWindow::menuBar()/
// statusBar()'s own "always managed for you" convention.
#pragma once

extern "C" {

// `app` is an Application handle (from eb_qt6_application_create) -
// only used to make the dependency explicit in the raw/idiomatic
// layers; the real QClipboard* is a process-wide singleton regardless
// of which QApplication handle is passed.
void* eb_qt6_application_clipboard(void* app);
void eb_qt6_clipboard_set_text(void* clipboard, const char* text);
// Caller frees the result via eb_qt6_free_string.
char* eb_qt6_clipboard_get_text(void* clipboard);
// `pixmap` is a Pixmap handle (see shim_pixmap.h) - the clipboard makes
// its own internal copy (Qt's implicit sharing means this is cheap),
// so `pixmap` may be destroyed or reused right after this call
// returns, same convention as eb_qt6_label_set_pixmap.
void eb_qt6_clipboard_set_pixmap(void* clipboard, void* pixmap);
// Always returns a real (non-null) handle - check
// eb_qt6_pixmap_is_null on the result (the clipboard may hold text or
// nothing at all, not an image). Caller owns the returned Pixmap and
// must eventually call eb_qt6_pixmap_destroy on it.
void* eb_qt6_clipboard_get_pixmap(void* clipboard);

}
