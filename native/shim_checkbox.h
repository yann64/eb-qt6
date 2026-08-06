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

}
