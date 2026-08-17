' Phase 22: QPushButton default/auto-default, QTreeWidget expand/
' collapse/sorting, QSplitter pane sizing, and a programmatic QToolTip.
'
' Qt6 needs QT_QPA_PLATFORM=xcb explicitly set in this environment - see
' hello_window.bas's own top comment / this package's README.

#include once "qt6.iface.bas"

DIM gStatus AS Label
DIM gTree AS TreeWidget

SUB OnDefaultClicked(userData AS ANY PTR)
    CALL LabelSetText(gStatus, "default button clicked (Enter key works too)")
END SUB

SUB OnCollapseClicked(userData AS ANY PTR)
    CALL TreeWidgetCollapseAll(gTree)
    CALL LabelSetText(gStatus, "collapsed all")
END SUB

SUB OnShowTipClicked(userData AS ANY PTR)
    CALL ToolTipShowText(400, 300, "Programmatic tooltip!")
    CALL LabelSetText(gStatus, "tooltip shown at (400,300)")
END SUB

DIM app AS Application
app = NewApplication("phase22_demo")

DIM win AS MainWindow
win = NewMainWindow()
CALL WidgetSetWindowTitle(win, "eb-qt6 Phase 22 demo")
CALL WidgetResize(win, 460, 480)

DIM central AS QtWidget
central = NewWidget()
DIM mainLayout AS BoxLayout
mainLayout = NewVBoxLayout()

gStatus = NewLabel("(nothing done yet)")
CALL BoxLayoutAddWidget(mainLayout, gStatus)

' --- QSplitter with initial pane sizes ---
DIM split AS Splitter
split = NewSplitter(QtHorizontal)
DIM leftList AS ListWidget
leftList = NewListWidget()
CALL ListWidgetAddItem(leftList, "left pane")
DIM rightList AS ListWidget
rightList = NewListWidget()
CALL ListWidgetAddItem(rightList, "right pane")
CALL SplitterAddWidget(split, leftList)
CALL SplitterAddWidget(split, rightList)
CALL SplitterSetSizes2(split, 300, 100)
CALL BoxLayoutAddWidget(mainLayout, split)

' --- QTreeWidget expand/collapse/sorting ---
gTree = NewTreeWidget()
CALL TreeWidgetSetSortingEnabled(gTree, 1)
DIM parentItem AS TreeItem
parentItem = TreeWidgetAddTopLevelItem(gTree, "Fruits")
CALL TreeItemAddChild(parentItem, "Banana")
CALL TreeItemAddChild(parentItem, "Apple")
CALL TreeItemAddChild(parentItem, "Cherry")
CALL TreeWidgetExpandAll(gTree)
CALL BoxLayoutAddWidget(mainLayout, gTree)

DIM collapseBtn AS Button
collapseBtn = NewButton("Collapse all")
CALL ButtonConnectClicked(collapseBtn, @OnCollapseClicked, 0)
CALL BoxLayoutAddWidget(mainLayout, collapseBtn)

' --- Programmatic tooltip ---
DIM tipBtn AS Button
tipBtn = NewButton("Show tooltip")
CALL ButtonConnectClicked(tipBtn, @OnShowTipClicked, 0)
CALL BoxLayoutAddWidget(mainLayout, tipBtn)

' --- Default button (Enter key activates it) ---
DIM defaultBtn AS Button
defaultBtn = NewButton("Default (press Enter)")
CALL ButtonSetDefault(defaultBtn, 1)
CALL ButtonConnectClicked(defaultBtn, @OnDefaultClicked, 0)
CALL BoxLayoutAddWidget(mainLayout, defaultBtn)

CALL WidgetSetLayout(central, mainLayout)
CALL MainWindowSetCentralWidget(win, central)
CALL WidgetShow(win)

CALL ApplicationExec(app)
