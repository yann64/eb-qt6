' Idiomatic layer: QApplication.

#include once "raw/qt6_application.bas"

''' The base type every idiomatic eb-qt6 value extends - a single opaque
''' handle, matching eb-gtk4's own Obj/Widget convention. Ownership does
''' NOT follow eb-gtk4's SinkHandle/ObjDestroy ref-counting though - see
''' widget.bas's own top comment for why (Qt uses parent-child tree
''' deletion, not ref-counting).
TYPE QtObject
    handle AS ANY PTR
END TYPE

TYPE Application EXTENDS QtObject
END TYPE

''' Creates (or returns the existing) QApplication - Qt itself aborts on
''' a second construction, so this is safe to call more than once.
''' `appName` may be "" (unnamed).
FUNCTION NewApplication(appName AS ZSTRING) AS Application
    DIM a AS Application
    a.handle = eb_qt6_application_create(appName)
    NewApplication = a
END FUNCTION

''' Blocks running Qt's own event loop until ApplicationQuit is called
''' (or the last top-level window closes, Qt's own default behavior) -
''' the calling code does nothing else after this returns; all real
''' logic lives in signal callbacks (see button.bas/lineedit.bas).
FUNCTION ApplicationExec(app AS Application) AS INTEGER
    ApplicationExec = eb_qt6_application_exec(app.handle)
END FUNCTION

SUB ApplicationQuit(app AS Application)
    CALL eb_qt6_application_quit(app.handle)
END SUB

''' The primary screen's available geometry (excludes taskbars/docks)
''' in pixels - useful for centering a window, e.g. `CALL
''' WidgetMove(win, (PrimaryScreenWidth() - 640) \ 2, (PrimaryScreenHeight()
''' - 480) \ 2)`.
FUNCTION PrimaryScreenWidth() AS INTEGER
    PrimaryScreenWidth = eb_qt6_primary_screen_width()
END FUNCTION

FUNCTION PrimaryScreenHeight() AS INTEGER
    PrimaryScreenHeight = eb_qt6_primary_screen_height()
END FUNCTION
