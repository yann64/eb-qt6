' Phase 6 combined demo: a form layout (date edit + time edit), a grid
' layout holding a calendar widget and two cross-container-exclusive
' radio buttons wired via QButtonGroup, and a system tray icon with a
' Quit action - all wired to a shared status label.
'
' Qt6 needs QT_QPA_PLATFORM=xcb explicitly set in this environment - see
' hello_window.bas's own top comment / this package's README.

#include once "qt6.iface.bas"

DIM gStatus AS Label
DIM gDateEdit AS DateEdit
DIM gTimeEdit AS TimeEdit
DIM app AS Application

SUB OnCalendarSelectionChanged(userData AS ANY PTR, year AS INTEGER, month AS INTEGER, day AS INTEGER)
    CALL LabelSetText(gStatus, "calendar: " & Str(year) & "-" & Str(month) & "-" & Str(day))
END SUB

SUB OnRadioGroupClicked(userData AS ANY PTR, button AS ANY PTR)
    DIM wrapped AS AbstractButton
    wrapped = WrapAbstractButton(button)
    DIM raw AS ANY PTR
    raw = AbstractButtonGetText(wrapped)
    DIM z AS ZSTRING
    z = raw
    DIM s AS STRING
    s = z
    CALL FreeQtString(raw)
    CALL LabelSetText(gStatus, "radio: " & s)
END SUB

SUB OnDateSaveClicked(userData AS ANY PTR)
    DIM y AS INTEGER
    DIM m AS INTEGER
    DIM d AS INTEGER
    CALL DateEditGetDate(gDateEdit, y, m, d)
    DIM hh AS INTEGER
    DIM mi AS INTEGER
    DIM ss AS INTEGER
    CALL TimeEditGetTime(gTimeEdit, hh, mi, ss)
    CALL LabelSetText(gStatus, "saved: " & Str(y) & "-" & Str(m) & "-" & Str(d) & " " & Str(hh) & ":" & Str(mi))
END SUB

SUB OnTrayQuitClicked(userData AS ANY PTR)
    CALL ApplicationQuit(app)
END SUB

app = NewApplication("phase6_demo")

DIM win AS MainWindow
win = NewMainWindow()
CALL WidgetSetWindowTitle(win, "eb-qt6 Phase 6 demo")
CALL WidgetResize(win, 420, 420)

DIM central AS QtWidget
central = NewWidget()
DIM mainLayout AS BoxLayout
mainLayout = NewVBoxLayout()

' Form layout: date edit + time edit, each on a labeled row.
DIM dateForm AS QtWidget
dateForm = NewWidget()
DIM form AS FormLayout
form = NewFormLayout()

gDateEdit = NewDateEdit()
CALL DateEditSetDate(gDateEdit, 2026, 8, 6)
CALL FormLayoutAddRow(form, "Date:", gDateEdit)

gTimeEdit = NewTimeEdit()
CALL TimeEditSetTime(gTimeEdit, 12, 0, 0)
CALL FormLayoutAddRow(form, "Time:", gTimeEdit)

CALL WidgetSetLayout(dateForm, form)
CALL BoxLayoutAddWidget(mainLayout, dateForm)

DIM saveButton AS Button
saveButton = NewButton("Save Date/Time")
CALL ButtonConnectClicked(saveButton, @OnDateSaveClicked, 0)
CALL BoxLayoutAddWidget(mainLayout, saveButton)

' Grid layout: calendar widget spanning both columns, radio buttons
' below it.
DIM gridHolder AS QtWidget
gridHolder = NewWidget()
DIM grid AS GridLayout
grid = NewGridLayout()

DIM calendar AS CalendarWidget
calendar = NewCalendarWidget()
CALL CalendarWidgetConnectSelectionChanged(calendar, @OnCalendarSelectionChanged, 0)
CALL GridLayoutAddWidget(grid, calendar, 0, 0, 1, 2)

DIM radio1 AS RadioButton
radio1 = NewRadioButton("Weekly")
CALL GridLayoutAddWidget(grid, radio1, 1, 0, 1, 1)

DIM radio2 AS RadioButton
radio2 = NewRadioButton("Monthly")
CALL GridLayoutAddWidget(grid, radio2, 1, 1, 1, 1)

CALL WidgetSetLayout(gridHolder, grid)
CALL BoxLayoutAddWidget(mainLayout, gridHolder)

' QButtonGroup makes the two radios mutually exclusive even though they
' sit in different grid cells (still the same parent widget here, but
' the group also gives one shared `buttonClicked` handler instead of
' one per button).
DIM group AS ButtonGroup
group = NewButtonGroup(gridHolder)
CALL ButtonGroupAddButton(group, radio1)
CALL ButtonGroupAddButton(group, radio2)
CALL ButtonGroupConnectButtonClicked(group, @OnRadioGroupClicked, 0)

gStatus = NewLabel("(nothing yet)")
CALL BoxLayoutAddWidget(mainLayout, gStatus)

CALL WidgetSetLayout(central, mainLayout)
CALL MainWindowSetCentralWidget(win, central)
CALL WidgetShow(win)

' System tray icon with a context menu (Quit action).
DIM tray AS SystemTrayIcon
tray = NewSystemTrayIcon()
CALL SystemTrayIconSetIconFromTheme(tray, "dialog-information")
CALL SystemTrayIconSetTooltip(tray, "eb-qt6 Phase 6 demo")

DIM trayMenu AS Menu
trayMenu = NewMenu()
DIM quitAction AS Action
quitAction = MenuAddAction(trayMenu, "Quit")
CALL ActionConnectTriggered(quitAction, @OnTrayQuitClicked, 0)
CALL SystemTrayIconSetContextMenu(tray, trayMenu)
CALL SystemTrayIconShow(tray)

CALL ApplicationExec(app)

