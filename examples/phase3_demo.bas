' Phase 3 combined demo: a tab widget (one tab with a synced slider +
' spin box inside a group box, another with a list widget + table
' widget), plus buttons exercising a custom QDialog, QMessageBox, and
' QFileDialog - all wired to a single status label.
'
' Qt6 needs QT_QPA_PLATFORM=xcb explicitly set in this environment - see
' hello_window.bas's own top comment / this package's README.

#include once "qt6.iface.bas"

DIM gStatus AS Label
DIM gList AS ListWidget
DIM gTable AS TableWidget
DIM gSlider AS Slider
DIM gSpinBox AS SpinBox
DIM gDialog AS Dialog
DIM win AS MainWindow
DIM app AS Application

SUB OnSliderChanged(userData AS ANY PTR, value AS INTEGER)
    CALL SpinBoxSetValue(gSpinBox, value)
END SUB

SUB OnSpinChanged(userData AS ANY PTR, value AS INTEGER)
    CALL SliderSetValue(gSlider, value)
    CALL LabelSetText(gStatus, "range: " & Str(value))
END SUB

SUB OnTabChanged(userData AS ANY PTR, index AS INTEGER)
    CALL LabelSetText(gStatus, "tab: " & Str(index))
END SUB

SUB OnListRowChanged(userData AS ANY PTR, row AS INTEGER)
    DIM raw AS ANY PTR
    raw = ListWidgetCurrentText(gList)
    DIM z AS ZSTRING
    z = raw
    DIM s AS STRING
    s = z
    CALL FreeQtString(raw)
    CALL LabelSetText(gStatus, "list: " & s)
END SUB

SUB OnTableCellClicked(userData AS ANY PTR, row AS INTEGER, col AS INTEGER)
    DIM raw AS ANY PTR
    raw = TableWidgetItemText(gTable, row, col)
    DIM z AS ZSTRING
    z = raw
    DIM s AS STRING
    s = z
    CALL FreeQtString(raw)
    CALL LabelSetText(gStatus, "cell (" & Str(row) & "," & Str(col) & "): " & s)
END SUB

SUB OnDialogButtonClicked(userData AS ANY PTR)
    CALL DialogAccept(gDialog)
END SUB

SUB OnShowDialogClicked(userData AS ANY PTR)
    DIM result AS INTEGER
    result = DialogExec(gDialog)
    IF result <> 0 THEN
        CALL LabelSetText(gStatus, "dialog: accepted")
    ELSE
        CALL LabelSetText(gStatus, "dialog: rejected")
    END IF
END SUB

SUB OnMessageBoxClicked(userData AS ANY PTR)
    DIM yes AS INTEGER
    yes = MessageBoxQuestion(win, "Confirm", "Continue?")
    IF yes <> 0 THEN
        CALL LabelSetText(gStatus, "question: yes")
    ELSE
        CALL LabelSetText(gStatus, "question: no")
    END IF
END SUB

SUB OnFileDialogClicked(userData AS ANY PTR)
    DIM raw AS ANY PTR
    raw = FileDialogGetOpenFileName(win, "Open File", "", "All Files (*)")
    DIM z AS ZSTRING
    z = raw
    DIM s AS STRING
    s = z
    CALL FreeQtString(raw)
    IF LEN(s) = 0 THEN
        CALL LabelSetText(gStatus, "file: (cancelled)")
    ELSE
        CALL LabelSetText(gStatus, "file: " & s)
    END IF
END SUB

app = NewApplication("phase3_demo")

win = NewMainWindow()
CALL WidgetSetWindowTitle(win, "eb-qt6 Phase 3 demo")
CALL WidgetResize(win, 420, 380)

DIM central AS QtWidget
central = NewWidget()
DIM mainLayout AS BoxLayout
mainLayout = NewVBoxLayout()

' Constructed early, before any tab is added below - QTabWidget fires
' currentChanged(0) synchronously as soon as its first tab is inserted
' (it auto-selects it), so OnTabChanged must have a real gStatus handle
' to touch by then, not a not-yet-constructed one.
gStatus = NewLabel("(nothing yet)")

DIM tabs AS TabWidget
tabs = NewTabWidget()
CALL TabWidgetConnectCurrentChanged(tabs, @OnTabChanged, 0)

