' Idiomatic layer: QComboBox.

#include once "widget.bas"
#include once "common.bas"
#include once "raw/qt6_combobox.bas"

TYPE ComboBox EXTENDS QtWidget
END TYPE

FUNCTION NewComboBox() AS ComboBox
    DIM c AS ComboBox
    c.handle = eb_qt6_combobox_create()
    NewComboBox = c
END FUNCTION

SUB ComboBoxAddItem(BYVAL c AS ComboBox, text AS ZSTRING)
    CALL eb_qt6_combobox_add_item(c.handle, text)
END SUB

''' Loads a named icon from the current desktop icon theme (e.g.
''' "folder") and shows it alongside `text`.
SUB ComboBoxAddItemWithIconFromTheme(BYVAL c AS ComboBox, text AS ZSTRING, themeIconName AS ZSTRING)
    CALL eb_qt6_combobox_add_item_with_icon_from_theme(c.handle, text, themeIconName)
END SUB

''' See ButtonGetText's own doc comment on the owned-allocation/
''' FreeQtString convention.
FUNCTION ComboBoxCurrentText(BYVAL c AS ComboBox) AS ANY PTR
    ComboBoxCurrentText = eb_qt6_combobox_current_text(c.handle)
END FUNCTION

FUNCTION ComboBoxCurrentIndex(BYVAL c AS ComboBox) AS INTEGER
    ComboBoxCurrentIndex = eb_qt6_combobox_current_index(c.handle)
END FUNCTION

SUB ComboBoxSetCurrentIndex(BYVAL c AS ComboBox, index AS INTEGER)
    CALL eb_qt6_combobox_set_current_index(c.handle, index)
END SUB

''' Connects `handler` (a top-level `SUB YourName(userData AS ANY PTR,
''' index AS INTEGER)`) to the box's `currentIndexChanged` signal.
SUB ComboBoxConnectCurrentIndexChanged(BYVAL c AS ComboBox, handler AS ANY PTR, userData AS ANY PTR)
    CALL eb_qt6_combobox_connect_current_index_changed(c.handle, handler, userData)
END SUB
