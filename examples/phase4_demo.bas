' Phase 4 combined demo: a tool bar (Increment action), a status bar, a
' splitter dividing a tree widget from a scroll area full of labels, and
' a progress bar driven by the tool bar action - all wired to the
' window's own status bar.
'
' Qt6 needs QT_QPA_PLATFORM=xcb explicitly set in this environment - see
' hello_window.bas's own top comment / this package's README.

#include once "qt6.iface.bas"

DIM gStatus AS StatusBar
DIM gProgress AS ProgressBar
DIM gProgressValue AS INTEGER
DIM app AS Application

SUB OnIncrementClicked(userData AS ANY PTR)
    gProgressValue = gProgressValue + 10
    IF gProgressValue > 100 THEN
        gProgressValue = 0
    END IF
    CALL ProgressBarSetValue(gProgress, gProgressValue)
    CALL StatusBarShowMessage(gStatus, "progress: " & Str(gProgressValue), 0)
END SUB

SUB OnTreeItemChanged(userData AS ANY PTR, item AS ANY PTR)
    IF item = 0 THEN
        EXIT SUB
    END IF
    DIM wrapped AS TreeItem
    wrapped = WrapTreeItem(item)
    DIM raw AS ANY PTR
    raw = TreeItemText(wrapped)
    DIM z AS ZSTRING
    z = raw
    DIM s AS STRING
    s = z
    CALL FreeQtString(raw)
    CALL StatusBarShowMessage(gStatus, "tree: " & s, 0)
END SUB

app = NewApplication("phase4_demo")

DIM win AS MainWindow
win = NewMainWindow()
CALL WidgetSetWindowTitle(win, "eb-qt6 Phase 4 demo")
CALL WidgetResize(win, 480, 400)

gStatus = MainWindowStatusBar(win)
CALL StatusBarShowMessage(gStatus, "ready", 0)

DIM bar AS ToolBar
bar = MainWindowAddToolBar(win, "Main")
DIM incrementAction AS Action
incrementAction = ToolBarAddAction(bar, "Increment")
CALL ActionConnectTriggered(incrementAction, @OnIncrementClicked, 0)

DIM central AS QtWidget
central = NewWidget()
DIM mainLayout AS BoxLayout
mainLayout = NewVBoxLayout()

DIM mainSplitter AS Splitter
mainSplitter = NewSplitter(QtHorizontal)

DIM tree AS TreeWidget
tree = NewTreeWidget()
CALL TreeWidgetConnectCurrentItemChanged(tree, @OnTreeItemChanged, 0)
DIM fruitItem AS TreeItem
fruitItem = TreeWidgetAddTopLevelItem(tree, "Fruit")
CALL TreeItemAddChild(fruitItem, "Apple")
CALL TreeItemAddChild(fruitItem, "Banana")
DIM vegItem AS TreeItem
vegItem = TreeWidgetAddTopLevelItem(tree, "Vegetables")
CALL TreeItemAddChild(vegItem, "Carrot")
CALL SplitterAddWidget(mainSplitter, tree)

DIM scrollContent AS QtWidget
scrollContent = NewWidget()
DIM scrollLayout AS BoxLayout
scrollLayout = NewVBoxLayout()
DIM i AS INTEGER
FOR i = 1 TO 20
    DIM rowLabel AS Label
    rowLabel = NewLabel("Row " & Str(i))
    CALL BoxLayoutAddWidget(scrollLayout, rowLabel)
NEXT i
CALL WidgetSetLayout(scrollContent, scrollLayout)

DIM rightScrollArea AS ScrollArea
rightScrollArea = NewScrollArea()
CALL ScrollAreaSetWidgetResizable(rightScrollArea, 1)
CALL ScrollAreaSetWidget(rightScrollArea, scrollContent)
CALL SplitterAddWidget(mainSplitter, rightScrollArea)

CALL BoxLayoutAddWidget(mainLayout, mainSplitter)

gProgress = NewProgressBar()
CALL ProgressBarSetRange(gProgress, 0, 100)
gProgressValue = 0
CALL BoxLayoutAddWidget(mainLayout, gProgress)

CALL WidgetSetLayout(central, mainLayout)
CALL MainWindowSetCentralWidget(win, central)
CALL WidgetShow(win)

CALL ApplicationExec(app)
