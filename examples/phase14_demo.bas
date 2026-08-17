' Phase 14: QSplashScreen, QWizard, PDF printing via QPrinter, and
' multi-column QTreeWidget support.
'
' Flow: a splash screen appears briefly, then finishes into the main
' window. The main window has a button that launches a 2-page wizard
' (name -> confirmation), and a multi-column tree showing a couple of
' rows. On startup this also prints a one-page PDF to a scratch path
' using the same Painter* primitives as custom on-screen drawing, to
' prove PrinterBegin/PrinterEnd share that surface.
'
' Qt6 needs QT_QPA_PLATFORM=xcb explicitly set in this environment - see
' hello_window.bas's own top comment / this package's README.

#include once "qt6.iface.bas"

DIM gWizard AS Wizard
DIM gNameEdit AS LineEdit
DIM gStatus AS Label

SUB OnWizardAccepted(userData AS ANY PTR)
    DIM raw AS ANY PTR
    raw = LineEditGetText(gNameEdit)
    DIM z AS ZSTRING
    z = raw
    DIM s AS STRING
    s = z
    CALL FreeQtString(raw)
    CALL LabelSetText(gStatus, "wizard finished: " & s)
END SUB

SUB OnLaunchWizard(userData AS ANY PTR)
    CALL WizardShow(gWizard)
    CALL WidgetSetFocus(gNameEdit)
END SUB

DIM app AS Application
app = NewApplication("phase14_demo")

' --- PDF printing, done once at startup, no interaction needed. Like
' QApplication itself, QPrinter aborts if constructed before a
' QCoreApplication exists - so this must come after NewApplication.
DIM pdfPrinter AS Printer
pdfPrinter = NewPdfPrinter("/tmp/claude-1000/-home-yann64-git-cpp-eBasic/8d367c48-7a0e-45d1-a3c2-1de3c764f852/scratchpad/phase14_output.pdf")
DIM pdfPainter AS ANY PTR
pdfPainter = PrinterBegin(pdfPrinter)
CALL PainterSetPenColor(pdfPainter, 0, 0, 0)
CALL PainterDrawText(pdfPainter, 100, 100, "eb-qt6 Phase 14 PDF output")
CALL PainterFillRect(pdfPainter, 100, 150, 200, 80, 200, 220, 255)
CALL PainterDrawRect(pdfPainter, 100, 150, 200, 80)
CALL PrinterEnd(pdfPrinter)

' --- Splash screen ---
DIM splash AS SplashScreen
splash = NewSplashScreenFromFile("assets/sample.png")
CALL SplashScreenShowMessage(splash, "Loading eb-qt6 Phase 14 demo...")
CALL SplashScreenShow(splash)

DIM win AS MainWindow
win = NewMainWindow()
CALL WidgetSetWindowTitle(win, "eb-qt6 Phase 14 demo")
CALL WidgetResize(win, 420, 380)

DIM central AS QtWidget
central = NewWidget()
DIM mainLayout AS BoxLayout
mainLayout = NewVBoxLayout()

' --- Wizard trigger ---
gNameEdit = NewLineEdit("")
DIM launchBtn AS Button
launchBtn = NewButton("Open wizard")
CALL ButtonConnectClicked(launchBtn, @OnLaunchWizard, 0)
CALL BoxLayoutAddWidget(mainLayout, launchBtn)

gStatus = NewLabel("(wizard not run yet)")
CALL BoxLayoutAddWidget(mainLayout, gStatus)

DIM wizPage1 AS WizardPage
wizPage1 = NewWizardPage("Your name")
DIM p1Layout AS BoxLayout
p1Layout = NewVBoxLayout()
CALL BoxLayoutAddWidget(p1Layout, NewLabel("Enter your name:"))
CALL BoxLayoutAddWidget(p1Layout, gNameEdit)
CALL WidgetSetLayout(wizPage1, p1Layout)

DIM wizPage2 AS WizardPage
wizPage2 = NewWizardPage("Confirm")
DIM p2Layout AS BoxLayout
p2Layout = NewVBoxLayout()
CALL BoxLayoutAddWidget(p2Layout, NewLabel("Click Finish to complete."))
CALL WidgetSetLayout(wizPage2, p2Layout)

gWizard = NewWizard()
CALL WizardAddPage(gWizard, wizPage1)
CALL WizardAddPage(gWizard, wizPage2)
CALL WizardConnectAccepted(gWizard, @OnWizardAccepted, 0)

' --- Multi-column tree ---
DIM tree AS TreeWidget
tree = NewTreeWidget()
CALL TreeWidgetSetColumnCount(tree, 2)
DIM headers AS StringList
headers = NewStringList()
CALL StringListAdd(headers, "Name")
CALL StringListAdd(headers, "Value")
CALL TreeWidgetSetHeaderLabels(tree, headers)

DIM row1 AS TreeItem
row1 = TreeWidgetAddTopLevelItem(tree, "Alpha")
CALL TreeItemSetText(row1, 1, "100")
DIM row2 AS TreeItem
row2 = TreeWidgetAddTopLevelItem(tree, "Beta")
CALL TreeItemSetText(row2, 1, "200")

CALL BoxLayoutAddWidget(mainLayout, tree)

CALL WidgetSetLayout(central, mainLayout)
CALL MainWindowSetCentralWidget(win, central)

CALL SplashScreenFinish(splash, win)
CALL WidgetShow(win)

CALL ApplicationExec(app)
