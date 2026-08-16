// eb-qt6 native shim - QSystemTrayIcon.
#pragma once

#include "shim_common.h"

extern "C" {

void* eb_qt6_systemtrayicon_create();
// Loads a named icon from the current desktop icon theme (e.g.
// "dialog-information") - QIcon::fromTheme. No file-based/embedded icon
// loading bound yet.
void eb_qt6_systemtrayicon_set_icon_from_theme(void* tray, const char* themeIconName);
void eb_qt6_systemtrayicon_set_tooltip(void* tray, const char* text);
// The tray icon does NOT take ownership of `menu` - matching real Qt
// semantics (QSystemTrayIcon::setContextMenu keeps the caller
// responsible, unlike most "container now owns it" cases elsewhere in
// this package).
void eb_qt6_systemtrayicon_set_context_menu(void* tray, void* menu);
void eb_qt6_systemtrayicon_show(void* tray);
void eb_qt6_systemtrayicon_hide(void* tray);
// `reason` matches real QSystemTrayIcon::ActivationReason values
// (0=Unknown, 1=Context, 2=DoubleClick, 3=Trigger, 4=MiddleClick).
void eb_qt6_systemtrayicon_connect_activated(void* tray, EbQt6IntCallback cb, void* userData);

}
