' Phase 12 combined demo: a ComboBox and ListWidget with themed icon
' items, a centered word-wrapped Label, a layout with custom
' spacing/margins, and a button with a pointing-hand cursor - all
' wired to a shared status label.
'
' Qt6 needs QT_QPA_PLATFORM=xcb explicitly set in this environment - see
' hello_window.bas's own top comment / this package's README.

#include once "qt6.iface.bas"

DIM gStatus AS Label

SUB OnComboChanged(userData AS ANY PTR, index AS INTEGER)
    CALL LabelSetText(gStatus, "combo index: " & Str(index))
END SUB

SUB OnListRowChanged(userData AS ANY PTR, row AS INTEGER)
    CALL LabelSetText(gStatus, "list row: " & Str(row))
END SUB

DIM app AS Application
app = NewApplication("phase12_demo")

DIM win AS MainWindow
win = NewMainWindow()
CALL WidgetSetWindowTitle(win, "eb-qt6 Phase 12 demo")
CALL WidgetResize(win, 420, 420)

DIM central AS QtWidget
central = NewWidget()
DIM mainLayout AS BoxLayout
mainLayout = NewVBoxLayout()
' Real defaults are much tighter than this - deliberately generous
' values here so the extra spacing/margins are visually obvious.
CALL BoxLayoutSetSpacing(mainLayout, 16)
CALL BoxLayoutSetContentsMargins(mainLayout, 24, 24, 24, 24)

DIM combo AS ComboBox
combo = NewComboBox()
CALL ComboBoxAddItemWithIconFromTheme(combo, "Documents", "folder")
CALL ComboBoxAddItemWithIconFromTheme(combo, "Save", "document-save")
CALL ComboBoxConnectCurrentIndexChanged(combo, @OnComboChanged, 0)
CALL BoxLayoutAddWidget(mainLayout, combo)

DIM list AS ListWidget
list = NewListWidget()
CALL ListWidgetAddItemWithIconFromTheme(list, "Folder Item", "folder")
CALL ListWidgetAddItemWithIconFromTheme(list, "Save Item", "document-save")
CALL ListWidgetConnectCurrentRowChanged(list, @OnListRowChanged, 0)
CALL BoxLayoutAddWidget(mainLayout, list)

DIM wrapLabel AS Label
wrapLabel = NewLabel("This is a fairly long sentence that should visibly wrap across multiple centered lines once word wrap is enabled.")
CALL LabelSetWordWrap(wrapLabel, 1)
CALL LabelSetAlignment(wrapLabel, QtAlignHCenter)
CALL BoxLayoutAddWidget(mainLayout, wrapLabel)

DIM hoverButton AS Button
hoverButton = NewButton("Hover me (pointing-hand cursor)")
CALL WidgetSetCursor(hoverButton, QtPointingHandCursor)
CALL BoxLayoutAddWidget(mainLayout, hoverButton)

gStatus = NewLabel("(nothing yet)")
CALL BoxLayoutAddWidget(mainLayout, gStatus)

CALL WidgetSetLayout(central, mainLayout)
CALL MainWindowSetCentralWidget(win, central)
CALL WidgetShow(win)

CALL WidgetSetFocus(combo)

CALL ApplicationExec(app)
