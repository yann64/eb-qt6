' Idiomatic layer: QLineEdit.

#include once "widget.bas"
#include once "common.bas"
#include once "raw/qt6_lineedit.bas"

TYPE LineEdit EXTENDS QtWidget
END TYPE

FUNCTION NewLineEdit(text AS ZSTRING) AS LineEdit
    DIM e AS LineEdit
    e.handle = eb_qt6_lineedit_create(text)
    NewLineEdit = e
END FUNCTION

SUB LineEditSetText(BYVAL e AS LineEdit, text AS ZSTRING)
    CALL eb_qt6_lineedit_set_text(e.handle, text)
END SUB

''' See ButtonGetText's own doc comment on the owned-allocation/
''' FreeQtString convention.
FUNCTION LineEditGetText(BYVAL e AS LineEdit) AS ANY PTR
    LineEditGetText = eb_qt6_lineedit_get_text(e.handle)
END FUNCTION

''' Connects `handler` (a top-level `SUB YourName(userData AS ANY PTR)`)
''' to the field's `returnPressed` signal (fires when Enter is pressed
''' inside it) - same `userData`-outlives-the-widget convention as
''' ButtonConnectClicked.
SUB LineEditConnectReturnPressed(BYVAL e AS LineEdit, handler AS ANY PTR, userData AS ANY PTR)
    CALL eb_qt6_lineedit_connect_return_pressed(e.handle, handler, userData)
END SUB

''' Connects `handler` (a top-level `SUB YourName(userData AS ANY PTR,
''' text AS ZSTRING)`) to the field's `textChanged` signal, fired on
''' every keystroke. Unlike LineEditGetText's owned allocation, `text`
''' here is borrowed - valid only for the duration of this one call, no
''' FreeQtString needed (or safe to call).
SUB LineEditConnectTextChanged(BYVAL e AS LineEdit, handler AS ANY PTR, userData AS ANY PTR)
    CALL eb_qt6_lineedit_connect_text_changed(e.handle, handler, userData)
END SUB
