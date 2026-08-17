' Idiomatic layer: QWizard/QWizardPage. Unlike most real-world Qt
' wizard code, no QWizardPage subclassing is needed here - a plain
' WizardPage composes its contents via WidgetSetLayout (widget.bas),
' the same "compose an existing widget with an existing layout"
' pattern used everywhere else in this package. The wizard itself
' provides Next/Back/Finish/Cancel navigation automatically - nothing
' to wire up manually.

#include once "widget.bas"
#include once "raw/qt6_wizard.bas"

TYPE Wizard EXTENDS QtWidget
END TYPE

''' Real QWizardPage is a QWidget subclass.
TYPE WizardPage EXTENDS QtWidget
END TYPE

FUNCTION NewWizard() AS Wizard
    DIM w AS Wizard
    w.handle = eb_qt6_wizard_create()
    NewWizard = w
END FUNCTION

FUNCTION NewWizardPage(title AS ZSTRING) AS WizardPage
    DIM p AS WizardPage
    p.handle = eb_qt6_wizardpage_create(title)
    NewWizardPage = p
END FUNCTION

''' Appends `page` to the wizard's own page sequence, returning its
''' index. The wizard now owns `page` - see widget.bas's own top
''' comment on the "container now owns it" convention.
FUNCTION WizardAddPage(BYVAL w AS Wizard, BYVAL page AS WizardPage) AS INTEGER
    WizardAddPage = eb_qt6_wizard_add_page(w.handle, page.handle)
END FUNCTION

SUB WizardShow(BYVAL w AS Wizard)
    CALL eb_qt6_wizard_show(w.handle)
END SUB

''' Connects `handler` (a top-level `SUB YourName(userData AS ANY
''' PTR)`) to the wizard's `accepted` signal - fires when the user
''' completes the wizard via the Finish button (not Cancel/close).
SUB WizardConnectAccepted(BYVAL w AS Wizard, handler AS ANY PTR, userData AS ANY PTR)
    CALL eb_qt6_wizard_connect_accepted(w.handle, handler, userData)
END SUB
