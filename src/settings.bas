' Idiomatic layer: QSettings - persistent key/value app settings, on
' Linux (this host) backed by an INI-format file under
' ~/.config/<organization>/<application>.conf. A plain QObject, like
' QTimer/ButtonGroup - pass a real parent widget so Qt manages its
' lifetime; a null `DIM x AS QtWidget` handle works too but would then
' need manual cleanup to avoid a one-time leak.

#include once "widget.bas"
#include once "common.bas"
#include once "raw/qt6_settings.bas"

TYPE Settings EXTENDS QtObject
END TYPE

FUNCTION NewSettings(organization AS ZSTRING, application AS ZSTRING, BYVAL parent AS QtWidget) AS Settings
    DIM s AS Settings
    s.handle = eb_qt6_settings_create(organization, application, parent.handle)
    NewSettings = s
END FUNCTION

SUB SettingsSetString(BYVAL s AS Settings, key AS ZSTRING, value AS ZSTRING)
    CALL eb_qt6_settings_set_string(s.handle, key, value)
END SUB

''' See ButtonGetText's own doc comment on the owned-allocation/
''' FreeQtString convention. Returns `defaultValue` (still an owned
''' copy) if `key` isn't set yet.
FUNCTION SettingsGetString(BYVAL s AS Settings, key AS ZSTRING, defaultValue AS ZSTRING) AS ANY PTR
    SettingsGetString = eb_qt6_settings_get_string(s.handle, key, defaultValue)
END FUNCTION

SUB SettingsSetInt(BYVAL s AS Settings, key AS ZSTRING, value AS INTEGER)
    CALL eb_qt6_settings_set_int(s.handle, key, value)
END SUB

FUNCTION SettingsGetInt(BYVAL s AS Settings, key AS ZSTRING, defaultValue AS INTEGER) AS INTEGER
    SettingsGetInt = eb_qt6_settings_get_int(s.handle, key, defaultValue)
END FUNCTION

''' Forces pending writes to disk now - real Qt already does this
''' automatically (periodically, and always on destruction), so this is
''' rarely needed, but useful right before an app might crash/be
''' killed.
SUB SettingsSync(BYVAL s AS Settings)
    CALL eb_qt6_settings_sync(s.handle)
END SUB
