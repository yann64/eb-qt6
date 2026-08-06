// eb-qt6 native shim - QDialog plus the two stock convenience dialog
// families (QMessageBox, QFileDialog). QDialog is a real QWidget
// subclass, so WidgetShow/WidgetResize/WidgetSetWindowTitle/
// WidgetSetLayout/WidgetDestroy (shim_widget.h) already work on a
// dialog's handle - only exec()/accept()/reject()/finished are new
// here.
#pragma once

#include "shim_common.h"

extern "C" {

void* eb_qt6_dialog_create();
// Blocks (real Qt modal event loop) until the dialog is closed. Returns
// 1 (QDialog::Accepted) or 0 (QDialog::Rejected).
int eb_qt6_dialog_exec(void* dialog);
void eb_qt6_dialog_accept(void* dialog);
void eb_qt6_dialog_reject(void* dialog);
// `value` is the same 1/0 Accepted/Rejected code eb_qt6_dialog_exec
// returns.
void eb_qt6_dialog_connect_finished(void* dialog, EbQt6IntCallback cb, void* userData);

// `parent` may be a null ANY PTR for no parent window.
void eb_qt6_messagebox_information(void* parent, const char* title, const char* text);
void eb_qt6_messagebox_warning(void* parent, const char* title, const char* text);
// Returns 1 if the user clicked Yes, 0 for No.
int eb_qt6_messagebox_question(void* parent, const char* title, const char* text);

// `parent` may be a null ANY PTR for no parent window. Caller frees the
// result via eb_qt6_free_string - an empty string means the user
// cancelled.
char* eb_qt6_filedialog_get_open_file_name(void* parent, const char* caption, const char* dir, const char* filter);
char* eb_qt6_filedialog_get_save_file_name(void* parent, const char* caption, const char* dir, const char* filter);

}
