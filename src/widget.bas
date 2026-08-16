' Idiomatic layer: QWidget/QMainWindow and the two stock box layouts.
'
' Ownership deliberately does NOT follow eb-gtk4's SinkHandle/ObjDestroy
' ref-counting convention - Qt has no equivalent (QObject/QWidget use
' single-owner parent-child tree deletion). Once a widget is added to a
' layout (BoxLayoutAddWidget) or set as a main window's central widget
' (MainWindowSetCentralWidget), Qt itself now owns and destroys it - do
' NOT call WidgetDestroy on it afterwards (a double-free), the same
' "container now owns it, no destroy function needed" convention
' eb-haiku's own README documents for Haiku's menus/windows.
'
' Two deliberate deviations from both sibling packages (see this
' package's own README "Known gaps" for the full rationale):
'   - A MainWindow closing HIDES it, not deletes it - matches eb-gtk4's
'     own explicit-lifetime philosophy rather than a footgun where an
'     eBasic-held handle dies the instant a user clicks the OS close
'     button.
'   - WidgetDestroy defers via Qt's own deleteLater(), never an
'     immediate delete - safe to call even from inside the widget's own
'     signal callback (a common real pattern: "close this window when
'     this button is clicked").

#include once "application.bas"
#include once "raw/qt6_widget.bas"
#include once "raw/qt6_icon.bas"

TYPE QtWidget EXTENDS QtObject
END TYPE

''' Creates a new, empty QWidget - a plain top-level window if never
''' added to a layout/central-widget slot.
FUNCTION NewWidget() AS QtWidget
    DIM w AS QtWidget
    w.handle = eb_qt6_widget_create()
    NewWidget = w
END FUNCTION

SUB WidgetShow(BYVAL w AS QtWidget)
    CALL eb_qt6_widget_show(w.handle)
END SUB

SUB WidgetResize(BYVAL w AS QtWidget, width AS INTEGER, height AS INTEGER)
    CALL eb_qt6_widget_resize(w.handle, width, height)
END SUB

SUB WidgetSetWindowTitle(BYVAL w AS QtWidget, title AS ZSTRING)
    CALL eb_qt6_widget_set_window_title(w.handle, title)
END SUB

''' CSS-like Qt style sheet syntax (see Qt's own "Qt Style Sheets"
''' docs, e.g. "background-color: red; font-weight: bold;") - applies
''' to this widget and, unless overridden, its children. Works on any
''' QtWidget (a plain QWidget), not just top-level windows.
SUB WidgetSetStyleSheet(BYVAL w AS QtWidget, styleSheet AS ZSTRING)
    CALL eb_qt6_widget_set_style_sheet(w.handle, styleSheet)
END SUB

''' Shown after the mouse hovers over the widget for a moment - real Qt
''' handles the popup/timing itself.
SUB WidgetSetToolTip(BYVAL w AS QtWidget, toolTip AS ZSTRING)
    CALL eb_qt6_widget_set_tool_tip(w.handle, toolTip)
END SUB

SUB WidgetSetMinimumSize(BYVAL w AS QtWidget, width AS INTEGER, height AS INTEGER)
    CALL eb_qt6_widget_set_minimum_size(w.handle, width, height)
END SUB

SUB WidgetSetMaximumSize(BYVAL w AS QtWidget, width AS INTEGER, height AS INTEGER)
    CALL eb_qt6_widget_set_maximum_size(w.handle, width, height)
END SUB

''' Real Qt requires the widget to have a focus policy for this to
''' matter - most interactive widgets already default to one; a plain
''' container QWidget from NewWidget() does not.
'''
''' CONFIRMED (via a minimal standalone spike, not assumed): NOT
''' synchronous with WidgetHasFocus - real QWidget::setFocus() only
''' posts a focus-change event, applied once the Qt event loop
''' processes it. Calling WidgetHasFocus immediately afterward in the
''' same call stack (e.g. inside the very handler that called this)
''' will see the OLD focus state - real Qt semantics, not a binding
''' bug. Check WidgetHasFocus from a later callback instead.
SUB WidgetSetFocus(BYVAL w AS QtWidget)
    CALL eb_qt6_widget_set_focus(w.handle)
END SUB

FUNCTION WidgetHasFocus(BYVAL w AS QtWidget) AS INTEGER
    WidgetHasFocus = eb_qt6_widget_has_focus(w.handle)
END FUNCTION

''' Loads a named icon from the current desktop icon theme (e.g.
''' "accessories-text-editor") as this window's title-bar/taskbar icon.
SUB WidgetSetWindowIconFromTheme(BYVAL w AS QtWidget, themeIconName AS ZSTRING)
    CALL eb_qt6_widget_set_window_icon_from_theme(w.handle, themeIconName)
END SUB

SUB WidgetSetWindowIconFromFile(BYVAL w AS QtWidget, path AS ZSTRING)
    CALL eb_qt6_widget_set_window_icon_from_file(w.handle, path)
END SUB

''' Only meaningful for a widget that hasn't been parented into a
''' layout/central-widget slot yet - see this file's own top comment.
SUB WidgetDestroy(BYVAL w AS QtWidget)
    CALL eb_qt6_widget_destroy(w.handle)
END SUB

''' See WidgetShow's own doc comment on ownership - a widget already
''' parented elsewhere should be wrapped via this, not re-constructed.
FUNCTION WrapWidget(h AS ANY PTR) AS QtWidget
    DIM w AS QtWidget
    w.handle = h
    WrapWidget = w
END FUNCTION

TYPE MainWindow EXTENDS QtWidget
END TYPE

''' Creates a new QMainWindow - closing it (the OS window-close button)
''' hides it, does not delete it - see this file's own top comment.
FUNCTION NewMainWindow() AS MainWindow
    DIM w AS MainWindow
    w.handle = eb_qt6_mainwindow_create()
    NewMainWindow = w
END FUNCTION

''' Sets the window's single central widget - the window now owns it
''' (see this file's own top comment on ownership).
SUB MainWindowSetCentralWidget(BYVAL win AS MainWindow, BYVAL widget AS QtWidget)
    CALL eb_qt6_mainwindow_set_central_widget(win.handle, widget.handle)
END SUB

TYPE BoxLayout EXTENDS QtObject
END TYPE

FUNCTION NewVBoxLayout() AS BoxLayout
    DIM l AS BoxLayout
    l.handle = eb_qt6_vboxlayout_create()
    NewVBoxLayout = l
END FUNCTION

FUNCTION NewHBoxLayout() AS BoxLayout
    DIM l AS BoxLayout
    l.handle = eb_qt6_hboxlayout_create()
    NewHBoxLayout = l
END FUNCTION

''' Appends a widget to the end of the layout - works for either
''' NewVBoxLayout/NewHBoxLayout (both real QBoxLayout subclasses).
SUB BoxLayoutAddWidget(BYVAL layout AS BoxLayout, BYVAL widget AS QtWidget)
    CALL eb_qt6_boxlayout_add_widget(layout.handle, widget.handle)
END SUB

''' Applies a constructed layout to a widget - the widget now owns the
''' layout (and, transitively, everything ever added to it). Accepts
''' any real QLayout-backed TYPE (BoxLayout, GridLayout, FormLayout) via
''' the shared QtObject base - the shim function itself already casts
''' to a generic QLayout* underneath.
SUB WidgetSetLayout(BYVAL w AS QtWidget, BYVAL layout AS QtObject)
    CALL eb_qt6_widget_set_layout(w.handle, layout.handle)
END SUB
