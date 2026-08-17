' Idiomatic layer: QTextEdit. Plain-text Get/SetText matches
' eb-haiku's own BTextView scope; Get/SetHtml add real Qt rich-text (a
' small HTML subset - see Qt's own "Supported HTML Subset" docs) as an
' explicit opt-in, not the default.

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

''' Sets rich-text content from an HTML string (Qt's own supported
''' subset) - overwrites any plain-text content set via
''' TextEditSetText.
SUB TextEditSetHtml(BYVAL t AS TextEdit, html AS ZSTRING)
    CALL eb_qt6_textedit_set_html(t.handle, html)
END SUB

''' See ButtonGetText's own doc comment on the owned-allocation/
''' FreeQtString convention. Returns the content as Qt's own generated
''' HTML, even if it was set as plain text.
FUNCTION TextEditGetHtml(BYVAL t AS TextEdit) AS ANY PTR
    TextEditGetHtml = eb_qt6_textedit_get_html(t.handle)
END FUNCTION

''' Connects `handler` (a top-level `SUB YourName(userData AS ANY
''' PTR)`) to the field's `textChanged` signal - unlike LineEdit's own
''' version, this one carries no text parameter (QTextEdit::
''' textChanged() takes none in real Qt) - call TextEditGetText yourself
''' inside the handler if you need the new content.
SUB TextEditConnectTextChanged(BYVAL t AS TextEdit, handler AS ANY PTR, userData AS ANY PTR)
    CALL eb_qt6_textedit_connect_text_changed(t.handle, handler, userData)
END SUB

''' The real QTextDocument* handle backing this edit - only useful for
''' passing to NewSyntaxHighlighter (highlighter.bas). Owned by the
''' TextEdit itself, not a separate handle to track/destroy.
FUNCTION TextEditDocument(BYVAL t AS TextEdit) AS ANY PTR
    TextEditDocument = eb_qt6_textedit_document(t.handle)
END FUNCTION

SUB TextEditClear(BYVAL t AS TextEdit)
    CALL eb_qt6_textedit_clear(t.handle)
END SUB

SUB TextEditUndo(BYVAL t AS TextEdit)
    CALL eb_qt6_textedit_undo(t.handle)
END SUB

SUB TextEditRedo(BYVAL t AS TextEdit)
    CALL eb_qt6_textedit_redo(t.handle)
END SUB

''' A read-only edit still shows/selects/copies its text and scrolls,
''' just rejects typed/pasted edits. Off by default.
SUB TextEditSetReadOnly(BYVAL t AS TextEdit, readOnly AS INTEGER)
    CALL eb_qt6_textedit_set_read_only(t.handle, readOnly)
END SUB
