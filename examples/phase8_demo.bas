' Phase 8 combined demo: a validated age field (QIntValidator), a city
' field with autocomplete (QCompleter), a Ctrl+Q QShortcut that quits,
' and QSettings persisting the age across runs - all wired to a shared
' status label.
'
' Qt6 needs QT_QPA_PLATFORM=xcb explicitly set in this environment - see
' hello_window.bas's own top comment / this package's README.

#include once "qt6.iface.bas"

DIM gStatus AS Label
DIM gAgeEdit AS LineEdit
DIM gSettings AS Settings
DIM win AS MainWindow
DIM app AS Application

SUB OnQuitShortcut(userData AS ANY PTR)
    CALL ApplicationQuit(app)
END SUB

SUB OnSaveClicked(userData AS ANY PTR)
    DIM raw AS ANY PTR
    raw = LineEditGetText(gAgeEdit)
    DIM z AS ZSTRING
    z = raw
    DIM s AS STRING
    s = z
    CALL FreeQtString(raw)
    CALL SettingsSetString(gSettings, "age", s)
    CALL SettingsSync(gSettings)
    CALL LabelSetText(gStatus, "saved age: " & s)
END SUB

SUB OnAgeChanged(userData AS ANY PTR, text AS ZSTRING)
    DIM s AS STRING
    s = text
    CALL LabelSetText(gStatus, "age (validated): " & s)
END SUB

app = NewApplication("phase8_demo")

win = NewMainWindow()
CALL WidgetSetWindowTitle(win, "eb-qt6 Phase 8 demo")
CALL WidgetResize(win, 380, 260)

gSettings = NewSettings("eb-qt6", "phase8_demo", win)

DIM quitShortcut AS Shortcut
quitShortcut = NewShortcut("Ctrl+Q", win)
CALL ShortcutConnectActivated(quitShortcut, @OnQuitShortcut, 0)

DIM central AS QtWidget
central = NewWidget()
DIM form AS FormLayout
form = NewFormLayout()

' Constructed before LineEditSetText below - QLineEdit::setText fires
' textChanged synchronously (just like QTabWidget/QTreeWidget/
' QStackedWidget firing their own "current changed" signals as a side
' effect of setup, see the README's own "Phase 3 widgets" section),
' and OnAgeChanged touches gStatus - it must already exist by then.
gStatus = NewLabel("(nothing yet)")

gAgeEdit = NewLineEdit("0")
CALL LineEditSetIntValidator(gAgeEdit, 0, 120)
CALL LineEditConnectTextChanged(gAgeEdit, @OnAgeChanged, 0)
DIM raw AS ANY PTR
raw = SettingsGetString(gSettings, "age", "0")
DIM z AS ZSTRING
z = raw
DIM savedAge AS STRING
savedAge = z
CALL FreeQtString(raw)
CALL LineEditSetText(gAgeEdit, savedAge)
CALL FormLayoutAddRow(form, "Age (0-120):", gAgeEdit)

DIM cityEdit AS LineEdit
cityEdit = NewLineEdit("")
DIM items AS StringList
items = NewStringList()
CALL StringListAdd(items, "Paris")
CALL StringListAdd(items, "London")
CALL StringListAdd(items, "Berlin")
CALL StringListAdd(items, "Madrid")
DIM cityCompleter AS Completer
cityCompleter = NewCompleter(items)
CALL LineEditSetCompleter(cityEdit, cityCompleter)
CALL FormLayoutAddRow(form, "City:", cityEdit)

DIM formHolder AS QtWidget
formHolder = NewWidget()
CALL WidgetSetLayout(formHolder, form)

DIM mainLayout AS BoxLayout
mainLayout = NewVBoxLayout()
CALL BoxLayoutAddWidget(mainLayout, formHolder)

DIM saveButton AS Button
saveButton = NewButton("Save Age (persists via QSettings)")
CALL ButtonConnectClicked(saveButton, @OnSaveClicked, 0)
CALL BoxLayoutAddWidget(mainLayout, saveButton)

DIM hintLabel AS Label
hintLabel = NewLabel("Press Ctrl+Q to quit.")
CALL BoxLayoutAddWidget(mainLayout, hintLabel)

CALL LabelSetText(gStatus, "loaded age: " & savedAge)
CALL BoxLayoutAddWidget(mainLayout, gStatus)

CALL WidgetSetLayout(central, mainLayout)
CALL MainWindowSetCentralWidget(win, central)
CALL WidgetShow(win)

CALL ApplicationExec(app)
