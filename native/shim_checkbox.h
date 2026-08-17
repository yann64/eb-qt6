// eb-qt6 native shim - QCheckBox/QRadioButton. Both are QAbstractButton
// subclasses sharing the exact same real API shape (setText/text/
// setChecked/isChecked/toggled), so one function family serves both -
// the `is_radio` flag at construction is the only difference, matching
// eb-haiku's own "one function, several real subclasses" convention
// already used for HControlSetEnabled.
//
// QRadioButton's mutual exclusivity is Qt's own default behavior for
// radio buttons sharing the same immediate parent widget - no
// QButtonGroup needed for the common case (deliberately not bound in
// this phase; a real, named follow-on for cross-container grouping).
#pragma once

#include "shim_common.h"

extern "C" {

void* eb_qt6_checkbox_create(const char* text);
void* eb_qt6_radiobutton_create(const char* text);
void eb_qt6_abstractbutton_set_checked(void* button, int checked);
int eb_qt6_abstractbutton_is_checked(void* button);
void eb_qt6_abstractbutton_connect_toggled(void* button, EbQt6BoolCallback cb, void* userData);
// Caller frees the result via eb_qt6_free_string - see
// ButtonGetText's own doc comment. NOT eb_qt6_button_get_text: that one
// casts to QPushButton*, which is invalid for a QCheckBox/QRadioButton
// handle (sibling QAbstractButton subclasses, not related to
// QPushButton by inheritance) - this function casts to the shared
// QAbstractButton* base instead, which has text() too.
char* eb_qt6_abstractbutton_get_text(void* button);

// Tristate is a QCheckBox-only concept (real QRadioButton has no
// partially-checked state) - these three take a checkbox handle
// specifically, not the shared AbstractButton base above.
void eb_qt6_checkbox_set_tristate(void* checkbox, int tristate);
// `state` and the return value match real Qt::CheckState: 0=Unchecked,
// 1=PartiallyChecked (only reachable via eb_qt6_checkbox_set_check_state
// itself when tristate is on - real Qt doesn't let a user click their
// way into it directly, only through this or a parent/child checkbox
// relationship this shim doesn't implement), 2=Checked.
void eb_qt6_checkbox_set_check_state(void* checkbox, int state);
int eb_qt6_checkbox_check_state(void* checkbox);

}
