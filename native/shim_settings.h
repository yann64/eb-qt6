// eb-qt6 native shim - QSettings. Persistent key/value app settings -
// on Linux (this host), backed by an INI-format file under
// ~/.config/<organization>/<application>.conf (real Qt's own default
// NativeFormat resolves to INI on Unix, unlike Windows' registry).
//
// A plain QObject, like QTimer/QButtonGroup (see shim_buttongroup.h's
// own top comment) - accepts an optional real parent widget so Qt
// manages its lifetime; a null parent works too (QSettings is commonly
// held for the whole app's lifetime in real Qt code) but would then
// need manual cleanup to avoid a one-time leak.
#pragma once

extern "C" {

void* eb_qt6_settings_create(const char* organization, const char* application, void* parent);
void eb_qt6_settings_set_string(void* settings, const char* key, const char* value);
// Caller frees the result via eb_qt6_free_string. Returns
// `defaultValue` (still an owned copy) if `key` isn't set yet.
char* eb_qt6_settings_get_string(void* settings, const char* key, const char* defaultValue);
void eb_qt6_settings_set_int(void* settings, const char* key, int value);
int eb_qt6_settings_get_int(void* settings, const char* key, int defaultValue);
// Forces pending writes to disk now - real Qt already does this
// automatically (periodically, and always on destruction), so this is
// rarely needed, but useful right before an app might crash/be killed.
void eb_qt6_settings_sync(void* settings);

}
