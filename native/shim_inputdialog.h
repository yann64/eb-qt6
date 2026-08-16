// eb-qt6 native shim - QInputDialog. Static convenience dialogs, not
// persistent widgets, matching QMessageBox/QColorDialog/QFontDialog
// (shim_dialog.h/shim_colordialog.h/shim_fontdialog.h) - same
// valid-flag-out-parameter shape.
#pragma once

extern "C" {

// `parent` may be a null ANY PTR for no parent window. Caller frees the
// result via eb_qt6_free_string. Fills `outValid` (1 if the user
// accepted, 0 if they cancelled) - on cancel, the returned string is
// empty.
char* eb_qt6_inputdialog_get_text(void* parent, const char* title, const char* label, const char* initialText, int* outValid);

// Fills `outValue` and `outValid` only when the user accepts (non-zero)
// - on cancel, `outValue` is left untouched.
void eb_qt6_inputdialog_get_int(void* parent, const char* title, const char* label, int initialValue, int min, int max, int* outValue, int* outValid);

// A minimal QStringList builder, used only by
// eb_qt6_inputdialog_get_item below - mirrors QComboBox's own
// create-then-add-item convention (shim_combobox.h). The dialog
// function below CONSUMES and destroys `items` itself - do not reuse
// or free it afterwards, the same "container now owns it" convention
// documented elsewhere in this package (here, ownership transfers at
// the get_item call, not at creation).
void* eb_qt6_stringlist_create();
void eb_qt6_stringlist_add(void* list, const char* text);

// Caller frees the result via eb_qt6_free_string. Fills `outValid` (1
// if accepted, 0 if cancelled, in which case the returned string is
// empty). Destroys `items` - see this file's own comment on
// eb_qt6_stringlist_create.
char* eb_qt6_inputdialog_get_item(void* parent, const char* title, const char* label, void* items, int currentIndex, int editable, int* outValid);

}
