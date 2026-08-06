' Phase 2 combined demo: a menu bar (File > Quit), a checkbox, two
' mutually-exclusive radio buttons, a combo box, and a text edit - all
' wired to a single status label.
'
' Qt6 needs QT_QPA_PLATFORM=xcb explicitly set in this environment - see
' hello_window.bas's own top comment / this package's README.

#include once "qt6.iface.bas"

DIM gStatus AS Label
DIM gCombo AS ComboBox
DIM app AS Application

SUB OnQuit(userData AS ANY PTR)
    CALL ApplicationQuit(app)
END SUB

SUB OnCheckToggled(userData AS ANY PTR, checked AS INTEGER)
    IF checked <> 0 THEN
        CALL LabelSetText(gStatus, "checkbox: on")
    ELSE
        CALL LabelSetText(gStatus, "checkbox: off")
    END IF
END SUB

SUB OnRadio1Toggled(userData AS ANY PTR, checked AS INTEGER)
    IF checked <> 0 THEN
        CALL LabelSetText(gStatus, "radio: Option A")
    END IF
END SUB

SUB OnRadio2Toggled(userData AS ANY PTR, checked AS INTEGER)
    IF checked <> 0 THEN
        CALL LabelSetText(gStatus, "radio: Option B")
    END IF
END SUB

SUB OnComboChanged(userData AS ANY PTR, index AS INTEGER)
    DIM raw AS ANY PTR
    raw = ComboBoxCurrentText(gCombo)
    DIM z AS ZSTRING
    z = raw
    DIM s AS STRING
    s = z
    CALL FreeQtString(raw)
    CALL LabelSetText(gStatus, "combo: " & s)
END SUB

SUB OnTextChanged(userData AS ANY PTR)
    CALL LabelSetText(gStatus, "text edit changed")
END SUB

app = NewApplication("phase2_demo")

DIM win AS MainWindow
win = NewMainWindow()
CALL WidgetSetWindowTitle(win, "eb-qt6 Phase 2 demo")
CALL WidgetResize(win, 350, 320)

DIM winMenuBar AS MenuBar
winMenuBar = MainWindowMenuBar(win)
DIM fileMenu AS Menu
fileMenu = MenuBarAddMenu(winMenuBar, "File")
DIM quitAction AS Action
quitAction = MenuAddAction(fileMenu, "Quit")
CALL ActionConnectTriggered(quitAction, @OnQuit, 0)

DIM central AS QtWidget
central = NewWidget()
DIM layout AS BoxLayout
layout = NewVBoxLayout()

DIM chk AS CheckBox
chk = NewCheckBox("Enable feature")
CALL AbstractButtonConnectToggled(chk, @OnCheckToggled, 0)
CALL BoxLayoutAddWidget(layout, chk)

DIM radio1 AS RadioButton
radio1 = NewRadioButton("Option A")
CALL AbstractButtonSetChecked(radio1, 1)
CALL AbstractButtonConnectToggled(radio1, @OnRadio1Toggled, 0)
CALL BoxLayoutAddWidget(layout, radio1)

DIM radio2 AS RadioButton
radio2 = NewRadioButton("Option B")
CALL AbstractButtonConnectToggled(radio2, @OnRadio2Toggled, 0)
CALL BoxLayoutAddWidget(layout, radio2)

gCombo = NewComboBox()
CALL ComboBoxAddItem(gCombo, "First")
CALL ComboBoxAddItem(gCombo, "Second")
CALL ComboBoxAddItem(gCombo, "Third")
CALL ComboBoxConnectCurrentIndexChanged(gCombo, @OnComboChanged, 0)
CALL BoxLayoutAddWidget(layout, gCombo)

DIM te AS TextEdit
te = NewTextEdit()
CALL TextEditConnectTextChanged(te, @OnTextChanged, 0)
CALL BoxLayoutAddWidget(layout, te)

gStatus = NewLabel("(nothing yet)")
CALL BoxLayoutAddWidget(layout, gStatus)

CALL WidgetSetLayout(central, layout)
CALL MainWindowSetCentralWidget(win, central)
CALL WidgetShow(win)

CALL ApplicationExec(app)
