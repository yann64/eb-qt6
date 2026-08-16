' Idiomatic layer: QButtonGroup - enables cross-container radio button
' exclusivity (real Qt's own default only groups by immediate parent
' widget, see checkbox.bas's own top comment) - noted as unbound since
' Phase 2, added here.

#include once "widget.bas"
#include once "checkbox.bas"
#include once "raw/qt6_buttongroup.bas"

TYPE ButtonGroup EXTENDS QtObject
END TYPE

''' `parent` - pass a real parent widget so Qt manages the group's
''' lifetime automatically (a plain `DIM x AS QtWidget` handle of 0
''' would leak the group forever, since QButtonGroup has no natural
''' widget-tree owner otherwise).
FUNCTION NewButtonGroup(BYVAL parent AS QtWidget) AS ButtonGroup
    DIM g AS ButtonGroup
    g.handle = eb_qt6_buttongroup_create(parent.handle)
    NewButtonGroup = g
END FUNCTION

''' Adds `button` (a CheckBox or RadioButton) to the group. The group
''' does NOT take ownership - `button`'s actual parent widget/layout
''' still owns it, matching real Qt semantics.
SUB ButtonGroupAddButton(BYVAL group AS ButtonGroup, BYVAL button AS AbstractButton)
    CALL eb_qt6_buttongroup_add_button(group.handle, button.handle)
END SUB

''' The returned AbstractButton's handle is a null ANY PTR if nothing in
''' the group is checked.
FUNCTION ButtonGroupCheckedButton(BYVAL group AS ButtonGroup) AS AbstractButton
    ButtonGroupCheckedButton = WrapAbstractButton(eb_qt6_buttongroup_checked_button(group.handle))
END FUNCTION

''' Connects `handler` (a top-level `SUB YourName(userData AS ANY PTR,
''' button AS ANY PTR)`) to the group's `buttonClicked` signal - `button`
''' is a raw handle, wrap it via WrapAbstractButton before calling
''' AbstractButtonIsChecked/etc. on it.
SUB ButtonGroupConnectButtonClicked(BYVAL group AS ButtonGroup, handler AS ANY PTR, userData AS ANY PTR)
    CALL eb_qt6_buttongroup_connect_button_clicked(group.handle, handler, userData)
END SUB
