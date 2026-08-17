' Phase 23: Widget focus policy, Action keyboard shortcuts, tristate
' QCheckBox, and QPixmap Save.
'
' The pixmap save round trip is verified with no interaction needed:
' save a real Pixmap to a scratch file, then reload it from disk and
' compare dimensions.
'
' Qt6 needs QT_QPA_PLATFORM=xcb explicitly set in this environment - see
' hello_window.bas's own top comment / this package's README.

#include once "qt6.iface.bas"

DIM gStatus AS Label
DIM gTriBox AS CheckBox

SUB OnSaveClicked(userData AS ANY PTR)
    CALL LabelSetText(gStatus, "menu Save triggered (Ctrl+S)")
END SUB

SUB OnCheckTristateClicked(userData AS ANY PTR)
    CALL LabelSetText(gStatus, "tristate checkState: " & Str(CheckBoxCheckState(gTriBox)))
END SUB

DIM app AS Application
app = NewApplication("phase23_demo")

' --- QPixmap Save round trip, no interaction needed ---
DIM pic AS Pixmap
pic = NewPixmapFromFile("assets/sample.png")
DIM savePath AS STRING
savePath = "/tmp/claude-1000/-home-yann64-git-cpp-eBasic/8d367c48-7a0e-45d1-a3c2-1de3c764f852/scratchpad/phase23_saved.png"
DIM saved AS INTEGER
saved = PixmapSave(pic, savePath)
DIM reloaded AS Pixmap
reloaded = NewPixmapFromFile(savePath)
DIM pixmapSummary AS STRING
pixmapSummary = "saved=" & Str(saved) & " reloaded=" & Str(PixmapWidth(reloaded)) & "x" & Str(PixmapHeight(reloaded))

DIM win AS MainWindow
win = NewMainWindow()
CALL WidgetSetWindowTitle(win, "eb-qt6 Phase 23 demo")
CALL WidgetResize(win, 420, 320)

' --- Action keyboard shortcut ---
DIM winMenuBar AS MenuBar
winMenuBar = MainWindowMenuBar(win)
DIM fileMenu AS Menu
fileMenu = MenuBarAddMenu(winMenuBar, "&File")
DIM saveAction AS Action
saveAction = MenuAddAction(fileMenu, "&Save")
CALL ActionSetShortcut(saveAction, "Ctrl+S")
CALL ActionConnectTriggered(saveAction, @OnSaveClicked, 0)

DIM central AS QtWidget
central = NewWidget()
DIM mainLayout AS BoxLayout
mainLayout = NewVBoxLayout()

gStatus = NewLabel(pixmapSummary)
CALL BoxLayoutAddWidget(mainLayout, gStatus)

' --- Widget focus policy: a plain container made focusable ---
DIM focusable AS QtWidget
focusable = NewWidget()
CALL WidgetSetFocusPolicy(focusable, QtStrongFocus)
CALL WidgetSetStyleSheet(focusable, "background-color: #dfe; min-height: 40px;")
CALL BoxLayoutAddWidget(mainLayout, focusable)

' --- Tristate QCheckBox ---
gTriBox = NewCheckBox("Tristate checkbox")
CALL CheckBoxSetTristate(gTriBox, 1)
CALL CheckBoxSetCheckState(gTriBox, QtPartiallyChecked)
CALL BoxLayoutAddWidget(mainLayout, gTriBox)

DIM checkBtn AS Button
checkBtn = NewButton("Check tristate state")
CALL ButtonConnectClicked(checkBtn, @OnCheckTristateClicked, 0)
CALL BoxLayoutAddWidget(mainLayout, checkBtn)

CALL WidgetSetLayout(central, mainLayout)
CALL MainWindowSetCentralWidget(win, central)
CALL WidgetShow(win)

CALL ApplicationExec(app)
