// eb-qt6 native shim - QShortcut. Real QShortcut's own constructor
// requires a real parent widget (it's scoped to that widget's window by
// default, Qt::WindowShortcut context) - unlike QTimer/QSettings, a
// null parent isn't a supported case here at all, not just a lifetime
// convenience.
#pragma once

#include "shim_common.h"

extern "C" {

// `keySequence` is parsed the same way real Qt::QKeySequence(QString)
// does - e.g. "Ctrl+Q", "Alt+F4", "F5".
void* eb_qt6_shortcut_create(const char* keySequence, void* parent);
void eb_qt6_shortcut_connect_activated(void* shortcut, EbQt6VoidCallback cb, void* userData);

}
