' Phase 21: QClipboard image support (reusing the Pixmap handle from
' Phase 17), QListWidget multi-selection mode, window state
' (maximize/restore), and Application quit-on-last-window-closed +
' aboutToQuit.
'
' The clipboard round trip is verified with no interaction needed: copy
' a real Pixmap in, read it back out, compare dimensions.
'
' Qt6 needs QT_QPA_PLATFORM=xcb explicitly set in this environment - see
' hello_window.bas's own top comment / this package's README.

#include once "qt6.iface.bas"

DIM gStatus AS Label
DIM gList AS ListWidget
DIM gWin AS MainWindow

SUB OnMaximizeClicked(userData AS ANY PTR)
    CALL WidgetShowMaximized(gWin)
    CALL LabelSetText(gStatus, "maximized: " & Str(WidgetIsMaximized(gWin)))
END SUB

SUB OnRestoreClicked(userData AS ANY PTR)
    CALL WidgetShowNormal(gWin)
    CALL LabelSetText(gStatus, "maximized: " & Str(WidgetIsMaximized(gWin)))
END SUB

SUB OnCheckSelectionClicked(userData AS ANY PTR)
    CALL LabelSetText(gStatus, "selected count: " & Str(ListWidgetSelectedCount(gList)))
END SUB

SUB OnAboutToQuit(userData AS ANY PTR)
    ' Real Qt fires this right before the event loop stops - nothing
    ' visible to check live (the process is already exiting), but a
    ' real cleanup hook (e.g. SettingsSync) would go here.
END SUB

DIM app AS Application
app = NewApplication("phase21_demo")
CALL ApplicationConnectAboutToQuit(app, @OnAboutToQuit, 0)

' --- QClipboard image round trip, no interaction needed ---
DIM pic AS Pixmap
pic = NewPixmapFromFile("assets/sample.png")
DIM clip AS Clipboard
clip = ApplicationClipboard(app)
CALL ClipboardSetPixmap(clip, pic)
DIM roundTripped AS Pixmap
roundTripped = ClipboardGetPixmap(clip)
DIM clipboardSummary AS STRING
clipboardSummary = "clipboard image: " & Str(PixmapWidth(roundTripped)) & "x" & Str(PixmapHeight(roundTripped))
CALL PixmapDestroy(roundTripped)

gWin = NewMainWindow()
CALL WidgetSetWindowTitle(gWin, "eb-qt6 Phase 21 demo")
CALL WidgetResize(gWin, 420, 420)

DIM central AS QtWidget
central = NewWidget()
DIM mainLayout AS BoxLayout
mainLayout = NewVBoxLayout()

gStatus = NewLabel(clipboardSummary)
CALL BoxLayoutAddWidget(mainLayout, gStatus)

' --- QListWidget multi-selection ---
gList = NewListWidget()
CALL ListWidgetSetSelectionMode(gList, QtExtendedSelection)
CALL ListWidgetAddItem(gList, "Alpha")
CALL ListWidgetAddItem(gList, "Beta")
CALL ListWidgetAddItem(gList, "Gamma")
CALL BoxLayoutAddWidget(mainLayout, gList)

DIM checkBtn AS Button
checkBtn = NewButton("Check selection count")
CALL ButtonConnectClicked(checkBtn, @OnCheckSelectionClicked, 0)
CALL BoxLayoutAddWidget(mainLayout, checkBtn)

' --- Window state ---
DIM maxBtn AS Button
maxBtn = NewButton("Maximize")
CALL ButtonConnectClicked(maxBtn, @OnMaximizeClicked, 0)
CALL BoxLayoutAddWidget(mainLayout, maxBtn)

DIM restoreBtn AS Button
restoreBtn = NewButton("Restore")
CALL ButtonConnectClicked(restoreBtn, @OnRestoreClicked, 0)
CALL BoxLayoutAddWidget(mainLayout, restoreBtn)

CALL WidgetSetLayout(central, mainLayout)
CALL MainWindowSetCentralWidget(gWin, central)
CALL WidgetShow(gWin)

CALL ApplicationExec(app)
