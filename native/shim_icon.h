// eb-qt6 native shim - icons for buttons/actions/windows. No separate
// QIcon handle/TYPE - each function takes a theme name or file path
// directly and builds a QIcon internally, then copies it into the
// target via Qt's own cheap implicitly-shared QIcon copy (matching
// QSystemTrayIcon's own eb_qt6_systemtrayicon_set_icon_from_theme
// convention, extended to buttons/actions/windows here).
#pragma once

extern "C" {

void eb_qt6_button_set_icon_from_theme(void* button, const char* themeIconName);
void eb_qt6_button_set_icon_from_file(void* button, const char* path);

void eb_qt6_action_set_icon_from_theme(void* action, const char* themeIconName);
void eb_qt6_action_set_icon_from_file(void* action, const char* path);

void eb_qt6_widget_set_window_icon_from_theme(void* widget, const char* themeIconName);
void eb_qt6_widget_set_window_icon_from_file(void* widget, const char* path);

}
