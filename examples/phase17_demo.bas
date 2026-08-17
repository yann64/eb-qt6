' Phase 17: QPixmap (a reusable, loaded-once image handle), QLabel
' hyperlinks, QListWidget row removal, and QSettings Contains/Remove.
'
' The same Pixmap handle is drawn on a PainterWidget AND set on a
' QLabel - proving the load-once/reuse-everywhere story actually works,
' not just compiles.
'
' Qt6 needs QT_QPA_PLATFORM=xcb explicitly set in this environment - see
' hello_window.bas's own top comment / this package's README.

#include once "qt6.iface.bas"

DIM gStatus AS Label
DIM gList AS ListWidget
DIM gPixmap AS Pixmap

SUB OnPaint(userData AS ANY PTR, painter AS ANY PTR)
    CALL PainterFillRect(painter, 0, 0, 300, 200, 240, 240, 240)
    CALL PainterDrawPixmapHandle(painter, 10, 10, gPixmap)
END SUB

SUB OnLinkActivated(userData AS ANY PTR, link AS ZSTRING)
    DIM s AS STRING
    s = link
    CALL LabelSetText(gStatus, "link clicked: " & s)
END SUB

SUB OnRemoveRowClicked(userData AS ANY PTR)
    CALL ListWidgetRemoveRow(gList, 1)
    CALL LabelSetText(gStatus, "removed row 1, count now: " & Str(ListWidgetCount(gList)))
END SUB

DIM app AS Application
app = NewApplication("phase17_demo")

DIM win AS MainWindow
win = NewMainWindow()
CALL WidgetSetWindowTitle(win, "eb-qt6 Phase 17 demo")
CALL WidgetResize(win, 420, 480)

' --- QSettings Contains/Remove, no interaction needed ---
DIM appSettings AS Settings
appSettings = NewSettings("eb-qt6", "phase17_demo", win)
CALL SettingsSetString(appSettings, "greeting", "hello")
DIM hadBefore AS INTEGER
hadBefore = SettingsContains(appSettings, "greeting")
CALL SettingsRemove(appSettings, "greeting")
DIM hasAfter AS INTEGER
hasAfter = SettingsContains(appSettings, "greeting")
DIM appSettingsSummary AS STRING
appSettingsSummary = "appSettings: contains-before=" & Str(hadBefore) & " contains-after=" & Str(hasAfter)

DIM central AS QtWidget
central = NewWidget()
DIM mainLayout AS BoxLayout
mainLayout = NewVBoxLayout()

gStatus = NewLabel(appSettingsSummary)
CALL BoxLayoutAddWidget(mainLayout, gStatus)

' --- QPixmap: load once, reuse on both a custom-paint widget and a label ---
gPixmap = NewPixmapFromFile("assets/sample.png")

DIM canvas AS PainterWidget
canvas = NewPainterWidget()
CALL WidgetSetMinimumSize(canvas, 300, 200)
CALL PainterWidgetConnectPaint(canvas, @OnPaint, 0)
CALL BoxLayoutAddWidget(mainLayout, canvas)

DIM pixLabel AS Label
pixLabel = NewLabel("")
CALL LabelSetPixmap(pixLabel, gPixmap)
CALL BoxLayoutAddWidget(mainLayout, pixLabel)

' --- QLabel hyperlink ---
DIM linkLabel AS Label
linkLabel = NewLabel("<a href=""https://example.com"">Click this link</a>")
CALL LabelSetOpenExternalLinks(linkLabel, 0)
CALL LabelConnectLinkActivated(linkLabel, @OnLinkActivated, 0)
CALL BoxLayoutAddWidget(mainLayout, linkLabel)

' --- ListWidget row removal ---
gList = NewListWidget()
CALL ListWidgetAddItem(gList, "Alpha")
CALL ListWidgetAddItem(gList, "Beta")
CALL ListWidgetAddItem(gList, "Gamma")
CALL BoxLayoutAddWidget(mainLayout, gList)

DIM removeBtn AS Button
removeBtn = NewButton("Remove row 1 (Beta)")
CALL ButtonConnectClicked(removeBtn, @OnRemoveRowClicked, 0)
CALL BoxLayoutAddWidget(mainLayout, removeBtn)

CALL WidgetSetLayout(central, mainLayout)
CALL MainWindowSetCentralWidget(win, central)
CALL WidgetShow(win)

CALL ApplicationExec(app)
