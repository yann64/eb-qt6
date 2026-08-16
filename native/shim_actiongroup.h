// eb-qt6 native shim - QActionGroup, the QAction equivalent of
// QButtonGroup (shim_buttongroup.h) - mutually exclusive actions, e.g.
// a set of menu items where only one can be checked at a time.
#pragma once

#include "shim_common.h"

extern "C" {

// `parent` may be a null ANY PTR, but passing a real parent widget is
// strongly recommended, same rationale as eb_qt6_buttongroup_create - a
// plain QObject organizer with no natural widget-tree owner otherwise.
void* eb_qt6_actiongroup_create(void* parent);
// `action` must be checkable (real Qt requirement - see
// QAction::setCheckable, not yet bound separately; construct actions
// intended for a group with this in mind). The group does NOT take
// ownership - matching eb_qt6_buttongroup_add_button's own semantics.
void eb_qt6_actiongroup_add_action(void* group, void* action);
void eb_qt6_actiongroup_connect_triggered(void* group, EbQt6PtrCallback cb, void* userData);

}
