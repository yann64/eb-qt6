' Spike A demo, promoted to the idiomatic layer: proves the whole
' Extern/static-archive/Qt-shared-lib link chain works and a real window
' appears, through the real public API (not raw Extern declares).
'
' Qt6 needs QT_QPA_PLATFORM=xcb explicitly set in this environment
' (a GNOME/Wayland session with XWayland providing X11 compatibility) -
' otherwise it silently auto-detects the "wayland" platform plugin,
' which constructs everything successfully but never shows a real,
' visible window at all. See this package's own README "Building"
' section - the same unconditional requirement GDK_BACKEND=x11 already
' is for every GTK4 app.

#include once "qt6.iface.bas"

DIM app AS Application
app = NewApplication("hello_window")

DIM win AS MainWindow
win = NewMainWindow()
CALL WidgetSetWindowTitle(win, "Hello, eb-qt6!")
CALL WidgetResize(win, 400, 300)
CALL WidgetShow(win)

CALL ApplicationExec(app)
