' Idiomatic layer: QInputDialog. Static convenience dialogs, not
' persistent widgets, matching MessageBox/ColorDialog/FontDialog
' (dialog.bas/colordialog.bas/fontdialog.bas) - same
' valid-flag-out-parameter shape.

#include once "widget.bas"
#include once "common.bas"
#include once "raw/qt6_inputdialog.bas"

TYPE StringList EXTENDS QtObject
END TYPE

''' A minimal QStringList builder, used only by InputDialogGetItem -
''' mirrors NewComboBox/ComboBoxAddItem's own create-then-add-item
''' convention. InputDialogGetItem CONSUMES and destroys the list it's
''' given - do not reuse or call NewStringList again on the same
''' variable afterwards.
FUNCTION NewStringList() AS StringList
    DIM l AS StringList
    l.handle = eb_qt6_stringlist_create()
    NewStringList = l
END FUNCTION

SUB StringListAdd(BYVAL l AS StringList, text AS ZSTRING)
    CALL eb_qt6_stringlist_add(l.handle, text)
END SUB

''' `parent` - pass an unassigned `DIM x AS QtWidget` (zero-initialized
''' handle) for "no parent window", the same convention MessageBox/
''' ColorDialog/FontDialog functions already use. Returns the entered
''' text as an owned ANY PTR (see ButtonGetText's own doc comment on the
''' FreeQtString convention) - empty if the user cancelled, matching
''' `outValid` being zero.
FUNCTION InputDialogGetText(BYVAL parent AS QtWidget, title AS ZSTRING, label AS ZSTRING, initialText AS ZSTRING, BYREF outValid AS INTEGER) AS ANY PTR
    DIM valid AS INTEGER
    DIM raw AS ANY PTR
    raw = eb_qt6_inputdialog_get_text(parent.handle, title, label, initialText, @valid)
    outValid = valid
    InputDialogGetText = raw
END FUNCTION

''' Fills `outValue` only when the user accepts (`outValid` non-zero) -
''' left untouched on cancel.
SUB InputDialogGetInt(BYVAL parent AS QtWidget, title AS ZSTRING, label AS ZSTRING, initialValue AS INTEGER, min AS INTEGER, max AS INTEGER, BYREF outValue AS INTEGER, BYREF outValid AS INTEGER)
    DIM value AS INTEGER
    DIM valid AS INTEGER
    CALL eb_qt6_inputdialog_get_int(parent.handle, title, label, initialValue, min, max, @value, @valid)
    IF valid <> 0 THEN
        outValue = value
    END IF
    outValid = valid
END SUB

''' `items` is consumed and destroyed by this call - see
''' NewStringList's own doc comment. Returns the picked item's text as
''' an owned ANY PTR - empty if the user cancelled.
FUNCTION InputDialogGetItem(BYVAL parent AS QtWidget, title AS ZSTRING, label AS ZSTRING, BYVAL items AS StringList, currentIndex AS INTEGER, editable AS INTEGER, BYREF outValid AS INTEGER) AS ANY PTR
    DIM valid AS INTEGER
    DIM raw AS ANY PTR
    raw = eb_qt6_inputdialog_get_item(parent.handle, title, label, items.handle, currentIndex, editable, @valid)
    outValid = valid
    InputDialogGetItem = raw
END FUNCTION
