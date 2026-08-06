' Idiomatic layer: QCheckBox/QRadioButton - both real QAbstractButton
' subclasses sharing the exact same API shape, so both extend one common
' AbstractButton type and share its functions (matching eb-haiku's own
' "one function, several real subclasses" convention already used for
' HControlSetEnabled).
'
' QRadioButton's mutual exclusivity is Qt's own default behavior for
' radio buttons sharing the same immediate parent widget - no grouping
' call needed for the common case (cross-container grouping via
' QButtonGroup is a real, named follow-on, not bound here).

#include once "widget.bas"
#include once "raw/qt6_checkbox.bas"

TYPE AbstractButton EXTENDS QtWidget
END TYPE

TYPE CheckBox EXTENDS AbstractButton
END TYPE

TYPE RadioButton EXTENDS AbstractButton
END TYPE

FUNCTION NewCheckBox(text AS ZSTRING) AS CheckBox
    DIM c AS CheckBox
    c.handle = eb_qt6_checkbox_create(text)
    NewCheckBox = c
END FUNCTION

FUNCTION NewRadioButton(text AS ZSTRING) AS RadioButton
    DIM r AS RadioButton
    r.handle = eb_qt6_radiobutton_create(text)
    NewRadioButton = r
END FUNCTION

SUB AbstractButtonSetChecked(BYVAL b AS AbstractButton, checked AS INTEGER)
    CALL eb_qt6_abstractbutton_set_checked(b.handle, checked)
END SUB

FUNCTION AbstractButtonIsChecked(BYVAL b AS AbstractButton) AS INTEGER
    AbstractButtonIsChecked = eb_qt6_abstractbutton_is_checked(b.handle)
END FUNCTION

''' Connects `handler` (a top-level `SUB YourName(userData AS ANY PTR,
''' checked AS INTEGER)`) to the button's `toggled` signal - fires
''' whenever the checked state changes, by user interaction or by
''' AbstractButtonSetChecked. Works on either CheckBox or RadioButton
''' (both share this file's own AbstractButton base).
SUB AbstractButtonConnectToggled(BYVAL b AS AbstractButton, handler AS ANY PTR, userData AS ANY PTR)
    CALL eb_qt6_abstractbutton_connect_toggled(b.handle, handler, userData)
END SUB
