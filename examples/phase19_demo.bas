' Phase 19: QSyntaxHighlighter (rule-based), QTextEdit Clear/Undo/Redo,
' QTableWidget row removal + CurrentRow/CurrentColumn, and QLineEdit
' SelectAll/Clear.
'
' Qt6 needs QT_QPA_PLATFORM=xcb explicitly set in this environment - see
' hello_window.bas's own top comment / this package's README.

#include once "qt6.iface.bas"

DIM gStatus AS Label
DIM gTable AS TableWidget
DIM gEdit AS LineEdit

SUB OnRemoveRowClicked(userData AS ANY PTR)
    CALL TableWidgetRemoveRow(gTable, 0)
    CALL LabelSetText(gStatus, "removed row 0, rows now: " & Str(TableWidgetRowCount(gTable)))
END SUB

SUB OnSelectAllClicked(userData AS ANY PTR)
    CALL LineEditSelectAll(gEdit)
    CALL LabelSetText(gStatus, "selected all text in the field")
END SUB

DIM app AS Application
app = NewApplication("phase19_demo")

DIM win AS MainWindow
win = NewMainWindow()
CALL WidgetSetWindowTitle(win, "eb-qt6 Phase 19 demo")
CALL WidgetResize(win, 460, 520)

DIM central AS QtWidget
central = NewWidget()
DIM mainLayout AS BoxLayout
mainLayout = NewVBoxLayout()

gStatus = NewLabel("(nothing done yet)")
CALL BoxLayoutAddWidget(mainLayout, gStatus)

' --- QSyntaxHighlighter: a tiny eBasic-flavored rule set ---
DIM code AS TextEdit
code = NewTextEdit()
CALL TextEditSetText(code, "DIM x AS INTEGER" & Chr(10) & "x = 42 ' the answer" & Chr(10) & "PRINT x")
DIM highlighter AS SyntaxHighlighter
highlighter = NewSyntaxHighlighter(TextEditDocument(code))
CALL HighlighterAddRule(highlighter, "\bDIM\b|\bAS\b|\bPRINT\b", 0, 0, 200, 1)
CALL HighlighterAddRule(highlighter, "'.*$", 0, 150, 0, 0)
CALL HighlighterAddRule(highlighter, "\b[0-9]+\b", 200, 0, 0, 0)
CALL HighlighterRehighlight(highlighter)
CALL BoxLayoutAddWidget(mainLayout, code)

' --- QTableWidget row removal + current row/column ---
gTable = NewTableWidget()
CALL TableWidgetSetRowCount(gTable, 2)
CALL TableWidgetSetColumnCount(gTable, 2)
DIM headers AS StringList
headers = NewStringList()
CALL StringListAdd(headers, "Name")
CALL StringListAdd(headers, "Score")
CALL TableWidgetSetHorizontalHeaderLabels(gTable, headers)
CALL TableWidgetSetItemText(gTable, 0, 0, "Alpha")
CALL TableWidgetSetItemText(gTable, 0, 1, "10")
CALL TableWidgetSetItemText(gTable, 1, 0, "Beta")
CALL TableWidgetSetItemText(gTable, 1, 1, "20")
CALL BoxLayoutAddWidget(mainLayout, gTable)

DIM removeRowBtn AS Button
removeRowBtn = NewButton("Remove row 0")
CALL ButtonConnectClicked(removeRowBtn, @OnRemoveRowClicked, 0)
CALL BoxLayoutAddWidget(mainLayout, removeRowBtn)

' --- QLineEdit SelectAll/Clear ---
gEdit = NewLineEdit("select me")
CALL BoxLayoutAddWidget(mainLayout, gEdit)

DIM selectAllBtn AS Button
selectAllBtn = NewButton("Select all text")
CALL ButtonConnectClicked(selectAllBtn, @OnSelectAllClicked, 0)
CALL BoxLayoutAddWidget(mainLayout, selectAllBtn)

CALL WidgetSetLayout(central, mainLayout)
CALL MainWindowSetCentralWidget(win, central)
CALL WidgetShow(win)

CALL ApplicationExec(app)
