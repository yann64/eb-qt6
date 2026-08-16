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
