// eb-qt6 native shim - QButtonGroup. Enables cross-container radio
// button exclusivity (real Qt's own default only groups by immediate
// parent widget, see shim_checkbox.h's own top comment) - noted as
// unbound since Phase 2, added here.
#pragma once

#include "shim_common.h"

extern "C" {

// `parent` may be a null ANY PTR, but real Qt idiom (and this package's
// own ownership philosophy - see widget.bas's top comment) is to pass a
// real parent widget so Qt manages the group's lifetime automatically;
// QButtonGroup is a plain QObject organizer with no natural widget-tree
// owner otherwise, and would leak if never parented or destroyed.
void* eb_qt6_buttongroup_create(void* parent);
// `button` is any real QAbstractButton (a CheckBox or RadioButton
// handle) - the group does NOT take ownership (matching real Qt:
// QButtonGroup is a pure QObject organizer, the button's actual parent
// widget/layout still owns it).
void eb_qt6_buttongroup_add_button(void* group, void* button);
// May return a null ANY PTR if nothing in the group is checked.
void* eb_qt6_buttongroup_checked_button(void* group);
void eb_qt6_buttongroup_connect_button_clicked(void* group, EbQt6PtrCallback cb, void* userData);

}
