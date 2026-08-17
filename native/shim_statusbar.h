// eb-qt6 native shim - QStatusBar. A MainWindow always manages its own
// status bar (auto-created on first access, matching real
// QMainWindow::statusBar() semantics) - there is no separate create
// function.
#pragma once

extern "C" {

void* eb_qt6_mainwindow_status_bar(void* window);
// `timeout` is milliseconds the message stays visible before clearing;
// 0 means "until replaced" (real Qt default).
void eb_qt6_statusbar_show_message(void* statusBar, const char* text, int timeout);
// Adds `widget` to the right-aligned "permanent" area of the status
// bar - unlike eb_qt6_statusbar_show_message's temporary text, this
// stays visible regardless of what ShowMessage is doing (e.g. a
// permanent "Ready"/battery-icon-style indicator). The status bar now
// owns `widget` - the same "container now owns it" convention used
// throughout this package.
void eb_qt6_statusbar_add_permanent_widget(void* statusBar, void* widget);

}
