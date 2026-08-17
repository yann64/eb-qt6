' Phase 18: QLineEdit placeholder text/max length, QTableWidget header
' labels + row/column counts, QComboBox InsertItem/ItemText random
' access, and primary-screen geometry (used to center the window).
'
' Qt6 needs QT_QPA_PLATFORM=xcb explicitly set in this environment - see
' hello_window.bas's own top comment / this package's README.

#include once "qt6.iface.bas"

DIM gStatus AS Label
DIM gCombo AS ComboBox

SUB OnCheckItemClicked(userData AS ANY PTR)
    DIM raw AS ANY PTR
    raw = ComboBoxItemText(gCombo, 1)
    DIM z AS ZSTRING
    z = raw
    DIM s AS STRING
    s = z
    CALL FreeQtString(raw)
    CALL LabelSetText(gStatus, "item at index 1: " & s)
END SUB

DIM app AS Application
app = NewApplication("phase18_demo")

DIM win AS MainWindow
win = NewMainWindow()
CALL WidgetSetWindowTitle(win, "eb-qt6 Phase 18 demo")
DIM winWidth AS INTEGER
DIM winHeight AS INTEGER
winWidth = 420
winHeight = 420
CALL WidgetResize(win, winWidth, winHeight)

' --- Center on the primary screen using its real available geometry ---
CALL WidgetMove(win, (PrimaryScreenWidth() - winWidth) \ 2, (PrimaryScreenHeight() - winHeight) \ 2)

DIM central AS QtWidget
central = NewWidget()
DIM mainLayout AS BoxLayout
mainLayout = NewVBoxLayout()

gStatus = NewLabel("screen: " & Str(PrimaryScreenWidth()) & "x" & Str(PrimaryScreenHeight()))
CALL BoxLayoutAddWidget(mainLayout, gStatus)

' --- QLineEdit placeholder text + max length ---
DIM nameEdit AS LineEdit
nameEdit = NewLineEdit("")
CALL LineEditSetPlaceholderText(nameEdit, "Enter your name (max 10 chars)")
CALL LineEditSetMaxLength(nameEdit, 10)
CALL BoxLayoutAddWidget(mainLayout, nameEdit)

' --- QTableWidget with real column headers ---
DIM table AS TableWidget
table = NewTableWidget()
CALL TableWidgetSetRowCount(table, 2)
CALL TableWidgetSetColumnCount(table, 2)
DIM headers AS StringList
headers = NewStringList()
CALL StringListAdd(headers, "Name")
CALL StringListAdd(headers, "Score")
CALL TableWidgetSetHorizontalHeaderLabels(table, headers)
CALL TableWidgetSetItemText(table, 0, 0, "Alpha")
CALL TableWidgetSetItemText(table, 0, 1, "10")
CALL TableWidgetSetItemText(table, 1, 0, "Beta")
CALL TableWidgetSetItemText(table, 1, 1, "20")
CALL BoxLayoutAddWidget(mainLayout, table)

' --- QComboBox InsertItem/ItemText random access ---
gCombo = NewComboBox()
CALL ComboBoxAddItem(gCombo, "Alpha")
CALL ComboBoxAddItem(gCombo, "Gamma")
CALL ComboBoxInsertItem(gCombo, 1, "Beta")
CALL BoxLayoutAddWidget(mainLayout, gCombo)

DIM checkBtn AS Button
checkBtn = NewButton("Check item at index 1")
CALL ButtonConnectClicked(checkBtn, @OnCheckItemClicked, 0)
CALL BoxLayoutAddWidget(mainLayout, checkBtn)

CALL WidgetSetLayout(central, mainLayout)
CALL MainWindowSetCentralWidget(win, central)
CALL WidgetShow(win)

CALL ApplicationExec(app)
