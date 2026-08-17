// eb-qt6 native shim - QTableWidget (simple item-based API, not the
// full model/view framework).
#pragma once

#include "shim_common.h"

extern "C" {

void* eb_qt6_tablewidget_create();
void eb_qt6_tablewidget_set_row_count(void* table, int rows);
void eb_qt6_tablewidget_set_column_count(void* table, int cols);
// Creates the cell's QTableWidgetItem on first use if none exists yet.
void eb_qt6_tablewidget_set_item_text(void* table, int row, int col, const char* text);
// Caller frees the result via eb_qt6_free_string. Empty string if the
// cell has no item yet.
char* eb_qt6_tablewidget_item_text(void* table, int row, int col);
void eb_qt6_tablewidget_connect_cell_clicked(void* table, EbQt6TwoIntCallback cb, void* userData);
int eb_qt6_tablewidget_row_count(void* table);
int eb_qt6_tablewidget_column_count(void* table);
// Consumes and destroys `labels` (a StringList handle, see
// shim_inputdialog.h's own eb_qt6_stringlist_create) - matches
// eb_qt6_treewidget_set_header_labels's own consume-and-destroy
// convention for the same StringList type.
void eb_qt6_tablewidget_set_horizontal_header_labels(void* table, void* labels);
// Removes row `row` entirely, shifting later rows up - real
// QTableWidget::removeRow.
void eb_qt6_tablewidget_remove_row(void* table, int row);
int eb_qt6_tablewidget_current_row(void* table);
int eb_qt6_tablewidget_current_column(void* table);

}
