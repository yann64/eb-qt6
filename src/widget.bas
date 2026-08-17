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
#include once "raw/qt6_dragdrop.bas"

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

''' A disabled widget is grayed out and stops accepting input - real Qt
''' also disables (transitively) any child widgets, unless one of them
''' was explicitly re-enabled itself.
SUB WidgetSetEnabled(BYVAL w AS QtWidget, enabled AS INTEGER)
    CALL eb_qt6_widget_set_enabled(w.handle, enabled)
END SUB

FUNCTION WidgetIsEnabled(BYVAL w AS QtWidget) AS INTEGER
    WidgetIsEnabled = eb_qt6_widget_is_enabled(w.handle)
END FUNCTION

''' Distinct from WidgetShow - a widget hidden this way is actively
''' hidden even if a parent later shows itself again (matches real
''' QWidget::hide()/setVisible(false)).
SUB WidgetSetVisible(BYVAL w AS QtWidget, visible AS INTEGER)
    CALL eb_qt6_widget_set_visible(w.handle, visible)
END SUB

FUNCTION WidgetIsVisible(BYVAL w AS QtWidget) AS INTEGER
    WidgetIsVisible = eb_qt6_widget_is_visible(w.handle)
END FUNCTION

''' Sets the widget's font (family, point size, and bold/italic flags
''' in one call) - affects this widget and, unless overridden, its
''' children.
SUB WidgetSetFont(BYVAL w AS QtWidget, family AS ZSTRING, pointSize AS INTEGER, bold AS INTEGER, italic AS INTEGER)
    CALL eb_qt6_widget_set_font(w.handle, family, pointSize, bold, italic)
END SUB

''' Matches real Qt::CursorShape values - pass to WidgetSetCursor.
CONST QtArrowCursor = 0
CONST QtCrossCursor = 2
CONST QtWaitCursor = 3
CONST QtIBeamCursor = 4
CONST QtPointingHandCursor = 13
CONST QtForbiddenCursor = 14

''' Overrides the mouse cursor shown while hovering this widget - pass
''' one of the QtXxxCursor constants above.
SUB WidgetSetCursor(BYVAL w AS QtWidget, shape AS INTEGER)
    CALL eb_qt6_widget_set_cursor(w.handle, shape)
END SUB

''' Makes this widget draggable: pressing the mouse on it and dragging
''' past Qt's own real drag-start distance threshold starts a drag
''' carrying `dragText` as plain-text MIME data. Implemented via a
''' QObject event filter, not a widget subclass - works on any
''' QtWidget (Label, Button, LineEdit, ...), not just a dedicated drag
''' widget type. Only plain-text MIME data is supported - no
''' files/images.
SUB WidgetEnableDragSource(BYVAL w AS QtWidget, dragText AS ZSTRING)
    CALL eb_qt6_widget_enable_drag_source(w.handle, dragText)
END SUB

''' Makes this widget a drop target: connects `handler` (a top-level
''' `SUB YourName(userData AS ANY PTR, text AS ZSTRING)`) to fire when
''' plain text is dropped onto it - `text` is borrowed, valid only for
''' the duration of that one call, same convention as
''' LineEditConnectTextChanged's own `text` parameter. Only accepts
''' plain-text drops - drags carrying other MIME types are rejected
''' (the drop cursor shows "forbidden" over this widget for them).
SUB WidgetEnableDropTarget(BYVAL w AS QtWidget, handler AS ANY PTR, userData AS ANY PTR)
    CALL eb_qt6_widget_enable_drop_target(w.handle, handler, userData)
END SUB

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

''' Window position - meaningful for a top-level window; ignored for a
''' child widget managed by a layout (the layout itself controls
''' position there, real Qt semantics, not a limitation of this shim).
SUB WidgetMove(BYVAL w AS QtWidget, x AS INTEGER, y AS INTEGER)
    CALL eb_qt6_widget_move(w.handle, x, y)
END SUB

''' Position and size in one call - same layout-widget caveat as
''' WidgetMove.
SUB WidgetSetGeometry(BYVAL w AS QtWidget, x AS INTEGER, y AS INTEGER, width AS INTEGER, height AS INTEGER)
    CALL eb_qt6_widget_set_geometry(w.handle, x, y, width, height)
END SUB

FUNCTION WidgetX(BYVAL w AS QtWidget) AS INTEGER
    WidgetX = eb_qt6_widget_x(w.handle)
END FUNCTION

FUNCTION WidgetY(BYVAL w AS QtWidget) AS INTEGER
    WidgetY = eb_qt6_widget_y(w.handle)
END FUNCTION

FUNCTION WidgetWidth(BYVAL w AS QtWidget) AS INTEGER
    WidgetWidth = eb_qt6_widget_width(w.handle)
END FUNCTION

FUNCTION WidgetHeight(BYVAL w AS QtWidget) AS INTEGER
    WidgetHeight = eb_qt6_widget_height(w.handle)
END FUNCTION

''' Raises this widget above its sibling widgets in stacking order -
''' for a top-level window, brings it to the front.
SUB WidgetRaise(BYVAL w AS QtWidget)
    CALL eb_qt6_widget_raise(w.handle)
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

''' Pixel gap between consecutive widgets in the layout.
SUB BoxLayoutSetSpacing(BYVAL layout AS BoxLayout, spacing AS INTEGER)
    CALL eb_qt6_boxlayout_set_spacing(layout.handle, spacing)
END SUB

''' Pixel padding between the layout's own edge and its container
''' widget's edge, one value per side.
SUB BoxLayoutSetContentsMargins(BYVAL layout AS BoxLayout, left AS INTEGER, top AS INTEGER, right AS INTEGER, bottom AS INTEGER)
    CALL eb_qt6_boxlayout_set_contents_margins(layout.handle, left, top, right, bottom)
END SUB

''' Applies a constructed layout to a widget - the widget now owns the
''' layout (and, transitively, everything ever added to it). Accepts
''' any real QLayout-backed TYPE (BoxLayout, GridLayout, FormLayout) via
''' the shared QtObject base - the shim function itself already casts
''' to a generic QLayout* underneath.
SUB WidgetSetLayout(BYVAL w AS QtWidget, BYVAL layout AS QtObject)
    CALL eb_qt6_widget_set_layout(w.handle, layout.handle)
END SUB
