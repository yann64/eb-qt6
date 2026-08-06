' Phase 5 combined demo: a stacked widget (two pages, Next/Back
' buttons), a dock widget with a dial synced to an LCD number, and
' buttons opening a color dialog and a font dialog - all wired to the
' window's own status bar.
'
' Qt6 needs QT_QPA_PLATFORM=xcb explicitly set in this environment - see
' hello_window.bas's own top comment / this package's README.

#include once "qt6.iface.bas"

DIM gStatus AS StatusBar
DIM gStack AS StackedWidget
DIM gLCD AS LCDNumber
DIM win AS MainWindow
DIM app AS Application

SUB OnStackChanged(userData AS ANY PTR, index AS INTEGER)
    CALL StatusBarShowMessage(gStatus, "page: " & Str(index), 0)
END SUB

SUB OnNextClicked(userData AS ANY PTR)
    CALL StackedWidgetSetCurrentIndex(gStack, 1)
END SUB

SUB OnBackClicked(userData AS ANY PTR)
    CALL StackedWidgetSetCurrentIndex(gStack, 0)
END SUB

SUB OnDialChanged(userData AS ANY PTR, value AS INTEGER)
    CALL LCDNumberDisplay(gLCD, value)
    CALL StatusBarShowMessage(gStatus, "dial: " & Str(value), 0)
END SUB

SUB OnColorClicked(userData AS ANY PTR)
    DIM r AS UBYTE
    DIM g AS UBYTE
    DIM b AS UBYTE
    DIM noParent AS QtWidget
    DIM picked AS INTEGER
    picked = ColorDialogGetColor(noParent, "Pick a Color", 255, 0, 0, r, g, b)
    IF picked <> 0 THEN
        CALL StatusBarShowMessage(gStatus, "color: " & Str(r) & "," & Str(g) & "," & Str(b), 0)
    ELSE
        CALL StatusBarShowMessage(gStatus, "color: cancelled", 0)
    END IF
END SUB

SUB OnFontClicked(userData AS ANY PTR)
    DIM noParent AS QtWidget
    DIM pointSize AS INTEGER
    DIM valid AS INTEGER
    DIM raw AS ANY PTR
    raw = FontDialogGetFont(noParent, pointSize, valid)
    DIM z AS ZSTRING
    z = raw
    DIM s AS STRING
    s = z
    CALL FreeQtString(raw)
    IF valid <> 0 THEN
        CALL StatusBarShowMessage(gStatus, "font: " & s & " " & Str(pointSize), 0)
    ELSE
        CALL StatusBarShowMessage(gStatus, "font: cancelled", 0)
    END IF
END SUB

app = NewApplication("phase5_demo")

win = NewMainWindow()
CALL WidgetSetWindowTitle(win, "eb-qt6 Phase 5 demo")
CALL WidgetResize(win, 480, 380)

' Constructed before any stack page is added - QStackedWidget fires
' currentChanged(0) synchronously as soon as its first page is added
' (same lesson as Phase 3's QTabWidget / Phase 4's QTreeWidget).
gStatus = MainWindowStatusBar(win)
CALL StatusBarShowMessage(gStatus, "ready", 0)

gStack = NewStackedWidget()
CALL StackedWidgetConnectCurrentChanged(gStack, @OnStackChanged, 0)

DIM page1 AS QtWidget
page1 = NewWidget()
DIM page1Layout AS BoxLayout
page1Layout = NewVBoxLayout()
DIM page1Label AS Label
page1Label = NewLabel("Page 1")
CALL BoxLayoutAddWidget(page1Layout, page1Label)
DIM nextButton AS Button
nextButton = NewButton("Next")
CALL ButtonConnectClicked(nextButton, @OnNextClicked, 0)
CALL BoxLayoutAddWidget(page1Layout, nextButton)
CALL WidgetSetLayout(page1, page1Layout)
CALL StackedWidgetAddWidget(gStack, page1)

DIM page2 AS QtWidget
page2 = NewWidget()
DIM page2Layout AS BoxLayout
page2Layout = NewVBoxLayout()
DIM page2Label AS Label
page2Label = NewLabel("Page 2")
CALL BoxLayoutAddWidget(page2Layout, page2Label)
DIM backButton AS Button
backButton = NewButton("Back")
CALL ButtonConnectClicked(backButton, @OnBackClicked, 0)
CALL BoxLayoutAddWidget(page2Layout, backButton)
DIM colorButton AS Button
colorButton = NewButton("Pick Color")
CALL ButtonConnectClicked(colorButton, @OnColorClicked, 0)
CALL BoxLayoutAddWidget(page2Layout, colorButton)
DIM fontButton AS Button
fontButton = NewButton("Pick Font")
CALL ButtonConnectClicked(fontButton, @OnFontClicked, 0)
CALL BoxLayoutAddWidget(page2Layout, fontButton)
CALL WidgetSetLayout(page2, page2Layout)
CALL StackedWidgetAddWidget(gStack, page2)

CALL MainWindowSetCentralWidget(win, gStack)

DIM dock AS DockWidget
dock = NewDockWidget("Controls")
DIM dockContent AS QtWidget
dockContent = NewWidget()
DIM dockLayout AS BoxLayout
dockLayout = NewVBoxLayout()

DIM controlDial AS Dial
controlDial = NewDial()
CALL DialSetRange(controlDial, 0, 100)
CALL DialConnectValueChanged(controlDial, @OnDialChanged, 0)
CALL BoxLayoutAddWidget(dockLayout, controlDial)

gLCD = NewLCDNumber()
CALL LCDNumberDisplay(gLCD, 0)
CALL BoxLayoutAddWidget(dockLayout, gLCD)

CALL WidgetSetLayout(dockContent, dockLayout)
CALL DockWidgetSetWidget(dock, dockContent)
CALL MainWindowAddDockWidget(win, QtLeftDockWidgetArea, dock)

CALL WidgetShow(win)
CALL ApplicationExec(app)
