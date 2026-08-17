' Raw FFI layer: QWizard/QWizardPage (`ebqt6shim`).

#include once "qt6_common.bas"

Extern "C" Lib "ebqt6shim"
    Declare Function eb_qt6_wizard_create() AS ANY PTR
    Declare Function eb_qt6_wizardpage_create(ByVal title AS ZSTRING) AS ANY PTR
    Declare Function eb_qt6_wizard_add_page(ByVal wizard AS ANY PTR, ByVal page AS ANY PTR) AS INTEGER
    Declare Sub eb_qt6_wizard_show(ByVal wizard AS ANY PTR)
    Declare Sub eb_qt6_wizard_connect_accepted(ByVal wizard AS ANY PTR, ByVal cb AS ANY PTR, ByVal userData AS ANY PTR)
End Extern
