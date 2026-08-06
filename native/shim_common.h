// eb-qt6 native shim - shared callback typedefs and the string-return
// convention every widget shim uses.
//
// Callback typedefs are named by SIGNAL SHAPE, not by class - Qt6's
// modern functor-based `connect(sender, &Signal, lambda)` is resolved
// at compile time per signal (unlike GTK4's untyped, runtime-marshaled
// `g_signal_connect_data`, which lets eb-gtk4 use one generic
// `ObjConnect` for every signal in GTK4) - so eb-qt6 needs one shim
// connect-function per (class, signal) pair, but can still avoid
// typedef sprawl by sharing a typedef across every signal with the same
// shape (e.g. `clicked` and `returnPressed` both use
// EbQt6VoidCallback). Lambda lifetime is a non-issue: each lambda lives
// inside Qt's own QMetaObject::Connection, owned by the sender widget,
// and is automatically torn down when the widget is destroyed - nothing
// for eBasic to leak or manage. The only caller obligation (same
// convention eb-gtk4/eb-haiku already require) is that `userData` must
// outlive the widget itself.
#pragma once

class QString;

// Internal helper (real C++ linkage, not part of the extern "C" ABI) -
// every widget shim's own "get text"-style function calls this to
// produce the heap-allocated copy eb_qt6_free_string later releases.
char* eb_qt6_dup_qstring(const QString& s);

extern "C" {

typedef void (*EbQt6VoidCallback)(void* userData);
typedef void (*EbQt6StringCallback)(void* userData, const char* text);
typedef void (*EbQt6BoolCallback)(void* userData, int value);
typedef void (*EbQt6IntCallback)(void* userData, int value);
// Shared by any signal shaped (userData, int, int) - e.g.
// QTableWidget::cellClicked(row, column).
typedef void (*EbQt6TwoIntCallback)(void* userData, int a, int b);
// Shared by any signal shaped (userData, opaque handle) - e.g.
// QTreeWidget::currentItemChanged's `current` parameter (the `previous`
// parameter is dropped - callers needing it can track the last current
// item themselves).
typedef void (*EbQt6PtrCallback)(void* userData, void* ptr);

// QString has no stable-forever UTF-8 `const char*` the way a BString/
// GString does, so every "get text" function here returns a freshly
// heap-allocated copy the caller must free via this - matching
// eb-gtk4's own TextBufferGetText/FreeGMallocString convention (an
// owned allocation) rather than eb-haiku's borrowed-storage one.
void eb_qt6_free_string(char* s);

}
