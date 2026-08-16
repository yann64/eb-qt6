' Idiomatic layer: QClipboard - a process-wide singleton, accessed via
' the running Application, matching MainWindowMenuBar/
' MainWindowStatusBar's own "always managed for you" convention (no
' separate New/create function).

#include once "application.bas"
#include once "common.bas"
#include once "raw/qt6_clipboard.bas"

TYPE Clipboard EXTENDS QtObject
END TYPE

FUNCTION ApplicationClipboard(BYVAL app AS Application) AS Clipboard
    DIM c AS Clipboard
    c.handle = eb_qt6_application_clipboard(app.handle)
    ApplicationClipboard = c
END FUNCTION

SUB ClipboardSetText(BYVAL c AS Clipboard, text AS ZSTRING)
    CALL eb_qt6_clipboard_set_text(c.handle, text)
END SUB

''' See ButtonGetText's own doc comment on the owned-allocation/
''' FreeQtString convention.
FUNCTION ClipboardGetText(BYVAL c AS Clipboard) AS ANY PTR
    ClipboardGetText = eb_qt6_clipboard_get_text(c.handle)
END FUNCTION
