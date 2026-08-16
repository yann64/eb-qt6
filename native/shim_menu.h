// eb-qt6 native shim - QMenuBar/QMenu/QAction. A QMainWindow always
// manages its own menu bar (auto-created on first access, matching real
// Qt idiom) - there is no separate eb_qt6_menubar_create; use
// eb_qt6_mainwindow_menu_bar instead. QMenuBar::addMenu/QMenu::addAction
// both construct-and-own the returned object (the menu bar owns its
// menus, a menu owns its actions) - no separate destroy function, the
// same "container now owns it" convention widget.h's own top comment
// already documents for layouts/central widgets.
#pragma once

#include "shim_common.h"

extern "C" {

// A standalone, unparented top-level QMenu - needed for contexts with
// no menu bar to hang it off of (e.g. QSystemTrayIcon::setContextMenu).
// The caller is responsible for its lifetime unless something else
// (like setContextMenu) takes it over - see that function's own
// ownership note.
void* eb_qt6_menu_create();
void* eb_qt6_mainwindow_menu_bar(void* window);
void* eb_qt6_menubar_add_menu(void* menuBar, const char* title);
void* eb_qt6_menu_add_action(void* menu, const char* text);
// QAction::triggered(bool checked = false) - same shape as
// QPushButton::clicked, reuses EbQt6VoidCallback (the bool is ignored,
// same as clicked's own forwarding lambda already does).
void eb_qt6_action_connect_triggered(void* action, EbQt6VoidCallback cb, void* userData);

}
