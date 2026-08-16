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

}
