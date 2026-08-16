// eb-qt6 native shim - QWidget/QMainWindow and the two stock layouts
// (QVBoxLayout/QHBoxLayout).
//
// Ownership deliberately does NOT follow eb-gtk4's SinkHandle/ObjDestroy
// ref-counting convention - Qt has no equivalent (QObject/QWidget use
// single-owner parent-child tree deletion, not ref-counting). Once a
// widget is added to a layout (WidgetLayoutAddWidget) or set as a main
// window's central widget (MainWindowSetCentralWidget), Qt itself now
// owns and destroys it - do NOT call eb_qt6_widget_destroy on it
// afterwards (a double-free), the same "container now owns it, no
// destroy function needed" convention eb-haiku's own README documents
// for Haiku's menus/windows.
//
// Two deliberate deviations from both sibling packages, each with a
// real Qt-specific reason (see README "Known gaps" for the full
// rationale):
//   - A QMainWindow closing HIDES it, not deletes it (Qt::
//     WA_DeleteOnClose stays off) - matches eb-gtk4's own explicit-
//     lifetime philosophy rather than a footgun where an eBasic-held
//     handle dies the instant a user clicks the OS close button.
//   - eb_qt6_widget_destroy calls deleteLater(), never a raw `delete` -
//     a raw delete from inside the widget's own signal callback (a
//     common real pattern: "close this window when this button is
//     clicked") is a known Qt use-after-free hazard; deleteLater()
//     defers to the next event-loop iteration and costs nothing in the
//     common case.
#pragma once

extern "C" {

void* eb_qt6_widget_create();
void eb_qt6_widget_show(void* widget);
void eb_qt6_widget_resize(void* widget, int width, int height);
void eb_qt6_widget_set_window_title(void* widget, const char* title);
// CSS-like Qt style sheet syntax (see Qt's own "Qt Style Sheets"
// docs) - applies to this widget and, unless overridden, its children.
void eb_qt6_widget_set_style_sheet(void* widget, const char* styleSheet);
// Shown after the mouse hovers over the widget for a moment - real Qt
// handles the popup/timing itself, nothing for this shim to manage.
void eb_qt6_widget_set_tool_tip(void* widget, const char* toolTip);
void eb_qt6_widget_set_minimum_size(void* widget, int width, int height);
void eb_qt6_widget_set_maximum_size(void* widget, int width, int height);
// Widget input focus - see QWidget::setFocus/hasFocus. A widget must
// have a real focus policy for this to matter (most interactive
// widgets already default to one; a plain container QWidget from
// NewWidget() does not).
//
// CONFIRMED (via a minimal standalone spike, not assumed): eb_qt6_
// widget_set_focus is NOT synchronous with eb_qt6_widget_has_focus -
// real QWidget::setFocus() only posts a focus-change event; the actual
// focus state hasFocus() reports isn't updated until that event is
// processed by the Qt event loop. Calling has_focus immediately after
// set_focus in the same call stack (e.g. inside the very signal
// handler that called set_focus) will see the OLD focus state, not the
// new one - this is real Qt semantics, not a bug here. Check
// has_focus from a later callback instead (e.g. a different signal
// firing afterward, or a QTimer), never synchronously right after
// set_focus.
void eb_qt6_widget_set_focus(void* widget);
int eb_qt6_widget_has_focus(void* widget);
void eb_qt6_widget_set_enabled(void* widget, int enabled);
int eb_qt6_widget_is_enabled(void* widget);
// Distinct from eb_qt6_widget_show - a widget hidden this way is not
// merely un-shown, it's actively hidden even if a parent later shows
// itself again (matches real QWidget::hide()/setVisible(false)).
void eb_qt6_widget_set_visible(void* widget, int visible);
int eb_qt6_widget_is_visible(void* widget);
// Sets the widget's font (family, point size, and bold/italic flags in
// one call, matching QFont's own most-common constructor shape) -
// affects this widget and, unless overridden, its children.
void eb_qt6_widget_set_font(void* widget, const char* family, int pointSize, int bold, int italic);
// Only meaningful for a widget that hasn't been parented into a layout/
// central-widget slot yet - see this file's own top comment.
void eb_qt6_widget_destroy(void* widget);

void* eb_qt6_mainwindow_create();
void eb_qt6_mainwindow_set_central_widget(void* window, void* widget);

void* eb_qt6_vboxlayout_create();
void* eb_qt6_hboxlayout_create();
// Works for either layout type (both are QBoxLayout subclasses) -
// generic across the two, matching HControlSetEnabled's own "one
// function, several real subclasses" convention in eb-haiku.
void eb_qt6_boxlayout_add_widget(void* layout, void* widget);
// Applies a constructed layout to a widget - the widget now owns the
// layout (and, transitively, everything ever added to it).
void eb_qt6_widget_set_layout(void* widget, void* layout);

}
