# eb-qt6

A Qt6 Widgets binding for [eBasic](https://github.com/yann64/ebasic),
managed with `ebpm`.

## Status

Early development. Real Qt6 (6.10.2) is installed and fully working on
the development host this was built/verified against.

- **v0.1.0** - `QApplication`, `QWidget`/`QMainWindow`, `QPushButton`,
  `QLabel`, `QLineEdit`, `QVBoxLayout`/`QHBoxLayout`, and a custom-paint
  widget (`PainterWidget`) with basic `QPainter` drawing primitives.
- **v0.2.0** - `QCheckBox`/`QRadioButton` (share one `AbstractButton`
  function family), `QComboBox`, `QTextEdit` (plain-text only), and
  `QMenuBar`/`QMenu`/`QAction`.
- **v0.3.0** - `QTabWidget`, `QListWidget`/`QTableWidget` (simple
  item-based APIs, not the full model/view framework), `QDialog` plus
  `QMessageBox`/`QFileDialog`, and `QSlider`/`QSpinBox`/`QGroupBox`.
- **v0.4.0** - `QProgressBar`, `QStatusBar`, `QTreeWidget` (simple
  item-based API), `QScrollArea`, `QSplitter`, and `QToolBar` (toolbar
  buttons reuse the same `QAction` type `QMenu` already uses).
- **v0.5.0** - `QStackedWidget`, `QColorDialog`/`QFontDialog` (more
  static convenience dialogs, alongside `QMessageBox`/`QFileDialog`),
  `QDial`/`QLCDNumber`, and `QDockWidget`. No new honest exceptions this
  round - every signal and dialog round trip was confirmed live.
- **v0.6.0** - `QGridLayout`/`QFormLayout`, `QButtonGroup`
  (cross-container radio exclusivity, unbound since v0.2.0),
  `QSystemTrayIcon` (reuses the existing `Menu`/`Action` types for its
  context menu), and `QDateEdit`/`QTimeEdit`/`QCalendarWidget` (dates/
  times marshaled as separate int components, no `QDate`/`QTime`
  wrapper `TYPE`).

Every widget's real signal-forwarding has been screenshot-verified live
via keyboard interaction (`Tab`/`Space`/typing - see "Verifying" below
for why, not mouse clicks), not just compile-checked - **with four
honest exceptions**, all the same broad class of environment-specific
synthetic-input-delivery/tooling limitation already found repeatedly
elsewhere in this ecosystem (see `ebasic-editor`'s own README), not
evidence of a binding defect:

- `QAction`/`QMenu` construct and render correctly (the menu bar shows
  real text), but interactive keyboard-driven menu *opening*
  (`Alt`+mnemonic, `F10`) could not be confirmed live in this sandboxed
  session - `QAction::triggered`'s own forwarding uses the identical,
  already-proven lambda+`connect` mechanism as every other working
  signal here.
- `QTableWidget::cellClicked` specifically requires a real mouse click
  (unlike most signals here, which fire from keyboard-driven activation
  too) - not confirmed live for the same reason synthetic X11 mouse
  clicks are unreliable throughout this sandbox. The table's own
  rendering and cell contents were confirmed live.
- `QToolBar` actions aren't part of the normal `Tab` focus chain (real
  Qt behavior - toolbar buttons are chrome, not main-content widgets),
  and a real mouse click at verified-correct coordinates didn't
  register either (same limitation as above) - **the binding itself was
  proven correct anyway**, isolated from the input-delivery question, by
  a small standalone C++ spike that calls the shim directly and invokes
  `QAction::trigger()` programmatically (bypassing all synthetic input):
  the connected callback fired exactly as expected. Not evidence of a
  binding defect, purely an input-delivery gap in this sandbox.
- `QSystemTrayIcon` construction/`show()`/context-menu wiring don't
  crash, `QSystemTrayIcon::isSystemTrayAvailable()` returns true, and
  the desktop's tray-icon extension is confirmed active - but visually
  confirming the icon actually rendered in the desktop's panel couldn't
  be done in this sandbox: screenshotting a specific application window
  works fine, but capturing the *whole screen* (needed to see the
  desktop panel, which isn't a window `QSystemTrayIcon` itself owns)
  failed for tooling reasons in this session, a narrower variant of the
  general screenshot-tool flake noted below. Not evidence of a binding
  defect - every API call involved completed without error.
- **v0.7.0** - `QTimer` (named `QTimer`, not `Timer` - see this
  version's own section below for why), `QClipboard`, `QInputDialog`
  (`getText`/`getInt`/`getItem`, alongside the existing `QMessageBox`/
  `QColorDialog`/`QFontDialog`), and `WidgetSetStyleSheet` (CSS-like
  styling for any existing widget - not a new widget type). No new
  honest exceptions this round - every signal and dialog round trip was
  confirmed live, though verifying it took noticeably more careful,
  step-by-step keyboard navigation than earlier phases (see "Verifying"
  below).
- **v0.8.0** - `QSettings` (persistent INI-backed app settings),
  `QShortcut` (independent of the menu system - useful precisely where
  menu *opening* couldn't be verified, see above), `QIntValidator`/
  `QDoubleValidator` (attached directly to an existing `QLineEdit`, no
  new widget type), and `QCompleter`. No new honest exceptions - every
  feature was confirmed live, including catching (and fixing) a real
  crash in the example itself before publishing (see "Verifying"
  below).
- **v0.9.0** - icons on buttons/actions/window titles (theme or file,
  no separate `QIcon` handle), `QActionGroup` (the `QAction` equivalent
  of `QButtonGroup`), `WidgetSetToolTip`, and `QFrame`. **One honest
  exception**: tooltips didn't visibly appear under synthetic mouse
  hover in this sandbox (a new variant of the already-documented
  mouse-interaction limitation - tooltip display depends on genuine
  hover *dwell* time, which synthetic `xdotool mousemove` doesn't
  reliably produce here); `QActionGroup`'s mutual-exclusivity behavior
  was instead proven correct via the same standalone-C++-spike
  technique used for `QToolBar` in v0.4.0.
- **v0.10.0** - images (`LabelSetPixmapFromFile`, `PainterDrawPixmap`,
  no separate `QPixmap` handle), rich text (`QTextEdit`
  `SetHtml`/`GetHtml`, alongside the existing plain-text
  `SetText`/`GetText`), widget size constraints
  (`WidgetSetMinimumSize`/`SetMaximumSize`), and focus control
  (`WidgetSetFocus`/`HasFocus`). **One honest, well-substantiated
  exception**: `WidgetHasFocus` never returned true after
  `WidgetSetFocus` in this sandbox, even checked from a deferred
  `QTimer` callback (the technically correct pattern, confirmed via a
  standalone spike that `setFocus()`/`hasFocus()` aren't synchronous in
  real Qt) - root-caused, not just observed: `xdotool getactivewindow`
  reports no active window at all in this session, even immediately
  after `xdotool windowactivate`, so the window manager never gives
  this sandbox's windows real WM-level activation - and
  `QWidget::hasFocus()` is gated on the widget's window being Qt's own
  notion of the "active window," which itself normally syncs from that
  same WM-level activation. Individual keystrokes still reach specific
  widgets directly (matching every other keyboard-driven signal
  confirmed throughout this README), so this is narrower than "input
  doesn't work" - it's specifically that this sandbox's window manager
  never completes the activation handshake Qt's focus-tracking depends
  on.
- **v0.11.0** - `WidgetSetEnabled`/`IsEnabled`, `WidgetSetVisible`/
  `IsVisible`, `WidgetSetFont`, and a standalone `QScrollBar` (a real
  gap found while surveying the existing surface - enable/disable and
  font control hadn't been bound at all through ten prior phases).
  **One honest exception**: `QScrollBar`'s value couldn't be changed
  via keyboard in this sandbox (real Qt gives `QScrollBar` a different
  default focus policy than `QSlider` - it's often not a `Tab` stop at
  all in the native style) - the binding itself was instead proven
  correct via the same standalone-C++-spike technique used for
  `QToolBar`/`QActionGroup`: calling `QScrollBar::setValue()` directly
  fired the connected `valueChanged` callback and updated the read-back
  value exactly as expected.
- **v0.12.0** - `BoxLayout` spacing/margins (`SetSpacing`/
  `SetContentsMargins`), `Label` alignment/word-wrap
  (`SetAlignment`/`SetWordWrap`), widget cursor control
  (`WidgetSetCursor`), and themed icons on `ComboBox`/`ListWidget`
  items (another real gap found by surveying the existing surface -
  icons had reached buttons/actions/windows/tray in v0.9.0 but not
  item-based widgets). **One honest exception**: a custom
  `WidgetSetCursor` shape couldn't be visually confirmed in this
  sandbox - not an input-delivery limitation this time, but a
  screenshot-tooling one: `import` doesn't capture the X11 mouse
  cursor overlay at all (it's composited by the X server, not part of
  a window's own pixel buffer) - proven correct anyway via the
  now-standard standalone-C++-spike technique: calling
  `QWidget::setCursor()` directly and reading `cursor().shape()`
  afterward showed the shape change take effect exactly as requested.
- **v0.13.0** - drag-and-drop: `WidgetEnableDragSource`/
  `WidgetEnableDropTarget`, implemented via `QObject` event filters
  (see "Why event filters, not a widget subclass" below) rather than a
  dedicated `Shim*` subclass, so it works on any existing widget
  (`Label`, `Button`, `LineEdit`, ...) without a new widget type. Only
  plain-text MIME data is supported - no files/images. **A genuinely
  new class of honest exception, more fundamental than every prior
  one**: this feature could not be confirmed via *any* method attempted
  - not live mouse interaction (the sandbox's already-documented
  mouse-drag limitation), and, for the first time in this package's
  history, not the standalone-C++-spike technique either. Investigated
  thoroughly, not just assumed: a manually-constructed `QDropEvent` sent
  via `QCoreApplication::sendEvent()` never reached the handler - traced
  this to a real, general Qt behavior (not a bug in this binding) by
  testing the *identical* synthetic event against a real `QWidget`
  subclass with `dropEvent()` overridden the textbook way: it didn't
  receive the event either. Real interactive drag-and-drop evidently
  requires internal drag-session state (tied to a real `QDrag::exec()`
  call) that a bare, synthetic `QDropEvent` cannot satisfy, for *either*
  event filters or virtual overrides - this rules out a flaw specific to
  the event-filter architecture chosen here, but leaves the feature's
  actual runtime correctness unconfirmed in this sandbox. Shipped
  anyway because the implementation follows Qt's own documented,
  standard pattern for filter-based drag-and-drop, with this honestly
  weaker confidence level stated plainly rather than glossed over.
- **v0.14.0** - `QSplashScreen`, `QWizard`/`QWizardPage` (plain pages
  composed via `WidgetSetLayout`, no subclassing needed - the wizard
  itself drives Next/Back/Finish/Cancel navigation), PDF printing via
  `QPrinter` (PDF-file output only - see "Phase 14 features" below for
  why), and multi-column `QTreeWidget` support
  (`TreeWidgetSetColumnCount`/`SetHeaderLabels`, `TreeItemSetText`/
  `TextAt`). **A new environment fact, not a binding defect**:
  `QPrinter`'s constructor aborts the process if called before a
  `QCoreApplication` exists - same requirement `QApplication` itself
  has, just discovered on a second class this time (confirmed by direct
  reproduction, fixed by reordering the example). **Keyboard-driven
  live verification was flakier than every prior phase** in this
  session specifically for the modal `QWizard` dialog - `xdotool
  windowactivate` intermittently failed (`XGetWindowProperty
  [_NET_WM_DESKTOP] failed`) against the wizard's own top-level window,
  most likely because a `QWizard` dialog, like other transient Qt
  dialogs, doesn't get `_NET_WM_DESKTOP` set the way a plain
  `QMainWindow` does - a narrower variant of the already-documented
  `WidgetHasFocus` WM-activation gap (see v0.10.0 above), not new in
  kind. What *did* work live: the wizard opens via a real keyboard
  click on its launch button, page 1 renders with the correct
  Back-disabled/Next-enabled state, and `WidgetSetFocus` correctly
  focused the page's `LineEdit` even nested inside a wizard page's own
  layout. Page navigation (`next()`) and the `accepted` signal firing
  on Finish were instead confirmed via the standard standalone-C++-spike
  technique - calling `QWizard::next()`/`accept()` directly on the real
  object and observing the connected callback fire exactly as expected.
  Splash-screen show/finish and the multi-column tree were both
  confirmed fully live (screenshot), and PDF output was confirmed by
  writing a real file and checking it's non-empty - no interaction
  needed for either.
- **v0.15.0** - `QProcess` (run an external command, wait for it, read
  its output/exit code - **needs no GUI interaction to verify at all**,
  the most reliably testable feature in this package's history), window
  geometry/position (`WidgetMove`/`SetGeometry`/`X`/`Y`/`Width`/`Height`/
  `Raise`), `QLineEdit` echo mode (`LineEditSetEchoMode`, e.g. password
  masking), and an editable `QComboBox` (`ComboBoxSetEditable`/
  `SetEditText`/`ConnectEditTextChanged`) - three real gaps found by
  surveying the existing surface (widget positioning had never been
  bound at all through 14 prior phases; `QLineEdit`/`QComboBox` had no
  password/free-text-entry support). **One honest exception, the same
  narrower flakiness against `xdotool windowactivate` first seen in
  v0.14.0's `QWizard` window** - this phase's own combined example
  window intermittently failed the same `XGetWindowProperty
  [_NET_WM_DESKTOP]` check, and once it did, subsequent `Tab`-focus
  keystrokes didn't reliably land where expected. What *did* confirm
  live in a single screenshot: the process's real stdout/exit code
  rendered in the status label, the window's moved position, and the
  password field showing masked dots. The editable combo box's
  `editTextChanged` wiring and the password field's real (unmasked)
  underlying text were instead confirmed via the standard
  standalone-C++-spike technique - both fired/read back exactly as
  expected.
- **v0.16.0** - `QNetworkAccessManager`/`QNetworkReply` (a simple HTTP
  GET, no POST/headers/auth yet - **needs no GUI interaction to verify
  at all**, matching `QProcess`'s own v0.15.0 precedent - and the first
  feature in this package needing a live network connection to test),
  item-widget `Count`/`Clear` housekeeping (`ListWidget`/`ComboBox`/
  `TreeWidget` - three real gaps found by surveying the existing
  surface, alongside `QMessageBox::critical` (`MessageBoxCritical`,
  alongside the existing `Information`/`Warning`/`Question`) and a
  `QRegularExpressionValidator` for `QLineEdit`
  (`LineEditSetRegexValidator`, alongside the existing `Int`/`Double`
  validators). **One honest exception, a continuation of the
  `xdotool windowactivate` flakiness pattern from v0.14.0/v0.15.0**:
  this phase's own window hit the same intermittent
  `XGetWindowProperty[_NET_WM_DESKTOP]` failures, and once it did,
  keyboard `Tab`/`Space` on the "Clear list" button didn't register.
  What confirmed fully live in a single screenshot: the real HTTP GET's
  status code (`HTTP 200` against `https://example.com`) and the item
  list's correct initial count. `ListWidgetClear`/`Count` and the
  regex validator's accept/reject behavior were instead confirmed via
  the standard standalone-C++-spike technique - both matched real Qt
  behavior exactly (`QValidator::Acceptable`/`Invalid` on good/bad
  input, count 3→0 after clearing).
- **v0.17.0** - `QPixmap` (a standalone, loaded-once image handle -
  `NewPixmapFromFile`/`IsNull`/`Width`/`Height`/`Destroy`, addressing a
  wart named plainly since v0.10.0's own `PainterDrawPixmap` doc
  comment: "loads a fresh copy from disk every single call"),
  `QLabel` hyperlinks (`LabelSetOpenExternalLinks`/
  `ConnectLinkActivated` - real Qt auto-detects `<a href>` HTML in any
  label's text), `QListWidget` single-row removal
  (`ListWidgetRemoveRow`, alongside the existing remove-everything
  `Clear`), and `QSettings` `Contains`/`Remove`. The same `Pixmap`
  handle now works both as `PainterDrawPixmapHandle`'s argument (custom
  drawing) and `LabelSetPixmap`'s argument (a label) - confirmed live
  side by side in the same window, not just independently. **One
  honest exception, the fourth phase in a row (14-17) hitting the same
  `xdotool windowactivate` flakiness** against this phase's own plain
  `QMainWindow`: subsequent `Tab`/`Space` keystrokes after the initial
  screenshot didn't register. What confirmed fully live in one
  screenshot: the shared pixmap rendering identically via both
  consumers, the hyperlink's correct blue/underlined rendering, the
  full 3-item list, and the real `QSettings::contains`/`remove` round
  trip (`contains-before=1 contains-after=0`) in the status label -
  all rendering/state confirmations needing no further interaction.
  `LabelConnectLinkActivated` and `ListWidgetRemoveRow` were instead
  confirmed via the standard standalone-C++-spike technique - both
  fired/behaved exactly as expected (`emit`ting `linkActivated`
  directly reached the connected callback; removing row 1 from a
  3-item list left count 2).

## Why event filters, not a widget subclass

Every other custom-behavior widget in this package (`PainterWidget`,
the one existing `Q_OBJECT` subclass before this version) needed a real
`ShimWidget : public QWidget` subclass, because `QWidget::paintEvent`
can only be overridden by subclassing - there is no other way to
intercept it. Drag-and-drop is different: `QObject::installEventFilter`
lets a *separate* `QObject` intercept another `QObject`'s events
without subclassing it at all, which matters a lot here specifically
because a subclass-based approach would need one dedicated `Shim*`
class *per widget type* users might want to make draggable/droppable
(`ShimDragLabel`, `ShimDropFrame`, ...) - multiplying against every
existing widget type in this package - whereas two small event-filter
classes (`ShimDragSourceFilter`/`ShimDropTargetFilter`) work on any of
them uniformly. Each filter is constructed with the watched widget as
its own `QObject` parent, so Qt manages its lifetime automatically,
tied to the widget (matching the "container now owns it" convention
already used for `QIntValidator`/`QDoubleValidator` in v0.8.0).

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
**If your program uses `printer.bas` (`QPrinter`, since v0.14.0)**, also
add `-l Qt6PrintSupport` (before `-l Qt6Widgets`, matching real
`pkg-config --libs Qt6PrintSupport Qt6Widgets` order) - it's a separate
Qt module the native shim links against but doesn't forward
automatically, for the same `.libs`-sidecar reason as every other Qt6
library here. **If your program uses `network.bas`
(`QNetworkAccessManager`, since v0.16.0)**, similarly add
`-l Qt6Network` (before `-l Qt6Widgets`).

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

## Phase 2 widgets

`QCheckBox`/`QRadioButton` share one `AbstractButton` function family
(both are real `QAbstractButton` subclasses with the identical
`setChecked`/`isChecked`/`toggled` shape) - matching `eb-haiku`'s own
"one function, several real subclasses" convention already used for
`HControlSetEnabled`. Radio buttons sharing the same immediate parent
widget are mutually exclusive automatically (Qt's own default
behavior) - no grouping call needed for the common case;
cross-container grouping via `QButtonGroup` isn't bound yet.

```basic
DIM chk AS CheckBox
chk = NewCheckBox("Enable feature")
CALL AbstractButtonConnectToggled(chk, @OnToggled, 0)

DIM radio1 AS RadioButton
radio1 = NewRadioButton("Option A")
CALL AbstractButtonSetChecked(radio1, 1)
```

`QComboBox`:

```basic
DIM combo AS ComboBox
combo = NewComboBox()
CALL ComboBoxAddItem(combo, "First")
CALL ComboBoxAddItem(combo, "Second")
CALL ComboBoxConnectCurrentIndexChanged(combo, @OnChanged, 0)
```

`QTextEdit` (plain-text only, no rich-text/formatting surface exposed,
matching `eb-haiku`'s own `BTextView` scope) - **note its `textChanged`
signal takes no parameter** (unlike `QLineEdit`'s own version, which
carries the new text) - call `TextEditGetText` yourself inside the
handler if you need the content:

```basic
DIM te AS TextEdit
te = NewTextEdit()
CALL TextEditConnectTextChanged(te, @OnChanged, 0)
```

`QMenuBar`/`QMenu`/`QAction` - a `MainWindow` always manages its own
menu bar (auto-created on first access, matching real Qt idiom); a menu
bar owns its menus, a menu owns its actions - no separate destroy
function, the same "container now owns it" convention already
documented for layouts/central widgets:

```basic
DIM bar AS MenuBar
bar = MainWindowMenuBar(win)
DIM fileMenu AS Menu
fileMenu = MenuBarAddMenu(bar, "File")
DIM quitAction AS Action
quitAction = MenuAddAction(fileMenu, "Quit")
CALL ActionConnectTriggered(quitAction, @OnQuit, 0)
```

## Phase 3 widgets

`QTabWidget` - adding the first tab makes it current, so Qt fires
`currentChanged(0)` **synchronously, during `TabWidgetAddTab` itself**,
not later - construct anything that handler touches (e.g. a shared
status label) *before* adding any tabs, not after. (This is a general
Qt gotcha worth knowing beyond just this one signal: a widget can be
made to emit a signal as a side effect of its own construction/setup,
before the rest of your UI exists yet.)

```basic
DIM tabs AS TabWidget
tabs = NewTabWidget()
CALL TabWidgetConnectCurrentChanged(tabs, @OnTabChanged, 0)
CALL TabWidgetAddTab(tabs, page1, "First")
CALL TabWidgetAddTab(tabs, page2, "Second")
```

`QListWidget`/`QTableWidget` (simple item-based APIs, not the full
model/view framework - no custom item delegates/models):

```basic
DIM list AS ListWidget
list = NewListWidget()
CALL ListWidgetAddItem(list, "Alpha")
CALL ListWidgetConnectCurrentRowChanged(list, @OnRowChanged, 0)

DIM table AS TableWidget
table = NewTableWidget()
CALL TableWidgetSetRowCount(table, 2)
CALL TableWidgetSetColumnCount(table, 2)
CALL TableWidgetSetItemText(table, 0, 0, "r0c0")
```

`QDialog` is a real `QWidget` subclass, so `WidgetShow`/`WidgetResize`/
`WidgetSetWindowTitle`/`WidgetSetLayout`/`WidgetDestroy` already work on
its handle - only `DialogExec`/`DialogAccept`/`DialogReject`/
`DialogConnectFinished` are new:

```basic
DIM dlg AS Dialog
dlg = NewDialog()
CALL WidgetSetLayout(dlg, dialogLayout)
DIM accepted AS INTEGER
accepted = DialogExec(dlg)   ' blocks - a real Qt modal event loop
```

`QMessageBox`/`QFileDialog` are Qt's own static convenience dialogs, not
persistent widgets - every `parent` parameter takes a plain `QtWidget`;
pass an unassigned `DIM x AS QtWidget` (zero-initialized handle) for "no
parent window":

```basic
DIM yes AS INTEGER
yes = MessageBoxQuestion(win, "Confirm", "Continue?")

DIM raw AS ANY PTR
raw = FileDialogGetOpenFileName(win, "Open File", "", "All Files (*)")
' ... bridge through ZSTRING/STRING, then CALL FreeQtString(raw) -
' empty string means the user cancelled.
```

`QSlider`/`QSpinBox` (`CONST QtHorizontal`/`QtVertical` match real
`Qt::Orientation` values, pass directly to `NewSlider`) and
`QGroupBox` (a real `QWidget` subclass - `WidgetSetLayout` composes its
contents the same as any other container):

```basic
DIM slider AS Slider
slider = NewSlider(QtHorizontal)
CALL SliderSetRange(slider, 0, 100)
CALL SliderConnectValueChanged(slider, @OnValueChanged, 0)

DIM spin AS SpinBox
spin = NewSpinBox()
CALL SpinBoxSetRange(spin, 0, 100)
```

## Phase 4 widgets

`QProgressBar`:

```basic
DIM prog AS ProgressBar
prog = NewProgressBar()
CALL ProgressBarSetRange(prog, 0, 100)
CALL ProgressBarSetValue(prog, 50)
```

`QStatusBar` - a `MainWindow` always manages its own status bar
(auto-created on first access, matching real Qt idiom) - there is no
`NewStatusBar`, the same convention `MainWindowMenuBar` already uses:

```basic
DIM status AS StatusBar
status = MainWindowStatusBar(win)
CALL StatusBarShowMessage(status, "ready", 0)   ' 0 = until replaced
```

`QTreeWidget` (simple item-based API, not the full model/view
framework) - items are opaque handles owned by the tree (or a parent
item); a `currentItemChanged` handler receives a raw item handle, wrap
it via `WrapTreeItem` before calling `TreeItemText`/`TreeItemAddChild`
on it:

```basic
DIM tree AS TreeWidget
tree = NewTreeWidget()
DIM fruitItem AS TreeItem
fruitItem = TreeWidgetAddTopLevelItem(tree, "Fruit")
CALL TreeItemAddChild(fruitItem, "Apple")
CALL TreeWidgetConnectCurrentItemChanged(tree, @OnItemChanged, 0)
```

`QScrollArea`/`QSplitter` - both real `QWidget` subclasses, so
`WidgetSetLayout`/etc. already work; `ScrollAreaSetWidgetResizable`
matters because real Qt defaults it to off, which often looks wrong
(the inner widget stays at its own size instead of filling the
viewport):

```basic
DIM area AS ScrollArea
area = NewScrollArea()
CALL ScrollAreaSetWidgetResizable(area, 1)
CALL ScrollAreaSetWidget(area, innerWidget)

DIM split AS Splitter
split = NewSplitter(QtHorizontal)
CALL SplitterAddWidget(split, leftWidget)
CALL SplitterAddWidget(split, area)
```

`QToolBar` - a `MainWindow` creates and owns its own tool bars (no
`NewToolBar`); a tool bar's buttons are the same `Action` type
`QMenu` already uses (`ActionConnectTriggered` wires either one up
identically):

```basic
DIM bar AS ToolBar
bar = MainWindowAddToolBar(win, "Main")
DIM act AS Action
act = ToolBarAddAction(bar, "Increment")
CALL ActionConnectTriggered(act, @OnIncrement, 0)
```

## Phase 5 widgets

`QStackedWidget` - like `QTabWidget` (see "Phase 3 widgets" above),
adding the first page makes it current, so `StackedWidgetAddWidget` can
fire `currentChanged(0)` synchronously - construct anything the handler
touches first:

```basic
DIM stack AS StackedWidget
stack = NewStackedWidget()
CALL StackedWidgetConnectCurrentChanged(stack, @OnPageChanged, 0)
CALL StackedWidgetAddWidget(stack, page1)
CALL StackedWidgetAddWidget(stack, page2)
CALL StackedWidgetSetCurrentIndex(stack, 1)
```

`QColorDialog`/`QFontDialog` - more static convenience dialogs, same
shape as `QMessageBox`/`QFileDialog`: every `parent` parameter takes a
plain `QtWidget`, pass an unassigned `DIM x AS QtWidget` for "no parent
window". Both fill their `BYREF` out-parameters only when the user
actually picks something (returning non-zero) - on cancel, the
out-parameters are left untouched:

```basic
DIM r AS UBYTE, g AS UBYTE, b AS UBYTE
DIM noParent AS QtWidget
IF ColorDialogGetColor(noParent, "Pick a Color", 255, 0, 0, r, g, b) <> 0 THEN
    ' r/g/b now hold the picked color
END IF

DIM pointSize AS INTEGER, valid AS INTEGER
DIM raw AS ANY PTR
raw = FontDialogGetFont(noParent, pointSize, valid)
' raw is the family name (ANY PTR, see the FreeQtString bridge pattern)
' - only meaningful when valid <> 0.
```

`QDial` mirrors `QSlider`'s own function shape exactly (both are real
`QAbstractSlider` subclasses) - no orientation parameter, a dial is
always circular. `QLCDNumber` only displays integers (real Qt also
supports double/`QString`, not bound):

```basic
DIM knob AS Dial
knob = NewDial()
CALL DialSetRange(knob, 0, 100)
CALL DialConnectValueChanged(knob, @OnChanged, 0)

DIM lcd AS LCDNumber
lcd = NewLCDNumber()
CALL LCDNumberDisplay(lcd, 42)
```

`QDockWidget` - a real `QWidget` subclass, so `WidgetSetLayout`
composes its contents like any other container; `MainWindowAddDockWidget`
takes a `Qt::DockWidgetArea` value (`QtLeftDockWidgetArea`/
`QtRightDockWidgetArea`/`QtTopDockWidgetArea`/`QtBottomDockWidgetArea`):

```basic
DIM dock AS DockWidget
dock = NewDockWidget("Tools")
CALL DockWidgetSetWidget(dock, toolsWidget)
CALL MainWindowAddDockWidget(win, QtLeftDockWidgetArea, dock)
```

## Phase 6 widgets

`QGridLayout`/`QFormLayout` - both real `QLayout` subclasses, applied
via the same `WidgetSetLayout` (widget.bas) as `QVBoxLayout`/
`QHBoxLayout` already use (it takes any `QtObject`-based layout handle,
not just `BoxLayout`):

```basic
DIM grid AS GridLayout
grid = NewGridLayout()
CALL GridLayoutAddWidget(grid, someWidget, 0, 0, 1, 2)  ' row, col, rowSpan, colSpan

DIM form AS FormLayout
form = NewFormLayout()
CALL FormLayoutAddRow(form, "Name:", nameLineEdit)
```

`QButtonGroup` - enables cross-container radio button exclusivity (real
Qt's own default only groups by immediate parent widget, see "Phase 2
widgets" above) - a real, named follow-on noted as unbound since
v0.2.0. The group does **not** take ownership of its buttons (matching
real Qt - a button's actual parent widget/layout still owns it), but
does need its own real parent widget so Qt can manage *its* lifetime
(it's a plain `QObject` organizer with no natural widget-tree owner
otherwise):

```basic
DIM group AS ButtonGroup
group = NewButtonGroup(containerWidget)
CALL ButtonGroupAddButton(group, radio1)
CALL ButtonGroupAddButton(group, radio2)
CALL ButtonGroupConnectButtonClicked(group, @OnChanged, 0)
```

`QSystemTrayIcon` reuses the existing `Menu`/`Action` types (menu.bas)
for its context menu - construct a standalone one via the newly-added
`NewMenu()` (previously menus could only be created through a menu
bar). Unlike most "container now owns it" cases elsewhere in this
package, the tray icon does **not** take ownership of its context menu:

```basic
DIM tray AS SystemTrayIcon
tray = NewSystemTrayIcon()
CALL SystemTrayIconSetIconFromTheme(tray, "dialog-information")
DIM trayMenu AS Menu
trayMenu = NewMenu()
DIM quitAction AS Action
quitAction = MenuAddAction(trayMenu, "Quit")
CALL ActionConnectTriggered(quitAction, @OnQuit, 0)
CALL SystemTrayIconSetContextMenu(tray, trayMenu)
CALL SystemTrayIconShow(tray)
```

`QDateEdit`/`QTimeEdit`/`QCalendarWidget` - dates/times are marshaled
as separate int components (year/month/day, hour/minute/second) rather
than introducing a `QDate`/`QTime` wrapper `TYPE`:

```basic
DIM d AS DateEdit
d = NewDateEdit()
CALL DateEditSetDate(d, 2026, 8, 6)
DIM y AS INTEGER, m AS INTEGER, day AS INTEGER
CALL DateEditGetDate(d, y, m, day)

DIM cal AS CalendarWidget
cal = NewCalendarWidget()
CALL CalendarWidgetConnectSelectionChanged(cal, @OnDateChanged, 0)
```

**Note on `QCheckBox`/`QRadioButton` text**: use the new
`AbstractButtonGetText`, not `ButtonGetText`, on a `CheckBox`/
`RadioButton` handle - `ButtonGetText` casts to `QPushButton*`
internally, which is an invalid cast for these sibling
`QAbstractButton` subclasses (caught while building `phase6_demo.bas`'s
own `QButtonGroup` handler, which needed to read a clicked radio
button's label).

## Phase 7 features

`QTimer` - named `QTimer`, not `Timer`: eBasic's own stdlib already
defines a top-level `Timer()` function (seconds elapsed, see the
Date/Time Library reference) and identifiers are case-insensitive, so a
bare `TYPE Timer` collides with it. A plain `QObject` like
`ButtonGroup`/`SystemTrayIcon` above - needs a real parent widget at
construction so Qt manages its lifetime:

```basic
DIM t AS QTimer
t = NewQTimer(someParentWidget)
CALL QTimerSetInterval(t, 1000)
CALL QTimerConnectTimeout(t, @OnTick, 0)
CALL QTimerStart(t)
```

`QClipboard` - a process-wide singleton, accessed via the running
`Application`, matching `MainWindowMenuBar`/`MainWindowStatusBar`'s own
"always managed for you" convention (no separate `New*` function):

```basic
DIM clip AS Clipboard
clip = ApplicationClipboard(app)
CALL ClipboardSetText(clip, "hello")
DIM raw AS ANY PTR
raw = ClipboardGetText(clip)
' ... bridge through ZSTRING/STRING, then CALL FreeQtString(raw)
```

`QInputDialog` - static convenience dialogs, same shape as
`QMessageBox`/`QColorDialog`/`QFontDialog`. `InputDialogGetItem` needs
a list of choices - built via `StringList`/`StringListAdd` (mirroring
`QComboBox`'s own create-then-add-item convention); the dialog call
**consumes and destroys** the list it's given, unlike this package's
usual "container now owns it forever" convention:

```basic
DIM noParent AS QtWidget
DIM valid AS INTEGER
DIM raw AS ANY PTR
raw = InputDialogGetText(noParent, "Rename", "New label:", "Count", valid)

DIM value AS INTEGER
CALL InputDialogGetInt(noParent, "Interval", "Milliseconds:", 1000, 100, 5000, value, valid)

DIM items AS StringList
items = NewStringList()
CALL StringListAdd(items, "Red")
CALL StringListAdd(items, "Green")
raw = InputDialogGetItem(noParent, "Theme", "Pick a color:", items, 0, 0, valid)
```

`WidgetSetStyleSheet` - CSS-like Qt style sheet syntax, applicable to
any `QtWidget` (not a new widget type - just one more function on the
existing base):

```basic
CALL WidgetSetStyleSheet(myLabel, "background-color: #dfd; font-size: 18px; padding: 8px;")
```

## Phase 8 features

`QSettings` - persistent key/value app settings; on Linux (this host)
backed by a real INI-format file under
`~/.config/<organization>/<application>.conf` (confirmed by reading the
file directly after a save - real Qt's own `NativeFormat` default
resolves to INI on Unix, unlike Windows' registry). A plain `QObject`
like `QButtonGroup`/`QTimer` above - pass a real parent widget so Qt
manages its lifetime:

```basic
DIM settings AS Settings
settings = NewSettings("MyCompany", "MyApp", win)
CALL SettingsSetString(settings, "username", "alice")
CALL SettingsSync(settings)   ' forces a write now - real Qt already does this periodically and on destruction
DIM raw AS ANY PTR
raw = SettingsGetString(settings, "username", "(default)")
```

`QShortcut` - unlike `QTimer`/`Settings`, `parent` is not optional here:
real `QShortcut` is scoped to a window via its parent widget
(`Qt::WindowShortcut` context, the real Qt default) and has no
meaningful null-parent case. Independent of the menu system entirely -
useful precisely where interactive menu *opening* couldn't be verified
in this sandbox (see "Status" above):

```basic
DIM quitShortcut AS Shortcut
quitShortcut = NewShortcut("Ctrl+Q", win)
CALL ShortcutConnectActivated(quitShortcut, @OnQuit, 0)
```

`QIntValidator`/`QDoubleValidator` attach directly to an existing
`QLineEdit` - no new widget type or separate handle to track, since the
shim constructs the validator parented to the line edit itself:

```basic
CALL LineEditSetIntValidator(ageEdit, 0, 120)
CALL LineEditSetDoubleValidator(priceEdit, 0.0, 999.99, 2)
```

`QCompleter` - built from a `StringList` (the same builder
`InputDialogGetItem` uses, see "Phase 7 features" above), attached to a
`QLineEdit`. Like `InputDialogGetItem`, the completer **consumes and
destroys** the list it's given; unlike most types in this package, the
line edit then takes ownership of the completer itself (matching real
`QLineEdit::setCompleter` semantics) - no separate destroy function
needed for either:

```basic
DIM items AS StringList
items = NewStringList()
CALL StringListAdd(items, "Paris")
CALL StringListAdd(items, "London")
DIM completer AS Completer
completer = NewCompleter(items)
CALL LineEditSetCompleter(cityEdit, completer)
```

## Phase 9 features

Icons - no separate `QIcon` handle/`TYPE`; each function takes a theme
name (`QIcon::fromTheme`) or file path directly, matching
`QSystemTrayIcon`'s own `SystemTrayIconSetIconFromTheme` convention
from v0.6.0, extended here to buttons, actions, and window title bars:

```basic
CALL ButtonSetIconFromTheme(saveButton, "document-save")
CALL ActionSetIconFromTheme(quitAction, "application-exit")
CALL WidgetSetWindowIconFromTheme(win, "accessories-text-editor")
' Or from a file: ButtonSetIconFromFile/ActionSetIconFromFile/WidgetSetWindowIconFromFile
```

`QActionGroup` - the `QAction` equivalent of `ButtonGroup` (see "Phase
6 widgets" above): mutually exclusive actions, e.g. a set of menu items
where only one can be checked at a time. Actions added to a group must
be checkable (`ActionSetCheckable`) for exclusivity to be visible:

```basic
CALL ActionSetCheckable(leftAction, 1)
CALL ActionSetChecked(leftAction, 1)
CALL ActionSetCheckable(rightAction, 1)

DIM group AS ActionGroup
group = NewActionGroup(win)
CALL ActionGroupAddAction(group, leftAction)
CALL ActionGroupAddAction(group, rightAction)
CALL ActionGroupConnectTriggered(group, @OnAlignmentChanged, 0)
```

`WidgetSetToolTip` - shown after the mouse hovers over any widget for a
moment; real Qt handles the popup/timing itself:

```basic
CALL WidgetSetToolTip(saveButton, "Save the current document")
```

`QFrame` - a simple bordered/shadowed container for visual grouping,
distinct from `GroupBox` in having no title. A real `QWidget` subclass,
so `WidgetSetLayout` composes its contents like any other container;
`FrameSetFrameStyle` combines a shape (`QtFrameBox`/`QtFramePanel`/
`QtFrameStyledPanel`/`QtFrameHLine`/`QtFrameVLine`/`QtFrameNoFrame`)
with a shadow (`QtFramePlain`/`QtFrameRaised`/`QtFrameSunken`),
matching real Qt's own `setFrameStyle(shape | shadow)` idiom:

```basic
DIM box AS Frame
box = NewFrame()
CALL FrameSetFrameStyle(box, QtFrameStyledPanel, QtFrameSunken)
CALL WidgetSetLayout(box, someLayout)
```

## Phase 10 features

Images - no separate `QPixmap` handle/`TYPE`, matching this package's
icon convention: `LabelSetPixmapFromFile` loads and displays an image
in a `Label` (replacing any text), and `PainterDrawPixmap` loads and
draws one inside a `PainterWidget`'s own paint callback. Both return
non-zero on success, zero if the file couldn't be loaded as an image
(nothing changes/draws on failure):

```basic
DIM ok AS INTEGER
ok = LabelSetPixmapFromFile(myLabel, "assets/photo.png")

' Inside a paint callback:
CALL PainterDrawPixmap(painter, 10, 10, "assets/photo.png")
```

`PainterDrawPixmap` loads the file fresh on every call, with no
caching - fine for one-off demos, but a real app repainting often
(animation, resize) should prefer a `Label` with
`LabelSetPixmapFromFile` instead, which only loads once.

Rich text in `QTextEdit` - `TextEditSetHtml`/`TextEditGetHtml` add real
Qt rich-text (a small HTML subset, see Qt's own "Supported HTML
Subset" docs) alongside the existing plain-text
`TextEditSetText`/`TextEditGetText`, as an explicit opt-in:

```basic
CALL TextEditSetHtml(editor, "<b>Bold</b>, <i>italic</i>, and <span style='color:#c00'>red</span> text.")
```

Widget size constraints:

```basic
CALL WidgetSetMinimumSize(myWidget, 150, 0)
CALL WidgetSetMaximumSize(myWidget, 150, 1000)
```

Focus control - **`WidgetHasFocus` is not synchronous with
`WidgetSetFocus`**: real `QWidget::setFocus()` only posts a
focus-change event, applied once the Qt event loop processes it
(confirmed via a dedicated spike, not assumed). Check `WidgetHasFocus`
from a later callback (a different signal, or a `QTimer`), never
synchronously right after `WidgetSetFocus`:

```basic
CALL WidgetSetFocus(nameEdit)
' NOT: someLabel status = WidgetHasFocus(nameEdit) - would see the OLD
' state. Defer instead, e.g. via a single-shot QTimer:
CALL QTimerStart(focusCheckTimer)
```

## Phase 11 features

`WidgetSetEnabled`/`IsEnabled` - a disabled widget is grayed out and
stops accepting input; real Qt also disables (transitively) any child
widgets, unless one of them was explicitly re-enabled itself:

```basic
CALL WidgetSetEnabled(myLineEdit, 0)
```

`WidgetSetVisible`/`IsVisible` - distinct from `WidgetShow`: a widget
hidden this way is actively hidden even if a parent later shows itself
again (matches real `QWidget::hide()`/`setVisible(false)`):

```basic
CALL WidgetSetVisible(myLabel, 0)
```

`WidgetSetFont` - family, point size, and bold/italic flags in one
call, matching `QFont`'s own most-common constructor shape - affects
this widget and, unless overridden, its children:

```basic
CALL WidgetSetFont(myLabel, "Serif", 18, 1, 1)   ' bold italic
```

`QScrollBar`, used standalone - mirrors `QSlider`'s own function shape
exactly (both are real `QAbstractSlider` subclasses); `QtHorizontal`/
`QtVertical` (common.bas) apply here too:

```basic
DIM bar AS ScrollBar
bar = NewScrollBar(QtHorizontal)
CALL ScrollBarSetRange(bar, 0, 100)
CALL ScrollBarConnectValueChanged(bar, @OnChanged, 0)
```

## Phase 12 features

`BoxLayout` spacing/margins - real defaults are much tighter than a
custom value would typically be, so these are usually only needed when
the default look isn't dense/spread out enough:

```basic
CALL BoxLayoutSetSpacing(myLayout, 16)
CALL BoxLayoutSetContentsMargins(myLayout, 24, 24, 24, 24)
```

`Label` alignment/word-wrap - combine a horizontal and vertical
alignment flag via eBasic's own bitwise `OR` operator:

```basic
CALL LabelSetWordWrap(myLabel, 1)
CALL LabelSetAlignment(myLabel, QtAlignHCenter OR QtAlignVCenter)
```

`WidgetSetCursor` - overrides the mouse cursor shown while hovering a
widget:

```basic
CALL WidgetSetCursor(myButton, QtPointingHandCursor)
```

Themed icons on `ComboBox`/`ListWidget` items - extends the
theme-icon convention from `QSystemTrayIcon`/buttons/actions/windows
(see "Phase 9 features" above) to item-based widgets:

```basic
CALL ComboBoxAddItemWithIconFromTheme(myCombo, "Documents", "folder")
CALL ListWidgetAddItemWithIconFromTheme(myList, "Save", "document-save")
```

## Phase 13 features

Drag-and-drop - see "Why event filters, not a widget subclass" above
for the implementation approach. Only plain-text MIME data:

```basic
CALL WidgetEnableDragSource(sourceLabel, "Hello from eb-qt6!")

SUB OnDropped(userData AS ANY PTR, text AS ZSTRING)
    ' text is borrowed - copy it into a STRING if you need it after
    ' this call returns, same convention as LineEditConnectTextChanged.
END SUB
CALL WidgetEnableDropTarget(targetFrame, @OnDropped, 0)
```

## Phase 14 features

`QSplashScreen`:

```basic
DIM splash AS SplashScreen
splash = NewSplashScreenFromFile("logo.png")
CALL SplashScreenShowMessage(splash, "Loading...")
CALL SplashScreenShow(splash)
' ... construct your real main window ...
CALL SplashScreenFinish(splash, win)   ' closes the splash automatically
CALL WidgetShow(win)
```

`QWizard`/`QWizardPage` - pages are plain widgets composed the usual way
(`WidgetSetLayout`), no subclassing needed; the wizard itself provides
Next/Back/Finish/Cancel navigation:

```basic
DIM page1 AS WizardPage
page1 = NewWizardPage("Your name")
CALL WidgetSetLayout(page1, someLayoutWithAFieldInIt)

DIM wiz AS Wizard
wiz = NewWizard()
CALL WizardAddPage(wiz, page1)
CALL WizardConnectAccepted(wiz, @OnWizardAccepted, 0)   ' fires on Finish
CALL WizardShow(wiz)
```

PDF printing via `QPrinter` - restricted to PDF-file output, no real
printer/print dialog, since this sandbox has no real printer to test
against and PDF-to-file is the one printing path fully testable without
any interaction (write a file, check it's non-empty). **Must be
constructed after `NewApplication`** - like `QApplication` itself,
`QPrinter` aborts the process if constructed too early:

```basic
DIM p AS Printer
p = NewPdfPrinter("output.pdf")
DIM painter AS ANY PTR
painter = PrinterBegin(p)          ' same handle every Painter* fn takes
CALL PainterDrawText(painter, 100, 100, "Hello, PDF")
CALL PrinterEnd(p)                 ' writes the file; painter now invalid
```

Multi-column `QTreeWidget` - `TreeWidgetAddTopLevelItem`/`TreeItemAddChild`
(Phase 4) only ever set column 0; these fill in the rest:

```basic
CALL TreeWidgetSetColumnCount(tree, 2)
DIM headers AS StringList
headers = NewStringList()
CALL StringListAdd(headers, "Name")
CALL StringListAdd(headers, "Value")
CALL TreeWidgetSetHeaderLabels(tree, headers)   ' consumed/destroyed here

DIM row AS TreeItem
row = TreeWidgetAddTopLevelItem(tree, "Alpha")
CALL TreeItemSetText(row, 1, "100")
```

## Phase 15 features

`QProcess` - a real `Process` needs no GUI/keyboard/mouse interaction
to verify: run a command, wait for it, read its output/exit code:

```basic
DIM proc AS Process
proc = NewProcess(win)   ' parent widget, same lifetime convention as QTimer
CALL ProcessStart(proc, "echo hello")
CALL ProcessWaitForFinished(proc, 5000)   ' ms, or -1 to wait forever
DIM outRaw AS ANY PTR
outRaw = ProcessReadAllStandardOutput(proc)   ' owned - free via FreeQtString
DIM exitCode AS INTEGER
exitCode = ProcessExitCode(proc)
```

Window geometry/position - meaningful for a top-level window; ignored
for a widget managed by a layout (real Qt semantics):

```basic
CALL WidgetMove(win, 200, 150)
CALL WidgetSetGeometry(win, 200, 150, 640, 480)
CALL WidgetRaise(win)
PRINT WidgetX(win); WidgetY(win); WidgetWidth(win); WidgetHeight(win)
```

`QLineEdit` echo mode - password masking, alongside the existing
plain-text `LineEditSetText`/`GetText` (which still operate on the real
underlying text either way):

```basic
CALL LineEditSetEchoMode(passwordEdit, QtLineEditPassword)
```

Editable `QComboBox` - lets the user type free-form text, not just pick
from the item list:

```basic
CALL ComboBoxSetEditable(combo, 1)
CALL ComboBoxConnectEditTextChanged(combo, @OnEditTextChanged, 0)   ' fires per keystroke
```

## Phase 16 features

`QNetworkAccessManager`/`QNetworkReply` - a simple HTTP GET only (no
POST/headers/auth yet). `NetworkReplyWaitForFinished` spins a local
event loop until the reply's own `finished` signal fires - the standard
Qt idiom for a "synchronous-looking" async request, so you don't have
to wire up a callback just to block:

```basic
DIM manager AS NetworkManager
manager = NewNetworkManager(win)   ' parent widget, same lifetime convention as QTimer/QProcess
DIM reply AS NetworkReply
reply = NetworkManagerGet(manager, "https://example.com")
CALL NetworkReplyWaitForFinished(reply, 10000)   ' ms, or -1 to wait forever
IF NOT NetworkReplyHasError(reply) THEN
    PRINT NetworkReplyStatusCode(reply)   ' e.g. 200
END IF
CALL NetworkReplyDeleteLater(reply)   ' real Qt convention - never delete a reply directly
```

Item-widget housekeeping - `Count`/`Clear` on `ListWidget`/`ComboBox`/
`TreeWidget` (the tree's is top-level-item count only, not recursive):

```basic
PRINT ListWidgetCount(myList)
CALL ListWidgetClear(myList)
```

`QMessageBox::critical`, alongside the existing `Information`/
`Warning`/`Question`:

```basic
CALL MessageBoxCritical(win, "Error", "Something went wrong.")
```

`QRegularExpressionValidator` for `QLineEdit`, alongside the existing
`Int`/`Double` validators - for patterns those can't express:

```basic
CALL LineEditSetRegexValidator(emailEdit, "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+$")
```

## Phase 17 features

`QPixmap` - a standalone, loaded-once image handle, reusable across
both custom drawing and labels with no repeated file I/O:

```basic
DIM pic AS Pixmap
pic = NewPixmapFromFile("photo.png")
IF NOT PixmapIsNull(pic) THEN
    CALL LabelSetPixmap(myLabel, pic)          ' a label...
    CALL PainterDrawPixmapHandle(painter, 10, 10, pic)   ' ...and custom drawing, same handle
END IF
CALL PixmapDestroy(pic)   ' once nothing needs it anymore - see its own doc comment
```

`QLabel` hyperlinks - real Qt auto-detects `<a href>` HTML in any
label's text:

```basic
DIM link AS Label
link = NewLabel("<a href=""https://example.com"">Click here</a>")
CALL LabelSetOpenExternalLinks(link, 0)   ' handle the click yourself instead of opening a browser
CALL LabelConnectLinkActivated(link, @OnLinkActivated, 0)
```

`QListWidget` single-row removal, alongside the existing
remove-everything `ListWidgetClear`:

```basic
CALL ListWidgetRemoveRow(myList, 1)   ' removes just that one row
```

`QSettings` `Contains`/`Remove`:

```basic
IF SettingsContains(mySettings, "theme") THEN
    CALL SettingsRemove(mySettings, "theme")
END IF
```

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
- `phase2_demo.bas` - a menu bar, checkbox, two radio buttons, a combo
  box, and a text edit composed via `QVBoxLayout`. `Tab`+`Space` toggling
  the checkbox, `Tab`+`Down` changing the combo box selection, and
  typing into the text edit were all confirmed live, each updating a
  shared status label. **One honest exception**: interactively *opening*
  the `File` menu via keyboard (`Alt+F`, `F10`) could not be confirmed
  live in this sandboxed session - see "Status" above.
- `phase3_demo.bas` - a tab widget (one tab with a synced slider + spin
  box inside a group box, another with a list widget + table widget),
  plus buttons opening a custom `QDialog`, a `QMessageBox::question`,
  and a `QFileDialog`. Confirmed live via keyboard: switching tabs
  (`currentChanged`), dragging the slider syncing the spin box and vice
  versa (`valueChanged`), selecting a list row (`currentRowChanged`),
  the full dialog round trip (`Tab`+`Space` on its own OK button calling
  `DialogAccept`, `DialogExec` returning, `finished` firing), and the
  message box's Yes/No mapping. **Two honest exceptions** (see "Status"
  above): `QTableWidget::cellClicked` (mouse-only) wasn't confirmed
  live, though the table's own rendering was; `QFileDialog` was
  confirmed to open as a real dialog window (found via `xwininfo`), but
  the full pick-a-file-and-return round trip wasn't screenshot-verified
  in this session (the screenshot tool raced the dialog's own window
  lifecycle) - the code path is identical in shape to the
  already-proven `QMessageBox` static-function pattern, so this is
  treated as a verification-tooling gap, not a suspected code defect.
  This example also caught a real, general Qt gotcha (not
  eb-qt6-specific): `QTabWidget` fires `currentChanged(0)`
  *synchronously* the moment its first tab is added (see "Phase 3
  widgets" above) - the original draft crashed here because the shared
  status label the handler touches hadn't been constructed yet.
- `phase4_demo.bas` - a tool bar (`Increment` action), a status bar, a
  splitter dividing a tree widget from a scroll area full of labels, and
  a progress bar. Confirmed live: the tree/splitter/scroll area/progress
  bar/status bar all render correctly, and selecting a tree item fires
  `currentItemChanged` (the status bar immediately showed "tree: Fruit"
  from the tree's own initial auto-selection - constructing the status
  bar *before* adding any tree items, learned directly from
  `phase3_demo.bas`'s `QTabWidget` crash, avoided a repeat here). **One
  honest exception** (see "Status" above): the toolbar's `Increment`
  action couldn't be activated via either `Tab`+`Space` (real Qt
  behavior - toolbar buttons aren't in the normal focus chain) or a real
  mouse click at verified coordinates - but a standalone C++ spike
  proved `ActionConnectTriggered`'s own binding correct by calling
  `QAction::trigger()` directly, isolating the gap to input delivery,
  not the code.
- `phase5_demo.bas` - a stacked widget (two pages, `Next`/`Back`
  buttons), a dock widget with a dial synced to an LCD number, and
  buttons opening a color dialog and a font dialog. Confirmed live via
  keyboard: page switching (`currentChanged`), the dial driving the LCD
  display (`valueChanged`), the full `QColorDialog` round trip
  (`Escape` cancelling it, status bar showing "color: cancelled"), and
  the full `QFontDialog` round trip (`Return` accepting the default
  font, status bar showing the real picked family/point size, e.g.
  "font: Ubuntu Sans 11"). **No new honest exceptions** - every signal
  and dialog in this example was confirmed live. (The status bar was
  again constructed before the stack's first page was added, applying
  the same lesson `phase3_demo.bas`/`phase4_demo.bas` already
  established.)
- `phase6_demo.bas` - a form layout (date edit + time edit + a save
  button), a grid layout (a calendar widget spanning two columns above
  two `QButtonGroup`-linked radio buttons), and a system tray icon with
  a `Quit` context-menu action. Confirmed live via keyboard: the radio
  group's shared `buttonClicked` handler (status bar showing "radio:
  Weekly"/"radio: Monthly" as focus/arrow-key navigation moved between
  them - `QButtonGroup` also enables cross-cell arrow-key navigation
  between the two, a nice side effect of grouping), reading back the
  saved date/time components (`DateEditGetDate`/`TimeEditGetTime`), and
  the calendar's `selectionChanged` firing with the correct new
  year/month/day. **One honest exception** (see "Status" above):
  `QSystemTrayIcon` construction and API calls all succeeded without
  error, but the icon's actual on-screen appearance in the desktop
  panel couldn't be screenshot-confirmed - capturing a specific
  application window worked fine in the same session, but a full-screen
  capture (needed to see the desktop panel) failed for tooling reasons.
- `phase7_demo.bas` - a `QTimer`-driven counter label (styled via
  `WidgetSetStyleSheet`), clipboard copy/paste, and all three
  `QInputDialog` variants. **No new honest exceptions** - every signal
  and dialog round trip was confirmed live, though this example needed
  noticeably more careful, step-by-step keyboard navigation (screenshot
  the focus ring after every single `Tab`, only then press `Space`)
  than earlier phases - blind `Tab`-count-then-`Space`/`Return`
  sequences landed on the wrong control more than once (once
  accidentally opening a modal dialog several steps early, once
  triggering a dialog's Cancel instead of OK via `Return`). Confirmed:
  `QTimer::timeout` firing repeatedly and updating the counter,
  `WidgetSetStyleSheet` applying real visual styling (background color
  changes, confirmed both at startup and again after
  `InputDialogGetItem`'s own result was applied), `ClipboardSetText`/
  `GetText` round-tripping the exact copied text, and all three
  `QInputDialog` variants (`getText`'s pre-filled default accepted,
  `getInt`'s default value accepted and correctly read back via its
  `BYREF` out-parameters, `getItem`'s combo-box selection navigated with
  `Down` and accepted).
- `phase8_demo.bas` - an age field restricted by `QIntValidator`, a city
  field with `QCompleter` autocomplete, a `Ctrl+Q` `QShortcut` that
  quits, and `QSettings` persisting the age across real process
  restarts. **No new honest exceptions** - every feature was confirmed
  live: typing `"abc42xyz"` into the age field left only `"42"`
  (`QIntValidator` rejecting the letters, confirmed via the resulting
  `textChanged` value), typing `"Lon"` into the city field produced a
  real popup window showing `"London"` (`QCompleter` - the popup closes
  fast enough that it took a same-shell type-then-screenshot to catch
  it, rather than separate sequential tool calls), `Ctrl+Q` cleanly
  exited the running process (`QShortcut`, confirmed via the process's
  own exit code, not a screenshot), and relaunching the compiled binary
  fresh showed the previously-saved age pre-loaded, with the real
  `~/.config/eb-qt6/phase8_demo.conf` INI file inspected directly to
  confirm `QSettings` actually persisted to disk, not just in-memory.
  **Caught and fixed a real crash before publishing**: the original
  draft called `LineEditSetText` to pre-fill the age field from
  `QSettings` before the shared status label existed - `setText` fires
  `textChanged` synchronously (confirmed via `gdb`, same class of
  "signal fires as a side effect of setup" issue as `QTabWidget`/
  `QTreeWidget`/`QStackedWidget` in earlier phases, just via `setText`
  rather than an `addTab`/`addWidget`-style call this time), and the
  connected handler touched the not-yet-constructed label. Fixed by
  constructing the status label first, same lesson, new trigger.
- `phase9_demo.bas` - a themed icon on a button/window title, a `View`
  menu with three checkable actions grouped by `ActionGroup`, a
  `QFrame`-bordered panel, and a tooltip. Confirmed live: the button's
  real icon rendering (a visible save glyph next to its text), the
  window's real `_NET_WM_ICON` X11 property (inspected directly via
  `xprop`, not just inferred), and the button's `clicked` signal via
  keyboard activation. **One honest exception**: hovering the mouse
  over the button never produced a visible tooltip popup in this
  sandbox, even with a deliberate enter-then-settle mouse sequence - a
  new variant of the already-documented synthetic-mouse-input
  limitation (tooltip display depends on genuine hover dwell time,
  which `xdotool mousemove` doesn't reliably produce here).
  `ActionGroup`'s own exclusivity logic was **not** confirmed live
  either - a small popup window did briefly appear once after an
  `Alt+V` mnemonic attempt, but it was too fast to capture and
  ambiguous (possibly a delayed tooltip rather than the menu itself),
  and repeated attempts afterward produced no popup at all - so rather
  than overclaim, the binding was instead proven correct independently
  via a standalone C++ spike (same technique as `QToolBar` in v0.4.0):
  calling `QAction::trigger()` directly on one of the group's actions
  fired the connected callback and correctly flipped the checked state
  of the other action to false, confirming the exclusivity logic itself
  works, with the gap isolated to input delivery in this sandbox.
- `phase10_demo.bas` - a `Label` showing an image, a `PainterWidget`
  drawing the same image plus text, a `TextEdit` with rich HTML content,
  and a size-constrained `LineEdit`. Confirmed live: the image rendering
  identically in both the `Label` and the custom-painted canvas, real
  bold/italic/colored HTML rendering after `TextEditSetHtml`, and
  `TextEditGetHtml` returning Qt's own generated markup (a real, much
  longer string than the input, confirmed by length). Also caught a
  real, non-obvious usability issue while wiring up keyboard
  verification (not a binding bug): a plain `QTextEdit` consumes `Tab`
  itself (inserts a tab character) rather than passing focus onward,
  so the example now explicitly starts keyboard focus on a button via
  `WidgetSetFocus` right after `WidgetShow` - dogfooding this same
  phase's own new function to sidestep it. **One honest, well-
  substantiated exception** (see "Status" above): `WidgetHasFocus`
  never returned true after `WidgetSetFocus` in this sandbox, even from
  a correctly-deferred `QTimer` callback; root-caused (not just
  observed) to `xdotool getactivewindow` reporting no active window at
  all in this session, even right after `xdotool windowactivate` -
  `QWidget::hasFocus()` depends on real window-manager-level activation
  this sandbox's WM never completes, distinct from (and narrower than)
  the general "clicks/keys don't reach the target" limitations
  documented elsewhere - individual keystrokes still work fine here.
- `phase11_demo.bas` - enable/disable and show/hide toggles on a target
  `LineEdit`/`Label`, a custom font applied to another `Label`, and a
  standalone `QScrollBar` driving an `LCDNumber`. Confirmed live via
  keyboard: `WidgetSetEnabled` visibly graying out the line edit and
  `WidgetIsEnabled` reading back correctly, `WidgetSetVisible` actually
  removing the label from layout (not just repositioning it) and
  `WidgetIsVisible` reading back correctly, and `WidgetSetFont`
  rendering real serif/bold/italic text. **One honest exception**: the
  `QScrollBar` never received keyboard focus via `Tab` in this sandbox
  (plausible real Qt behavior - `QScrollBar`'s default focus policy
  often excludes it from the native style's tab order, unlike
  `QSlider`) - the binding was instead proven correct via a standalone
  C++ spike: calling `QScrollBar::setValue()` directly fired the
  connected `valueChanged` callback and updated the read-back value
  exactly as expected.
- `phase12_demo.bas` - a `ComboBox` and `ListWidget` with themed icon
  items, a centered word-wrapped `Label`, a layout with generously
  custom spacing/margins, and a button with a pointing-hand cursor.
  Confirmed live: real folder/save icons rendering next to both the
  combo box's current item and the list's items, a long sentence
  visibly wrapping across three centered lines, and the layout's extra
  spacing/margins clearly visible around and between widgets. Keyboard
  navigation changed both the combo box's selection and the list's
  current row, each correctly updating the shared status label with
  the new index/row. **One honest exception, a new *kind* of gap**:
  the button's custom pointing-hand cursor couldn't be visually
  confirmed - not an input-delivery limitation this time, but a
  screenshot-tooling one: `import` doesn't capture the X11 mouse
  cursor overlay at all (composited by the X server, not part of a
  window's own pixel buffer, confirmed by checking `import -help` for
  a cursor-capture flag and finding none) - proven correct anyway via
  a standalone C++ spike reading `QWidget::cursor().shape()` before and
  after the call.
- `phase13_demo.bas` - a draggable `Label` ("Drag me!") and a
  drop-target `Frame` ("Drop here"). Both render correctly (confirmed
  via screenshot) and the app doesn't crash. **Not confirmed as
  actually working**, honestly: a real mouse-drag gesture (press,
  move, release) via `xdotool` didn't produce any visible change,
  matching the sandbox's already-documented mouse-interaction
  limitation - but unlike every other such case in this README, this
  one could **not** be independently confirmed via the standalone-spike
  technique either, for a reason specific to drag-and-drop itself (see
  "Status" above for the full investigation - a manually-constructed
  `QDropEvent` doesn't reach *either* an event filter or a real
  subclass's `dropEvent()` override via `sendEvent()`, ruling out a
  flaw specific to this package's own implementation choice, but also
  meaning the feature's actual correctness remains unconfirmed here).
  This is the most honestly *uncertain* item published in this
  package's history - flagged as such deliberately rather than
  claimed as either working or broken.
- `phase14_demo.bas` - a splash screen shown at startup then finished
  into the main window, a "Open wizard" button launching a 2-page
  `QWizard`, a one-page PDF printed to a scratch path at startup, and a
  multi-column `TreeWidget` with header labels and per-column item text.
  Confirmed live: the splash screen correctly transitions to the main
  window, the main window's tree renders both columns ("Name"/"Value"
  headers, two rows with values in column 1), and the PDF file exists
  with non-zero size after the app runs. **One honest exception, a new
  variant of the WM-activation gap**: `xdotool windowactivate` was
  intermittently unreliable against the wizard's own top-level window
  specifically (`XGetWindowProperty[_NET_WM_DESKTOP] failed`), more so
  than any plain `QMainWindow` in this README - plausibly because modal
  Qt dialogs don't get `_NET_WM_DESKTOP` set the way a top-level main
  window does. What *did* work live: opening the wizard via a real
  keyboard click on its launch button, and `WidgetSetFocus` correctly
  focusing the page's `LineEdit`. Page navigation and the `accepted`
  signal firing on Finish were instead confirmed via a standalone C++
  spike calling `QWizard::next()`/`accept()` directly on the real
  object - the connected callback fired exactly as expected.
- `phase15_demo.bas` - runs `echo hello` via `QProcess` at startup and
  shows its real stdout/exit code in a status label, moves the main
  window via `WidgetMove`/`WidgetRaise`, shows a password field
  (`LineEditSetEchoMode`) pre-filled with a real value, and an editable
  `ComboBox`. Confirmed live in a single screenshot: the process's real
  output ("Hello from QProcess") and exit code (0) rendered correctly,
  the window appeared at its moved position, and the password field
  showed masked dots instead of the real text. **One honest exception,
  the same `xdotool windowactivate` flakiness first seen against
  v0.14.0's `QWizard` window, this time against this phase's own plain
  `QMainWindow`**: subsequent `Tab`-focus keystrokes after the initial
  screenshot didn't reliably land on the expected widget, so clicking
  the "Reveal" button and typing into the editable combo box live
  couldn't be confirmed this way. Both were instead confirmed via a
  standalone C++ spike: `ComboBoxConnectEditTextChanged` fired with the
  exact text set via `eb_qt6_combobox_set_edit_text`, and the password
  `QLineEdit`'s real underlying `text()` read back correctly
  (`"secret42"`) despite its masked on-screen display.
- `phase16_demo.bas` - issues a real HTTP GET to `https://example.com`
  via `QNetworkAccessManager` at startup, shows a 3-item `ListWidget`
  with a "Clear list" button, a "Show critical dialog" button, and an
  email-shaped `LineEdit` validator. Confirmed live in a single
  screenshot: the real HTTP response status (`HTTP 200`) rendered in
  the status label, and the list's correct initial item count on the
  Clear button's own label. **One honest exception, the same
  `xdotool windowactivate` flakiness pattern continuing from v0.14.0/
  v0.15.0**: this phase's window also hit intermittent
  `XGetWindowProperty[_NET_WM_DESKTOP]` failures, and subsequent
  `Tab`/`Space` on the "Clear list" button didn't register live.
  `ListWidgetClear`/`Count` and the regex validator were instead
  confirmed via a standalone C++ spike: clearing a 3-item list read
  back count 0 afterward, and the validator correctly returned
  `QValidator::Acceptable` for `"user@example.com"` and `Invalid` for
  `"not valid!!"`. `MessageBoxCritical` itself wasn't separately
  spiked - its shim function is structurally identical to the
  already-live-confirmed `MessageBoxInformation`/`Warning`/`Question`
  calls (Phase 1-3), just a different `QMessageBox::critical` call
  underneath the same pattern.
- `phase17_demo.bas` - loads one `Pixmap` and draws it both on a custom
  `PainterWidget` (`PainterDrawPixmapHandle`) and a `Label`
  (`LabelSetPixmap`), a hyperlink `Label`, a 3-item `ListWidget` with a
  "Remove row 1" button, and a `QSettings` `Contains`/`Remove` round
  trip run at startup. **A real bug caught before this could even be
  screenshotted**: the first run showed a blank pixmap in both
  consumers - not a binding defect, a plain relative-path mistake in
  the example itself (`"assets/sample.png"` resolves relative to the
  process's current working directory, not the source file's location;
  running the compiled binary from the repo root instead of `examples/`
  left the path unresolved, and `QPixmap` fails silently rather than
  erroring - matching its own documented silent-failure behavior).
  Fixed by relaunching with `examples/` as the working directory, the
  same requirement every other example in this package already has.
  Confirmed live in a single screenshot once fixed: the identical image
  rendering correctly via both the painter and the label side by side,
  the hyperlink's correct rendering, the full 3-item list, and
  `contains-before=1 contains-after=0` in the status label - all
  needing no interaction. **One honest exception, the fourth phase in a
  row (14-17) hitting the same `xdotool windowactivate` flakiness**:
  subsequent `Tab`/`Space` keystrokes didn't register, so clicking the
  hyperlink and the "Remove row 1" button live weren't confirmed this
  way. Both were instead confirmed via a standalone C++ spike:
  `emit`ting `QLabel::linkActivated` directly reached the connected
  callback with the correct link text, and removing row 1 from a
  3-item list correctly left count 2.