' Tab 1: a group box with a synced slider + spin box.
DIM controlsTab AS QtWidget
controlsTab = NewWidget()
DIM controlsLayout AS BoxLayout
controlsLayout = NewVBoxLayout()

DIM rangeGroup AS GroupBox
rangeGroup = NewGroupBox("Range")
DIM rangeLayout AS BoxLayout
rangeLayout = NewHBoxLayout()

gSlider = NewSlider(QtHorizontal)
CALL SliderSetRange(gSlider, 0, 100)
CALL SliderConnectValueChanged(gSlider, @OnSliderChanged, 0)
CALL BoxLayoutAddWidget(rangeLayout, gSlider)

gSpinBox = NewSpinBox()
CALL SpinBoxSetRange(gSpinBox, 0, 100)
CALL SpinBoxConnectValueChanged(gSpinBox, @OnSpinChanged, 0)
CALL BoxLayoutAddWidget(rangeLayout, gSpinBox)

CALL WidgetSetLayout(rangeGroup, rangeLayout)
CALL BoxLayoutAddWidget(controlsLayout, rangeGroup)
CALL WidgetSetLayout(controlsTab, controlsLayout)
CALL TabWidgetAddTab(tabs, controlsTab, "Controls")

' Tab 2: a list widget + table widget.
DIM listsTab AS QtWidget
listsTab = NewWidget()
DIM listsLayout AS BoxLayout
listsLayout = NewVBoxLayout()

gList = NewListWidget()
CALL ListWidgetAddItem(gList, "Alpha")
CALL ListWidgetAddItem(gList, "Beta")
CALL ListWidgetAddItem(gList, "Gamma")
CALL ListWidgetConnectCurrentRowChanged(gList, @OnListRowChanged, 0)
CALL BoxLayoutAddWidget(listsLayout, gList)

gTable = NewTableWidget()
CALL TableWidgetSetRowCount(gTable, 2)
CALL TableWidgetSetColumnCount(gTable, 2)
CALL TableWidgetSetItemText(gTable, 0, 0, "r0c0")
CALL TableWidgetSetItemText(gTable, 0, 1, "r0c1")
CALL TableWidgetSetItemText(gTable, 1, 0, "r1c0")
CALL TableWidgetSetItemText(gTable, 1, 1, "r1c1")
CALL TableWidgetConnectCellClicked(gTable, @OnTableCellClicked, 0)
CALL BoxLayoutAddWidget(listsLayout, gTable)

CALL WidgetSetLayout(listsTab, listsLayout)
CALL TabWidgetAddTab(tabs, listsTab, "Lists")

CALL BoxLayoutAddWidget(mainLayout, tabs)

' A custom QDialog, shown via a button - the dialog's own button calls
' DialogAccept.
gDialog = NewDialog()
CALL WidgetSetWindowTitle(gDialog, "Custom Dialog")
DIM dialogLayout AS BoxLayout
dialogLayout = NewVBoxLayout()
DIM dialogLabel AS Label
dialogLabel = NewLabel("Click OK to accept.")
CALL BoxLayoutAddWidget(dialogLayout, dialogLabel)
DIM dialogButton AS Button
dialogButton = NewButton("OK")
CALL ButtonConnectClicked(dialogButton, @OnDialogButtonClicked, 0)
CALL BoxLayoutAddWidget(dialogLayout, dialogButton)
CALL WidgetSetLayout(gDialog, dialogLayout)

DIM showDialogButton AS Button
showDialogButton = NewButton("Custom Dialog")
CALL ButtonConnectClicked(showDialogButton, @OnShowDialogClicked, 0)
CALL BoxLayoutAddWidget(mainLayout, showDialogButton)

DIM messageBoxButton AS Button
messageBoxButton = NewButton("Message Box")
CALL ButtonConnectClicked(messageBoxButton, @OnMessageBoxClicked, 0)
CALL BoxLayoutAddWidget(mainLayout, messageBoxButton)

DIM fileDialogButton AS Button
fileDialogButton = NewButton("Choose File")
CALL ButtonConnectClicked(fileDialogButton, @OnFileDialogClicked, 0)
CALL BoxLayoutAddWidget(mainLayout, fileDialogButton)

CALL BoxLayoutAddWidget(mainLayout, gStatus)

CALL WidgetSetLayout(central, mainLayout)
CALL MainWindowSetCentralWidget(win, central)
CALL WidgetShow(win)

CALL ApplicationExec(app)
