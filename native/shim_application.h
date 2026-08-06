// eb-qt6 native shim - QApplication lifecycle.
//
// Qt6 (like Haiku's Kits) has no C-level API at all - QApplication,
// QWidget, etc. are only reachable as real C++ classes, and eBasic's own
// `Extern`/`Declare` mechanism can only ever bind free functions, never a
// foreign class's constructor/methods/virtual overrides (see the main
// eBasic repo's own docs/reference/extern-interop.md). So this shim is
// real, hand-written C++: each function constructs/calls/destroys one
// real Qt object behind an opaque `void*`, exposed here as a flat,
// unmangled `extern "C"` ABI - the same approach eb-haiku already uses
// for Haiku's own C++-only Kits.
//
// QApplication needs process-lifetime argc/argv storage it keeps a
// reference to for as long as it exists - eb_qt6_application_create owns
// this internally (a fixed, synthesized argv; eBasic programs have no
// natural C-style argv to forward). Only one QApplication may exist per
// process - Qt's own constructor aborts on a second one - so this file
// guards against that itself rather than letting eBasic code discover
// the abort the hard way.
#pragma once

extern "C" {

// Returns the existing QApplication if one was already created (Qt
// itself aborts on a second construction) - safe to call more than
// once. `appName` may be "" (unnamed).
void* eb_qt6_application_create(const char* appName);

// Blocks running Qt's own event loop until eb_qt6_application_quit is
// called (or the last top-level window closes, Qt's own default
// behavior) - the eBasic-calling thread does nothing else after this
// returns control via callbacks, matching eb-gtk4/eb-haiku's own
// established "all real logic lives in callbacks" pattern for a
// blocking event-loop entry point.
int eb_qt6_application_exec(void* app);

void eb_qt6_application_quit(void* app);

}
