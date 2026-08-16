' Phase 7 combined demo: a QTimer-driven counter label (styled via
' WidgetSetStyleSheet), clipboard copy/paste, and three QInputDialog
' variants (text/int/item) - all wired to a shared status label.
'
' Qt6 needs QT_QPA_PLATFORM=xcb explicitly set in this environment - see
' hello_window.bas's own top comment / this package's README.

#include once "qt6.iface.bas"

DIM gStatus AS Label
DIM gCounter AS Label
DIM gCounterValue AS INTEGER
DIM gClip AS Clipboard
DIM gTimer AS QTimer
DIM win AS MainWindow
DIM app AS Application

SUB OnTimerTick(userData AS ANY PTR)
    gCounterValue = gCounterValue + 1
    CALL LabelSetText(gCounter, "Count: " & Str(gCounterValue))
END SUB

SUB OnCopyClicked(userData AS ANY PTR)
    CALL ClipboardSetText(gClip, "Count: " & Str(gCounterValue))
    CALL LabelSetText(gStatus, "copied to clipboard")
END SUB

SUB OnPasteClicked(userData AS ANY PTR)
    DIM raw AS ANY PTR
    raw = ClipboardGetText(gClip)
    DIM z AS ZSTRING
    z = raw
    DIM s AS STRING
    s = z
    CALL FreeQtString(raw)
    CALL LabelSetText(gStatus, "clipboard: " & s)
END SUB

SUB OnRenameClicked(userData AS ANY PTR)
    DIM noParent AS QtWidget
    DIM valid AS INTEGER
    DIM raw AS ANY PTR
    raw = InputDialogGetText(noParent, "Rename", "New label:", "Count", valid)
    DIM z AS ZSTRING
    z = raw
    DIM s AS STRING
    s = z
    CALL FreeQtString(raw)
    IF valid <> 0 THEN
        CALL LabelSetText(gStatus, "renamed: " & s)
    ELSE
        CALL LabelSetText(gStatus, "rename: cancelled")
    END IF
END SUB

SUB OnSetIntervalClicked(userData AS ANY PTR)
    DIM noParent AS QtWidget
    DIM value AS INTEGER
    DIM valid AS INTEGER
    CALL InputDialogGetInt(noParent, "Interval", "Milliseconds:", 1000, 100, 5000, value, valid)
    IF valid <> 0 THEN
        CALL QTimerSetInterval(gTimer, value)
        CALL QTimerStart(gTimer)
        CALL LabelSetText(gStatus, "interval: " & Str(value))
    ELSE
        CALL LabelSetText(gStatus, "interval: cancelled")
    END IF
END SUB

SUB OnPickThemeClicked(userData AS ANY PTR)
    DIM items AS StringList
    items = NewStringList()
    CALL StringListAdd(items, "Red")
    CALL StringListAdd(items, "Green")
    CALL StringListAdd(items, "Blue")

    DIM noParent AS QtWidget
    DIM valid AS INTEGER
    DIM raw AS ANY PTR
    raw = InputDialogGetItem(noParent, "Theme", "Pick a color:", items, 0, 0, valid)
    DIM z AS ZSTRING
    z = raw
    DIM s AS STRING
    s = z
    CALL FreeQtString(raw)

    IF valid <> 0 THEN
        IF s = "Red" THEN
            CALL WidgetSetStyleSheet(gCounter, "background-color: #fdd; font-size: 18px; padding: 8px;")
        ELSEIF s = "Green" THEN
            CALL WidgetSetStyleSheet(gCounter, "background-color: #dfd; font-size: 18px; padding: 8px;")
        ELSEIF s = "Blue" THEN
            CALL WidgetSetStyleSheet(gCounter, "background-color: #ddf; font-size: 18px; padding: 8px;")
        END IF
        CALL LabelSetText(gStatus, "theme: " & s)
    ELSE
        CALL LabelSetText(gStatus, "theme: cancelled")
    END IF
END SUB

app = NewApplication("phase7_demo")
gClip = ApplicationClipboard(app)

win = NewMainWindow()
CALL WidgetSetWindowTitle(win, "eb-qt6 Phase 7 demo")
CALL WidgetResize(win, 380, 320)

DIM central AS QtWidget
central = NewWidget()
DIM mainLayout AS BoxLayout
mainLayout = NewVBoxLayout()

gCounterValue = 0
gCounter = NewLabel("Count: 0")
CALL WidgetSetStyleSheet(gCounter, "background-color: #fdd; font-size: 18px; padding: 8px;")
CALL BoxLayoutAddWidget(mainLayout, gCounter)

gTimer = NewQTimer(central)
CALL QTimerSetInterval(gTimer, 1000)
CALL QTimerConnectTimeout(gTimer, @OnTimerTick, 0)
CALL QTimerStart(gTimer)

DIM copyButton AS Button
copyButton = NewButton("Copy Count")
CALL ButtonConnectClicked(copyButton, @OnCopyClicked, 0)
CALL BoxLayoutAddWidget(mainLayout, copyButton)

DIM pasteButton AS Button
pasteButton = NewButton("Paste Clipboard")
CALL ButtonConnectClicked(pasteButton, @OnPasteClicked, 0)
CALL BoxLayoutAddWidget(mainLayout, pasteButton)

DIM renameButton AS Button
renameButton = NewButton("Rename...")
CALL ButtonConnectClicked(renameButton, @OnRenameClicked, 0)
CALL BoxLayoutAddWidget(mainLayout, renameButton)

DIM intervalButton AS Button
intervalButton = NewButton("Set Interval...")
CALL ButtonConnectClicked(intervalButton, @OnSetIntervalClicked, 0)
CALL BoxLayoutAddWidget(mainLayout, intervalButton)

DIM themeButton AS Button
themeButton = NewButton("Pick Theme...")
CALL ButtonConnectClicked(themeButton, @OnPickThemeClicked, 0)
CALL BoxLayoutAddWidget(mainLayout, themeButton)

gStatus = NewLabel("(nothing yet)")
CALL BoxLayoutAddWidget(mainLayout, gStatus)

CALL WidgetSetLayout(central, mainLayout)
CALL MainWindowSetCentralWidget(win, central)
CALL WidgetShow(win)

CALL ApplicationExec(app)
