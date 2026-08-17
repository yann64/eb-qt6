// eb-qt6 native shim - QGroupBox. A real QWidget subclass, so
// WidgetShow/WidgetResize/WidgetSetWindowTitle/WidgetSetLayout/
// WidgetDestroy (shim_widget.h) already work on its handle - only
// construction-with-a-title was new here, until Phase 20 added a
// checkable variant (a group box acting as an on/off section toggle -
// a common real Qt pattern, e.g. "Enable advanced options").
#pragma once

#include "shim_common.h"

extern "C" {

void* eb_qt6_groupbox_create(const char* title);
// Adds a checkbox in the title area - when checkable, real Qt also
// disables/enables all of the group box's own child widgets to match
// the checked state automatically (QGroupBox::setCheckable's own
// documented behavior), no extra wiring needed for that part.
void eb_qt6_groupbox_set_checkable(void* groupBox, int checkable);
int eb_qt6_groupbox_is_checked(void* groupBox);
void eb_qt6_groupbox_set_checked(void* groupBox, int checked);
void eb_qt6_groupbox_connect_toggled(void* groupBox, EbQt6BoolCallback cb, void* userData);

}
