' Phase 15: QProcess, window geometry/position, QLineEdit echo mode
' (password masking), and an editable QComboBox.
'
' QProcess needs no GUI interaction to verify at all - it runs at
' startup, before the window even shows, and reports its own real
' stdout/exit code into the status label.
'
' Qt6 needs QT_QPA_PLATFORM=xcb explicitly set in this environment - see
' hello_window.bas's own top comment / this package's README.

#include once "qt6.iface.bas"

DIM gStatus AS Label
DIM gPasswordEdit AS LineEdit

SUB OnEditTextChanged(userData AS ANY PTR, text AS ZSTRING)
    DIM s AS STRING
    s = text
    CALL LabelSetText(gStatus, "combo edit text: " & s)
END SUB

SUB OnRevealClicked(userData AS ANY PTR)
    DIM raw AS ANY PTR
    raw = LineEditGetText(gPasswordEdit)
    DIM z AS ZSTRING
    z = raw
    DIM s AS STRING
    s = z
    CALL FreeQtString(raw)
    CALL LabelSetText(gStatus, "password field really contains: " & s)
END SUB

DIM app AS Application
app = NewApplication("phase15_demo")

DIM win AS MainWindow
win = NewMainWindow()
CALL WidgetSetWindowTitle(win, "eb-qt6 Phase 15 demo")
CALL WidgetResize(win, 420, 300)

' --- Window geometry/position, no interaction needed to exercise ---
CALL WidgetMove(win, 200, 150)
CALL WidgetRaise(win)

DIM central AS QtWidget
central = NewWidget()
DIM mainLayout AS BoxLayout
mainLayout = NewVBoxLayout()

' --- QProcess: run a real command at startup, no interaction needed ---
DIM proc AS Process
proc = NewProcess(win)
CALL ProcessStart(proc, "echo Hello from QProcess")
CALL ProcessWaitForFinished(proc, 5000)
DIM outRaw AS ANY PTR
outRaw = ProcessReadAllStandardOutput(proc)
DIM outZ AS ZSTRING
outZ = outRaw
DIM outStr AS STRING
outStr = outZ
CALL FreeQtString(outRaw)
DIM exitCode AS INTEGER
exitCode = ProcessExitCode(proc)

gStatus = NewLabel("process said: " & outStr & " (exit " & Str(exitCode) & ")")
CALL BoxLayoutAddWidget(mainLayout, gStatus)

' --- LineEdit echo mode (password masking) ---
gPasswordEdit = NewLineEdit("secret42")
CALL LineEditSetEchoMode(gPasswordEdit, QtLineEditPassword)
CALL BoxLayoutAddWidget(mainLayout, gPasswordEdit)

DIM revealBtn AS Button
revealBtn = NewButton("Reveal (read real text)")
CALL ButtonConnectClicked(revealBtn, @OnRevealClicked, 0)
CALL BoxLayoutAddWidget(mainLayout, revealBtn)

' --- Editable ComboBox ---
DIM combo AS ComboBox
combo = NewComboBox()
CALL ComboBoxAddItem(combo, "Alpha")
CALL ComboBoxAddItem(combo, "Beta")
CALL ComboBoxSetEditable(combo, 1)
CALL ComboBoxConnectEditTextChanged(combo, @OnEditTextChanged, 0)
CALL BoxLayoutAddWidget(mainLayout, combo)

CALL WidgetSetLayout(central, mainLayout)
CALL MainWindowSetCentralWidget(win, central)
CALL WidgetShow(win)

CALL ApplicationExec(app)
