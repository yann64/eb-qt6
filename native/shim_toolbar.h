// eb-qt6 native shim - QToolBar. A MainWindow creates and owns its own
// tool bars via addToolBar - there is no separate create/destroy
// function, the same "container now owns it" convention already
// documented for menus.
#pragma once

extern "C" {

void* eb_qt6_mainwindow_add_toolbar(void* window, const char* title);
// Returns the new action's handle (a real QAction, the same type
// eb_qt6_menu_add_action returns) - the tool bar now owns it. Use
// eb_qt6_action_connect_triggered (shim_menu.h) to wire it up.
void* eb_qt6_toolbar_add_action(void* toolBar, const char* text);
// Real QMainWindow supports any number of independent tool bars
// (addToolBar always creates a fresh one) - this tracks a single
// "the window's own tool bar" association per window (an untitled,
// auto-created-once one), the same singleton role
// eb_qt6_mainwindow_menu_bar already plays for menus, needed only
// because Qt itself has no such built-in singleton for tool bars.
void* eb_qt6_mainwindow_get_or_create_toolbar(void* window);

}
