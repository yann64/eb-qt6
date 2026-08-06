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

}
