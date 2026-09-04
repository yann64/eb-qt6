' Headless(-ish) verification of WidgetSetModal/WidgetGetModal/
' WidgetSetParentWindow and MainWindowSetCloseCallback - the two
' prerequisite additions for the universal eb-gui Application/Window API
' (a new cross-toolkit layer sitting on top of this package). Every
' check is a direct function call + printed result, not a synthetic
' mouse/keyboard event - matches the standalone-C++-spike verification
' already done for these same primitives before this example was
' written (see the spike's own results: modal/parent-window round-trip
' correct, veto/allow/no-callback close-callback behavior all correct).
'
' Qt6 needs QT_QPA_PLATFORM=xcb explicitly set in this environment - see
' hello_window.bas's own top comment / this package's README.

#include once "qt6.iface.bas"

FUNCTION OnVetoClose(userData AS ANY PTR) AS INTEGER
    PRINT "close callback fired (veto)"
    OnVetoClose = 0
END FUNCTION

FUNCTION OnAllowClose(userData AS ANY PTR) AS INTEGER
    PRINT "close callback fired (allow)"
    OnAllowClose = 1
END FUNCTION

DIM app AS Application
app = NewApplication("window_lifecycle_verify")

' 1. WidgetSetModal/WidgetGetModal/WidgetSetParentWindow round trip.
DIM parentWin AS MainWindow
parentWin = NewMainWindow()
DIM childWin AS QtWidget
childWin = NewWidget()
PRINT "modal by default: ", WidgetGetModal(childWin)
CALL WidgetSetParentWindow(childWin, parentWin)
CALL WidgetSetModal(childWin, QtWindowModal)
PRINT "modal after SetModal(QtWindowModal): ", WidgetGetModal(childWin)
CALL WidgetSetModal(childWin, QtNonModal)
PRINT "modal after SetModal(QtNonModal): ", WidgetGetModal(childWin)

' 2. MainWindowSetCloseCallback: veto keeps the window visible, allow
' lets it proceed to its usual hide-not-delete behavior.
DIM vetoWin AS MainWindow
vetoWin = NewMainWindow()
CALL MainWindowSetCloseCallback(vetoWin, @OnVetoClose, 0)
CALL WidgetShow(vetoWin)
CALL WidgetClose(vetoWin)
PRINT "still visible after a vetoed close: ", WidgetIsVisible(vetoWin)

DIM allowWin AS MainWindow
allowWin = NewMainWindow()
CALL MainWindowSetCloseCallback(allowWin, @OnAllowClose, 0)
CALL WidgetShow(allowWin)
CALL WidgetClose(allowWin)
PRINT "still visible after an allowed close: ", WidgetIsVisible(allowWin)

' 3. No callback at all - must default to the pre-existing behavior
' (hide, not delete) with no regression.
DIM plainWin AS MainWindow
plainWin = NewMainWindow()
CALL WidgetShow(plainWin)
CALL WidgetClose(plainWin)
PRINT "still visible after close with no callback: ", WidgetIsVisible(plainWin)
