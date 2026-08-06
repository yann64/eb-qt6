# eb-qt6

A Qt6 Widgets binding for [eBasic](https://github.com/yann64/ebasic),
managed with `ebpm`.

## Status

Early development (v0.1.0) - `QApplication`, `QWidget`/`QMainWindow`,
`QPushButton`, `QLabel`, `QLineEdit`, `QVBoxLayout`/`QHBoxLayout`, and a
custom-paint widget (`PainterWidget`) with basic `QPainter` drawing
primitives. Real Qt6 (6.10.2) is installed and fully working on the
development host this was built/verified against - every feature below
has been screenshot-verified live, not just compile-checked.

## Why a hand-written native shim, unlike `eb-gtk4`

Unlike GTK4 (a C library `eb-gtk4` binds directly, with a C-shaped
object/signal system), **Qt6 has no C-level API at all** - `QWidget`,
`QPushButton`, etc. are only reachable as real C++ classes with mangled
symbol names, and eBasic's `Extern` mechanism only ever binds free
functions (never a foreign class's constructor or methods - see the
main eBasic repo's own
[`docs/reference/extern-interop.md`](https://github.com/yann64/ebasic/blob/main/docs/reference/extern-interop.md)).
So this package's own `native/` directory is a small, hand-written
`extern "C"` shim - real C++ that constructs/calls/destroys the actual
Qt objects internally and exposes a flat, unmangled ABI eBasic can bind
to - the same architecture [`eb-haiku`](https://github.com/yann64/eb-haiku)
already uses for Haiku's own C++-only Kits, **not** `eb-gtk4`'s direct-FFI
approach.

**A real, favorable difference from `eb-gtk4`'s signal model**: GTK4's
signal system is C-based and untyped/runtime-marshaled
(`g_signal_connect_data`), so one generic `ObjConnect(obj, "signal-name",
@Callback, userdata)` wrapper covers every signal in GTK4. Qt6's modern
functor-based `connect(sender, &Signal, lambda)` is resolved at compile
time per signal, so there's no way to write one function covering every
Qt6 signal - this package needs one shim function per (class, signal)
pair instead (e.g. `ButtonConnectClicked`, `LineEditConnectTextChanged`),
closer in shape to `eb-haiku`'s own per-method callback setters. The
upside: **lambda lifetime is a non-issue** - each lambda lives inside
Qt's own `QMetaObject::Connection`, owned by the sender widget, and is
torn down automatically when the widget is destroyed. Nothing for eBasic
to leak or manage; the only caller obligation is that `userData` must
outlive the widget itself (same convention `eb-gtk4`/`eb-haiku` already
require).

## Ownership - deliberately NOT `eb-gtk4`'s `SinkHandle`/`ObjDestroy`

GObject's ref-counting model has no real Qt equivalent - `QWidget`/
`QObject` use single-owner parent-child tree deletion, not ref-counting.
Once a widget is added to a layout (`BoxLayoutAddWidget`) or set as a
window's central widget (`MainWindowSetCentralWidget`), **Qt itself now
owns and destroys it** - do not call `WidgetDestroy` on it afterwards (a
double-free), the same "container now owns it, no destroy function
needed" convention `eb-haiku`'s own README documents for Haiku's
menus/windows.

Two deliberate deviations from both sibling packages, each for a
Qt-specific reason:

- **A `MainWindow` closing HIDES it, does not delete it** (`Qt::
  WA_DeleteOnClose` stays off) - matches `eb-gtk4`'s own explicit-
  lifetime philosophy rather than a footgun where an eBasic-held handle
  dies the instant a user clicks the OS close button.
- **`WidgetDestroy` calls `deleteLater()`, never an immediate `delete`**
  - a raw `delete` from inside the widget's own signal callback (a
    common real pattern: "close this window when this button is
    clicked") is a known Qt use-after-free hazard; `deleteLater()`
    defers to the next event-loop iteration and costs nothing in the
    common case.

## Two `.bas` layers

Matching `eb-gtk4`/`eb-haiku`'s own convention:

- **Raw layer** (`src/raw/*.bas`) - flat `Extern "C" Lib "ebqt6shim"`
  declarations mirroring the shim's own C ABI 1:1. Internal use only.
- **Idiomatic layer** (`src/*.bas`) - the package's real public API:
  plain eBasic `TYPE`s (`QtObject` base, `QtWidget EXTENDS QtObject`,
  concrete widgets `EXTENDS QtWidget`) plus free functions operating on
  them (`NewButton`, `ButtonConnectClicked`, `WidgetShow`, ...) - a
  `TYPE`'s own methods aren't exported across an `ebpm --lib` package
  boundary yet, so the public API is `CALL ButtonSetText(myButton,
  "text")`, not `myButton.SetText("text")`.

**`ZSTRING`, not `STRING`, at the FFI boundary** - same restriction
`eb-gtk4`/`eb-haiku` already document: a `STRING`-returning top-level
function can't cross the `--lib` boundary. `QString` also has no
stable-forever UTF-8 `const char*` the way a `BString`/`GString` does,
so every "get text" function (`ButtonGetText`/`LabelGetText`/
`LineEditGetText`) returns a freshly heap-allocated copy the caller must
free via `FreeQtString` - matching `eb-gtk4`'s own `TextBufferGetText`/
`FreeGMallocString` convention (an owned allocation), not `eb-haiku`'s
borrowed-storage one:

```basic
DIM raw AS ANY PTR
raw = ButtonGetText(myButton)
DIM z AS ZSTRING
z = raw
DIM s AS STRING
s = z
CALL FreeQtString(raw)
```

A signal callback's own string parameter (e.g. `LineEditConnectTextChanged`'s
`text`) is different - **borrowed**, valid only for the duration of that
one call, freed by the shim itself right after the callback returns; no
`FreeQtString` needed or safe to call on it.

## Building

The native shim is standalone, not driven by `ebc`/`ebpm` (same as
`eb-haiku`):

```sh
$ cmake -S native -B native/build
$ cmake --build native/build
```

Produces `native/build/libebqt6shim.a`.

**Known gap - manual linker flags are always required, with no
exceptions.** `ebpm`'s `.libs` sidecar mechanism (already used by
`eb-haiku` to auto-forward `-l be`/`-l root` for its own *core* Kits)
works by scanning a package's raw layer for `Extern "C" Lib "name"`
clauses that name a *real, legitimate public C symbol* the archive
itself needed - Haiku's `find_directory`/`fs_create_index` give
`eb-haiku` exactly that anchor. **Qt6 has no such anchor anywhere in
`Qt6Core`/`Qt6Gui`/`Qt6Widgets`** - confirmed via `nm -D --defined-only`
on the real installed `libQt6Core.so`: the only non-mangled C symbols it
exports sit under an explicit `Qt_6_PRIVATE_API` version node (internal
ABI, not something to bind against). **Every downstream consumer,
including the bare "hello window," must pass these manually:**

```sh
$ ebc yourprogram.bas -o yourprogram \
    -L path/to/eb-qt6/native/build -l ebqt6shim \
    -l Qt6Widgets -l Qt6Gui -l Qt6Core
```

(that `-l` order matches real `pkg-config --libs Qt6Widgets` output).

**Known gap - `QT_QPA_PLATFORM=xcb` is required in this development
environment.** This host runs a GNOME/Wayland session with XWayland
providing X11 compatibility. Without `QT_QPA_PLATFORM=xcb` explicitly
set, Qt6 silently auto-detects the "wayland" platform plugin, which
constructs `QApplication`/every widget successfully (no error, no
crash, valid handles) but **never actually creates a real, visible
window at all** - it doesn't even register as a real X11 client. This
is the exact same class of requirement `GDK_BACKEND=x11` already is for
every `eb-gtk4` app - just a different env var for a different
toolkit's platform-plugin system:

```sh
$ QT_QPA_PLATFORM=xcb ./yourprogram
```

## Signals

```basic
#include once "qt6.iface.bas"

DIM gLabel AS Label

SUB OnClicked(userData AS ANY PTR)
    CALL LabelSetText(gLabel, "clicked!")
END SUB

DIM app AS Application
app = NewApplication("demo")

DIM win AS MainWindow
win = NewMainWindow()

DIM central AS QtWidget
central = NewWidget()
DIM layout AS BoxLayout
layout = NewVBoxLayout()

DIM btn AS Button
btn = NewButton("Click Me")
CALL ButtonConnectClicked(btn, @OnClicked, 0)
CALL BoxLayoutAddWidget(layout, btn)

gLabel = NewLabel("not clicked yet")
CALL BoxLayoutAddWidget(layout, gLabel)

CALL WidgetSetLayout(central, layout)
CALL MainWindowSetCentralWidget(win, central)
CALL WidgetShow(win)
CALL ApplicationExec(app)
```

`@OnClicked` (eBasic's own `AddressOf` operator) produces a real C
function pointer - see the main eBasic repo's own `extern-interop.md`
for the full rules (only a plain, bodied, top-level `SUB`/`FUNCTION` is
addressable this way, and every parameter must be C-ABI-compatible).

## Custom drawing

`PainterWidget` is the one widget in this package needing a real C++
subclass (`ShimWidget`, and therefore `moc`/`Q_OBJECT`) - every other
widget forwards its signals via a plain lambda+`connect`, needing no
subclass at all. A subclass is unavoidable here specifically because
`QWidget::paintEvent` is a real C++ virtual method Qt calls directly,
not a signal - the same reason `eb-haiku` needed a `ShimView` subclass
for `BView::Draw`.

```basic
SUB OnPaint(userData AS ANY PTR, painter AS ANY PTR)
    CALL PainterFillRect(painter, 0, 0, 400, 300, 200, 255, 200)
    CALL PainterSetPenColor(painter, 255, 0, 0)
    CALL PainterDrawRect(painter, 20, 20, 150, 100)
    CALL PainterDrawText(painter, 30, 200, "hello")
END SUB

DIM w AS PainterWidget
w = NewPainterWidget()
CALL PainterWidgetConnectPaint(w, @OnPaint, 0)
CALL WidgetShow(w)
```

**The `painter` handle is only valid for the duration of that one paint
callback** - it's a C++ stack-local Qt constructs fresh per `paintEvent`
call, per its own RAII `begin()`/`end()` bracketing requirement.
Confirmed by direct reproduction (not assumed): calling a drawing
primitive after the callback has returned does not crash - `QPainter`'s
own internal `isActive()` check makes it a silent no-op with a
`"QPainter::fillRect: Painter not active"`-style warning on stderr - but
nothing gets drawn, so treat it as a real bug if it happens, just a
safer failure mode than a crash.

## Verifying

There is no automated test suite yet (GUI widgets have no real headless
story here the way `GtkTextBuffer`/`BMessage` do in the sibling
packages - `examples/*.bas` are manual, run-and-screenshot
verification, matching `eb-gtk4`'s own `tests/manual/` convention).
Each example under `examples/` has been compiled, run, and
screenshot-verified live on this host:

- `hello_window.bas` - a plain window appears (proves the whole
  `Extern`/static-archive/Qt-shared-lib link chain).
- `button_click.bas` - a button + label composed via `QVBoxLayout`;
  clicking the button (verified via real keyboard activation - `Tab` to
  focus, `Space` to activate; synthetic X11 *mouse* clicks are
  unreliable in this sandboxed environment, the same limitation
  `ebasic-editor`'s own README documents for GTK4) updates the label.
- `line_edit.bas` - `textChanged` (fires per keystroke, exercises the
  `QString`->`const char*` marshaling) and `returnPressed` both update a
  status label.
- `custom_drawing.bas` - a filled background, a rectangle outline, a
  line, and drawn text via `PainterWidget`.
