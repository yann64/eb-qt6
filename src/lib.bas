' eb-qt6: a Qt6 Widgets wrapper library for eBasic.
'
' Aggregates the raw FFI layer and the idiomatic wrapper layer into one
' #include. Consumers only ever #include this file's own generated
' interface (target/qt6.iface.bas, after `ebpm build`).

#include once "raw/qt6_common.bas"
#include once "raw/qt6_application.bas"
#include once "raw/qt6_widget.bas"
#include once "raw/qt6_button.bas"
#include once "raw/qt6_label.bas"
#include once "raw/qt6_lineedit.bas"
#include once "raw/qt6_painterwidget.bas"
#include once "raw/qt6_painter.bas"
#include once "raw/qt6_checkbox.bas"
#include once "raw/qt6_combobox.bas"
#include once "raw/qt6_textedit.bas"
#include once "raw/qt6_menu.bas"

#include once "common.bas"
#include once "application.bas"
#include once "widget.bas"
#include once "button.bas"
#include once "label.bas"
#include once "lineedit.bas"
#include once "painterwidget.bas"
#include once "painter.bas"
#include once "checkbox.bas"
#include once "combobox.bas"
#include once "textedit.bas"
#include once "menu.bas"
