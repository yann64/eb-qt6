// eb-qt6 native shim - QCompleter, attached to a QLineEdit
// (QLineEdit::setCompleter).
#pragma once

extern "C" {

// Consumes and destroys `items` (a StringList handle, see
// shim_inputdialog.h's own eb_qt6_stringlist_create) - QCompleter
// copies the list's contents internally, matching
// eb_qt6_inputdialog_get_item's own consume-and-destroy convention for
// the same StringList type.
void* eb_qt6_completer_create(void* items);
// If `completer` has no parent of its own (the common case - see
// eb_qt6_completer_create), the line edit takes ownership of it,
// matching real QLineEdit::setCompleter semantics - no separate destroy
// function needed.
void eb_qt6_lineedit_set_completer(void* lineEdit, void* completer);

}
