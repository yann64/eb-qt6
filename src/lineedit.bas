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

''' Restricts typed text to integers in [bottom, top] - constructs a
''' new validator parented to `e` itself (Qt manages its lifetime
''' automatically, tied to the widget - no separate handle to track).
''' Replaces any previously-set validator.
SUB LineEditSetIntValidator(BYVAL e AS LineEdit, bottom AS INTEGER, top AS INTEGER)
    CALL eb_qt6_lineedit_set_int_validator(e.handle, bottom, top)
END SUB

''' Restricts typed text to a decimal number in [bottom, top] with at
''' most `decimals` digits after the point - same parented-to-`e`
''' lifetime as LineEditSetIntValidator.
SUB LineEditSetDoubleValidator(BYVAL e AS LineEdit, bottom AS DOUBLE, top AS DOUBLE, decimals AS INTEGER)
    CALL eb_qt6_lineedit_set_double_validator(e.handle, bottom, top, decimals)
END SUB

''' Matches real QLineEdit::EchoMode values - pass to LineEditSetEchoMode.
CONST QtLineEditNormal = 0
CONST QtLineEditNoEcho = 1
CONST QtLineEditPassword = 2
CONST QtLineEditPasswordEchoOnEdit = 3

''' QtLineEditPassword masks typed characters (e.g. with dots) - the
''' usual way to build a password field. LineEditGetText/SetText still
''' operate on the real underlying text either way.
SUB LineEditSetEchoMode(BYVAL e AS LineEdit, mode AS INTEGER)
    CALL eb_qt6_lineedit_set_echo_mode(e.handle, mode)
END SUB

''' `pattern` is a real regular expression (QRegularExpression syntax,
''' PCRE-like) - alongside the existing LineEditSetIntValidator/
''' SetDoubleValidator, for patterns those can't express (e.g. an email
''' address shape). Replaces any previously-set validator. An invalid
''' pattern makes the field accept nothing at all (real Qt behavior),
''' not a crash.
SUB LineEditSetRegexValidator(BYVAL e AS LineEdit, pattern AS ZSTRING)
    CALL eb_qt6_lineedit_set_regex_validator(e.handle, pattern)
END SUB

''' Grayed-out hint text shown only while the field is empty - never
''' part of the field's own real value (LineEditGetText never returns
''' it).
SUB LineEditSetPlaceholderText(BYVAL e AS LineEdit, text AS ZSTRING)
    CALL eb_qt6_lineedit_set_placeholder_text(e.handle, text)
END SUB

''' Caps how many characters can be typed/pasted in - Qt's own default
''' is a very large number, effectively unlimited, until this is
''' called.
SUB LineEditSetMaxLength(BYVAL e AS LineEdit, maxLength AS INTEGER)
    CALL eb_qt6_lineedit_set_max_length(e.handle, maxLength)
END SUB

SUB LineEditSelectAll(BYVAL e AS LineEdit)
    CALL eb_qt6_lineedit_select_all(e.handle)
END SUB

SUB LineEditClear(BYVAL e AS LineEdit)
    CALL eb_qt6_lineedit_clear(e.handle)
END SUB
