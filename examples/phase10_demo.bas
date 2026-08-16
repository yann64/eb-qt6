' Phase 10 combined demo: an image shown via a Label, the same image
' plus text drawn via a custom PainterWidget, rich-text (HTML) content
' in a TextEdit, and a size-constrained LineEdit whose focus state is
' checked - all wired to a shared status label.
'
' Qt6 needs QT_QPA_PLATFORM=xcb explicitly set in this environment - see
' hello_window.bas's own top comment / this package's README.

#include once "qt6.iface.bas"

DIM gStatus AS Label
DIM gTextEdit AS TextEdit
DIM gNameEdit AS LineEdit
DIM gFocusCheckTimer AS QTimer
DIM app AS Application

SUB OnPaint(userData AS ANY PTR, painter AS ANY PTR)
    CALL PainterFillRect(painter, 0, 0, 400, 90, 255, 255, 255)
    DIM ok AS INTEGER
    ok = PainterDrawPixmap(painter, 10, 10, "assets/sample.png")
    IF ok = 0 THEN
        CALL PainterSetPenColor(painter, 200, 0, 0)
        CALL PainterDrawText(painter, 10, 40, "image failed to load")
    ELSE
        CALL PainterSetPenColor(painter, 0, 0, 0)
        CALL PainterDrawText(painter, 90, 40, "drawn via PainterDrawPixmap")
    END IF
END SUB

SUB OnSetHtmlClicked(userData AS ANY PTR)
    CALL TextEditSetHtml(gTextEdit, "<b>Bold</b>, <i>italic</i>, and <span style='color:#c00'>red</span> text.")
END SUB

SUB OnReadHtmlClicked(userData AS ANY PTR)
    DIM raw AS ANY PTR
    raw = TextEditGetHtml(gTextEdit)
    DIM z AS ZSTRING
    z = raw
    DIM s AS STRING
    s = z
    CALL FreeQtString(raw)
    CALL LabelSetText(gStatus, "html length: " & Str(LEN(s)))
END SUB

SUB OnFocusClicked(userData AS ANY PTR)
    ' WidgetSetFocus only POSTS a focus-change event - real Qt doesn't
    ' apply it until the event loop processes it, so WidgetHasFocus
    ' checked synchronously right here would still report the OLD
    ' state (confirmed via a dedicated spike, not assumed - see
    ' WidgetSetFocus's own doc comment). Defer the check via a
    ' single-shot QTimer instead, giving the event loop a chance to
    ' run first.
    CALL WidgetSetFocus(gNameEdit)
    CALL QTimerStart(gFocusCheckTimer)
END SUB

SUB OnFocusCheckTimeout(userData AS ANY PTR)
    CALL LabelSetText(gStatus, "name field has focus: " & Str(WidgetHasFocus(gNameEdit)))
END SUB

app = NewApplication("phase10_demo")

DIM win AS MainWindow
win = NewMainWindow()
CALL WidgetSetWindowTitle(win, "eb-qt6 Phase 10 demo")
CALL WidgetResize(win, 420, 460)

DIM central AS QtWidget
central = NewWidget()
DIM mainLayout AS BoxLayout
mainLayout = NewVBoxLayout()

DIM imageLabel AS Label
imageLabel = NewLabel("(no image)")
DIM loaded AS INTEGER
loaded = LabelSetPixmapFromFile(imageLabel, "assets/sample.png")
CALL BoxLayoutAddWidget(mainLayout, imageLabel)

DIM canvas AS PainterWidget
canvas = NewPainterWidget()
CALL WidgetSetMinimumSize(canvas, 400, 90)
CALL WidgetSetMaximumSize(canvas, 400, 90)
CALL PainterWidgetConnectPaint(canvas, @OnPaint, 0)
CALL BoxLayoutAddWidget(mainLayout, canvas)

gTextEdit = NewTextEdit()
CALL TextEditSetHtml(gTextEdit, "Plain start - click <b>Set HTML</b> below.")
CALL BoxLayoutAddWidget(mainLayout, gTextEdit)

DIM setHtmlButton AS Button
setHtmlButton = NewButton("Set HTML")
CALL ButtonConnectClicked(setHtmlButton, @OnSetHtmlClicked, 0)
CALL BoxLayoutAddWidget(mainLayout, setHtmlButton)

DIM readHtmlButton AS Button
readHtmlButton = NewButton("Read HTML length")
CALL ButtonConnectClicked(readHtmlButton, @OnReadHtmlClicked, 0)
CALL BoxLayoutAddWidget(mainLayout, readHtmlButton)

gNameEdit = NewLineEdit("")
CALL WidgetSetMinimumSize(gNameEdit, 150, 0)
CALL WidgetSetMaximumSize(gNameEdit, 150, 1000)
CALL BoxLayoutAddWidget(mainLayout, gNameEdit)

DIM focusButton AS Button
focusButton = NewButton("Focus Name Field")
CALL ButtonConnectClicked(focusButton, @OnFocusClicked, 0)
CALL BoxLayoutAddWidget(mainLayout, focusButton)

gFocusCheckTimer = NewQTimer(central)
CALL QTimerSetInterval(gFocusCheckTimer, 50)
CALL QTimerSetSingleShot(gFocusCheckTimer, 1)
CALL QTimerConnectTimeout(gFocusCheckTimer, @OnFocusCheckTimeout, 0)

gStatus = NewLabel("(nothing yet)")
CALL BoxLayoutAddWidget(mainLayout, gStatus)

CALL WidgetSetLayout(central, mainLayout)
CALL MainWindowSetCentralWidget(win, central)
CALL WidgetShow(win)

' Without this, Tab-based keyboard verification would start inside
' gTextEdit (the first focusable widget in tab order) - a plain
' QTextEdit consumes Tab itself (inserts a tab character) rather than
' moving focus onward, so real keyboard navigation could never reach
' the buttons below it. Starting focus here instead, via the very
' WidgetSetFocus this phase just added, sidesteps that entirely.
CALL WidgetSetFocus(setHtmlButton)

CALL ApplicationExec(app)
