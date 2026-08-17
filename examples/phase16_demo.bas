' Phase 16: QNetworkAccessManager/QNetworkReply (HTTP GET), item-widget
' Count/Clear housekeeping (ListWidget/ComboBox/TreeWidget),
' QMessageBox::critical, and a QRegularExpressionValidator on a
' QLineEdit.
'
' The HTTP GET needs no GUI interaction to verify at all - it runs at
' startup, before the window even shows, and reports the real response
' status code into the status label.
'
' Qt6 needs QT_QPA_PLATFORM=xcb explicitly set in this environment - see
' hello_window.bas's own top comment / this package's README.

#include once "qt6.iface.bas"

DIM gStatus AS Label
DIM gList AS ListWidget

SUB OnClearClicked(userData AS ANY PTR)
    CALL ListWidgetClear(gList)
    CALL LabelSetText(gStatus, "list cleared, count now: " & Str(ListWidgetCount(gList)))
END SUB

SUB OnCriticalClicked(userData AS ANY PTR)
    DIM noParent AS QtWidget
    CALL MessageBoxCritical(noParent, "Simulated error", "This is a QMessageBox::critical test.")
    CALL LabelSetText(gStatus, "critical dialog closed")
END SUB

DIM app AS Application
app = NewApplication("phase16_demo")

DIM win AS MainWindow
win = NewMainWindow()
CALL WidgetSetWindowTitle(win, "eb-qt6 Phase 16 demo")
CALL WidgetResize(win, 460, 380)

' --- QNetworkAccessManager: a real HTTP GET, no interaction needed ---
DIM manager AS NetworkManager
manager = NewNetworkManager(win)
DIM reply AS NetworkReply
reply = NetworkManagerGet(manager, "https://example.com")
CALL NetworkReplyWaitForFinished(reply, 10000)
DIM netStatus AS STRING
IF NetworkReplyHasError(reply) THEN
    DIM errRaw AS ANY PTR
    errRaw = NetworkReplyErrorString(reply)
    DIM errZ AS ZSTRING
    errZ = errRaw
    DIM errS AS STRING
    errS = errZ
    netStatus = "network error: " & errS
    CALL FreeQtString(errRaw)
ELSE
    netStatus = "HTTP " & Str(NetworkReplyStatusCode(reply))
END IF
CALL NetworkReplyDeleteLater(reply)

DIM central AS QtWidget
central = NewWidget()
DIM mainLayout AS BoxLayout
mainLayout = NewVBoxLayout()

gStatus = NewLabel("GET https://example.com -> " & netStatus)
CALL BoxLayoutAddWidget(mainLayout, gStatus)

' --- Item-widget Count/Clear housekeeping ---
gList = NewListWidget()
CALL ListWidgetAddItem(gList, "Alpha")
CALL ListWidgetAddItem(gList, "Beta")
CALL ListWidgetAddItem(gList, "Gamma")
CALL BoxLayoutAddWidget(mainLayout, gList)

DIM clearBtn AS Button
clearBtn = NewButton("Clear list (count: " & Str(ListWidgetCount(gList)) & ")")
CALL ButtonConnectClicked(clearBtn, @OnClearClicked, 0)
CALL BoxLayoutAddWidget(mainLayout, clearBtn)

' --- QMessageBox::critical ---
DIM criticalBtn AS Button
criticalBtn = NewButton("Show critical dialog")
CALL ButtonConnectClicked(criticalBtn, @OnCriticalClicked, 0)
CALL BoxLayoutAddWidget(mainLayout, criticalBtn)

' --- QRegularExpressionValidator - simple email-shaped pattern ---
DIM emailEdit AS LineEdit
emailEdit = NewLineEdit("")
CALL LineEditSetRegexValidator(emailEdit, "^[A-Za-z0-9._%+-]*@?[A-Za-z0-9.-]*$")
CALL BoxLayoutAddWidget(mainLayout, emailEdit)

CALL WidgetSetLayout(central, mainLayout)
CALL MainWindowSetCentralWidget(win, central)
CALL WidgetShow(win)

CALL ApplicationExec(app)
