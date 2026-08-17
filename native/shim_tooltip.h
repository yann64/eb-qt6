// eb-qt6 native shim - QToolTip, shown programmatically rather than
// attached to a widget's own hover behavior (WidgetSetToolTip,
// shim_widget.h, already covers the passive "hover this widget" case).
// Useful for showing a tooltip-style hint in response to something
// other than mouse hover (e.g. after a validation error, or a
// keyboard-driven action).
#pragma once

extern "C" {

// `x`/`y` are global (whole-screen) pixel coordinates, not relative to
// any widget - real QToolTip::showText's own coordinate system.
void eb_qt6_tooltip_show_text(int x, int y, const char* text);
void eb_qt6_tooltip_hide();

}
