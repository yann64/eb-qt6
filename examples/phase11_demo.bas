' Phase 11 combined demo: enable/disable and show/hide toggles on a
' target line edit and label, a custom font applied to a label, and a
' standalone QScrollBar driving an LCDNumber display - all wired to a
' shared status label.
'
' Qt6 needs QT_QPA_PLATFORM=xcb explicitly set in this environment - see
' hello_window.bas's own top comment / this package's README.

#include once "qt6.iface.bas"

DIM gStatus AS Label
DIM gTargetEdit AS LineEdit
DIM gHideableLabel AS Label
DIM gFontLabel AS Label
DIM gLcd AS LCDNumber
DIM gEnabled AS INTEGER
DIM gVisible AS INTEGER
DIM app AS Application

SUB OnToggleEnabledClicked(userData AS ANY PTR)
    IF gEnabled = 0 THEN
        gEnabled = 1
    ELSE
        gEnabled = 0
    END IF
    CALL WidgetSetEnabled(gTargetEdit, gEnabled)
    CALL LabelSetText(gStatus, "target edit enabled: " & Str(WidgetIsEnabled(gTargetEdit)))
END SUB

SUB OnToggleVisibleClicked(userData AS ANY PTR)
    IF gVisible = 0 THEN
        gVisible = 1
    ELSE
        gVisible = 0
    END IF
    CALL WidgetSetVisible(gHideableLabel, gVisible)
    CALL LabelSetText(gStatus, "hideable label visible: " & Str(WidgetIsVisible(gHideableLabel)))
END SUB

SUB OnApplyFontClicked(userData AS ANY PTR)
    CALL WidgetSetFont(gFontLabel, "Serif", 18, 1, 1)
    CALL LabelSetText(gStatus, "font applied")
END SUB

SUB OnScrollChanged(userData AS ANY PTR, value AS INTEGER)
    CALL LCDNumberDisplay(gLcd, value)
    CALL LabelSetText(gStatus, "scrollbar: " & Str(value))
END SUB

app = NewApplication("phase11_demo")

DIM win AS MainWindow
win = NewMainWindow()
CALL WidgetSetWindowTitle(win, "eb-qt6 Phase 11 demo")
CALL WidgetResize(win, 380, 360)

DIM central AS QtWidget
central = NewWidget()
DIM mainLayout AS BoxLayout
mainLayout = NewVBoxLayout()

gEnabled = 1
gTargetEdit = NewLineEdit("editable")
CALL BoxLayoutAddWidget(mainLayout, gTargetEdit)

DIM toggleEnabledButton AS Button
toggleEnabledButton = NewButton("Toggle Enabled")
CALL ButtonConnectClicked(toggleEnabledButton, @OnToggleEnabledClicked, 0)
CALL BoxLayoutAddWidget(mainLayout, toggleEnabledButton)

gVisible = 1
gHideableLabel = NewLabel("Now you see me")
CALL BoxLayoutAddWidget(mainLayout, gHideableLabel)

DIM toggleVisibleButton AS Button
toggleVisibleButton = NewButton("Toggle Visible")
CALL ButtonConnectClicked(toggleVisibleButton, @OnToggleVisibleClicked, 0)
CALL BoxLayoutAddWidget(mainLayout, toggleVisibleButton)

gFontLabel = NewLabel("Plain font")
CALL BoxLayoutAddWidget(mainLayout, gFontLabel)

DIM applyFontButton AS Button
applyFontButton = NewButton("Apply Font")
CALL ButtonConnectClicked(applyFontButton, @OnApplyFontClicked, 0)
CALL BoxLayoutAddWidget(mainLayout, applyFontButton)

DIM scroll AS ScrollBar
scroll = NewScrollBar(QtHorizontal)
CALL ScrollBarSetRange(scroll, 0, 100)
CALL ScrollBarConnectValueChanged(scroll, @OnScrollChanged, 0)
CALL BoxLayoutAddWidget(mainLayout, scroll)

gLcd = NewLCDNumber()
CALL LCDNumberDisplay(gLcd, 0)
CALL BoxLayoutAddWidget(mainLayout, gLcd)

gStatus = NewLabel("(nothing yet)")
CALL BoxLayoutAddWidget(mainLayout, gStatus)

CALL WidgetSetLayout(central, mainLayout)
CALL MainWindowSetCentralWidget(win, central)
CALL WidgetShow(win)

CALL WidgetSetFocus(toggleEnabledButton)

CALL ApplicationExec(app)
