' Idiomatic layer: QCompleter, attached to a LineEdit.

#include once "widget.bas"
#include once "inputdialog.bas"
#include once "raw/qt6_completer.bas"

TYPE Completer EXTENDS QtObject
END TYPE

''' `items` is consumed and destroyed by this call - see StringList's
''' own doc comment (inputdialog.bas).
FUNCTION NewCompleter(BYVAL items AS StringList) AS Completer
    DIM c AS Completer
    c.handle = eb_qt6_completer_create(items.handle)
    NewCompleter = c
END FUNCTION

''' The line edit takes ownership of `completer` - no separate destroy
''' function needed, the same "container now owns it" convention
''' documented elsewhere in this package.
SUB LineEditSetCompleter(BYVAL e AS LineEdit, BYVAL completer AS Completer)
    CALL eb_qt6_lineedit_set_completer(e.handle, completer.handle)
END SUB
