' Idiomatic layer: QFormLayout. Apply it to a widget via WidgetSetLayout
' (widget.bas) exactly like BoxLayout - both are real QLayout
' subclasses under the hood.

#include once "widget.bas"
#include once "raw/qt6_formlayout.bas"

TYPE FormLayout EXTENDS QtObject
END TYPE

FUNCTION NewFormLayout() AS FormLayout
    DIM l AS FormLayout
    l.handle = eb_qt6_formlayout_create()
    NewFormLayout = l
END FUNCTION

''' Appends a labeled row ("label: widget") to the form - the layout now
''' owns `widget`, see widget.bas's own top comment on the "container
''' now owns it" convention.
SUB FormLayoutAddRow(BYVAL layout AS FormLayout, labelText AS ZSTRING, BYVAL widget AS QtWidget)
    CALL eb_qt6_formlayout_add_row(layout.handle, labelText, widget.handle)
END SUB
