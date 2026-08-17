// eb-qt6 native shim - QToolButton, standalone (usable in any layout,
// not just a QToolBar - QToolBar's own action buttons, shim_toolbar.h,
// are real QToolButtons created internally by Qt itself; this is for
// wanting one directly, most commonly to show a popup QMenu on click,
// e.g. a "..." options button).
#pragma once

#include "shim_common.h"

extern "C" {

void* eb_qt6_toolbutton_create();
void eb_qt6_toolbutton_set_text(void* button, const char* text);
void eb_qt6_toolbutton_connect_clicked(void* button, EbQt6VoidCallback cb, void* userData);
// Attaches a QMenu (shim_menu.h) to show on click - the button does
// NOT take ownership of `menu` (real QToolButton::setMenu semantics),
// unlike this package's usual "container now owns it" convention, so
// `menu` needs its own lifetime management if not otherwise parented.
void eb_qt6_toolbutton_set_menu(void* button, void* menu);
// `mode` matches real QToolButton::ToolButtonPopupMode values:
// 0=DelayedPopup (a fallback timer shows the menu; clicking the main
// button area still fires `clicked`), 1=MenuButtonPopup (a distinct
// arrow sub-button shows the menu; clicking elsewhere fires `clicked`),
// 2=InstantPopup (clicking anywhere shows the menu immediately;
// `clicked` never fires on its own - the common choice for a
// menu-only button with no independent default action).
void eb_qt6_toolbutton_set_popup_mode(void* button, int mode);

}
