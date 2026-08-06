' Idiomatic layer: QTextEdit (plain-text mode only - no rich-text/
' formatting surface exposed, matching eb-haiku's own BTextView scope).

#include once "widget.bas"
#include once "common.bas"
#include once "raw/qt6_textedit.bas"

TYPE TextEdit EXTENDS QtWidget
END TYPE

FUNCTION NewTextEdit() AS TextEdit
    DIM t AS TextEdit
    t.handle = eb_qt6_textedit_create()
    NewTextEdit = t
END FUNCTION

SUB TextEditSetText(BYVAL t AS TextEdit, text AS ZSTRING)
    CALL eb_qt6_textedit_set_text(t.handle, text)
END SUB

''' See ButtonGetText's own doc comment on the owned-allocation/
''' FreeQtString convention.
FUNCTION TextEditGetText(BYVAL t AS TextEdit) AS ANY PTR
    TextEditGetText = eb_qt6_textedit_get_text(t.handle)
END FUNCTION

''' Connects `handler` (a top-level `SUB YourName(userData AS ANY
''' PTR)`) to the field's `textChanged` signal - unlike LineEdit's own
''' version, this one carries no text parameter (QTextEdit::
''' textChanged() takes none in real Qt) - call TextEditGetText yourself
''' inside the handler if you need the new content.
SUB TextEditConnectTextChanged(BYVAL t AS TextEdit, handler AS ANY PTR, userData AS ANY PTR)
    CALL eb_qt6_textedit_connect_text_changed(t.handle, handler, userData)
END SUB
