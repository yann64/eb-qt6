# Standalone build for eb-qt6's native shim - NOT driven by ebpm (same
# reasoning as eb-haiku's own native/CMakeLists.txt: neither ebc nor
# ebpm compiles a package's own native code today). Produces
# libebqt6shim.a, linked against real Qt6 shared libraries via the
# package's own `Extern "C" Lib "ebqt6shim"` declarations in
# src/raw/*.bas.
#
# Unlike eb-haiku (which only builds/links on real Haiku hardware over
# SSH), Qt6 is fully installed on this development host - this can be
# built and its GUI actually run/screenshotted locally, no remote
# round-trip needed.
#
# Build:
#   cmake -S native -B native/build
#   cmake --build native/build
# Produces native/build/libebqt6shim.a - see this package's own README
# "Building" section for exactly which `-l` flags a downstream consumer
# needs (Qt6 has no legitimate public C symbol anywhere in its core
# libraries for ebpm's own `.libs` sidecar to auto-forward, confirmed
# via `nm -D --defined-only` - unlike eb-haiku's `-l be`, this is never
# automatic).

cmake_minimum_required(VERSION 3.16)
project(ebqt6shim CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Q_OBJECT (used by ShimWidget, ShimDragSourceFilter,
# ShimDropTargetFilter, and ShimSyntaxHighlighter - see
# shim_painterwidget.h/shim_dragdrop.h/shim_highlighter.h's own top
# comments) needs moc, which AUTOMOC drives automatically via the
# Qt6::Widgets imported target below - no manual moc invocation
# anywhere in this file.
set(CMAKE_AUTOMOC ON)

# PrintSupport is needed for QPrinter (shim_printer.h); Network is
# needed for QNetworkAccessManager/QNetworkReply (shim_network.h) - the
# two shims in this package needing a Qt component beyond Widgets/Gui/
# Core.
find_package(Qt6 COMPONENTS Widgets PrintSupport Network REQUIRED)

add_library(ebqt6shim STATIC
    shim_common.cpp
    shim_application.cpp
    shim_widget.cpp
    shim_button.cpp
    shim_label.cpp
    shim_lineedit.cpp
    shim_painterwidget.cpp
    shim_painter.cpp
    shim_checkbox.cpp
    shim_combobox.cpp
    shim_textedit.cpp
    shim_menu.cpp
    shim_tabwidget.cpp
    shim_listwidget.cpp
    shim_tablewidget.cpp
    shim_dialog.cpp
    shim_slider.cpp
    shim_spinbox.cpp
    shim_groupbox.cpp
    shim_progressbar.cpp
    shim_statusbar.cpp
    shim_treewidget.cpp
    shim_scrollarea.cpp
    shim_splitter.cpp
    shim_toolbar.cpp
    shim_stackedwidget.cpp
    shim_colordialog.cpp
    shim_fontdialog.cpp
    shim_dial.cpp
    shim_lcdnumber.cpp
    shim_dockwidget.cpp
    shim_gridlayout.cpp
    shim_formlayout.cpp
    shim_buttongroup.cpp
    shim_systemtrayicon.cpp
    shim_dateedit.cpp
    shim_calendarwidget.cpp
    shim_timer.cpp
    shim_clipboard.cpp
    shim_inputdialog.cpp
    shim_settings.cpp
    shim_shortcut.cpp
    shim_completer.cpp
    shim_icon.cpp
    shim_actiongroup.cpp
    shim_frame.cpp
    shim_scrollbar.cpp
    shim_dragdrop.cpp
    shim_splashscreen.cpp
    shim_wizard.cpp
    shim_printer.cpp
    shim_process.cpp
    shim_network.cpp
    shim_pixmap.cpp
    shim_highlighter.cpp
    shim_fontmetrics.cpp
)
target_include_directories(ebqt6shim PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
target_link_libraries(ebqt6shim PUBLIC Qt6::Widgets Qt6::PrintSupport Qt6::Network)
