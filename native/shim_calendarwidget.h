// eb-qt6 native shim - QCalendarWidget. Dates are marshaled as separate
// int components, matching shim_dateedit.h's own convention.
#pragma once

extern "C" {

void* eb_qt6_calendarwidget_create();
void eb_qt6_calendarwidget_get_selected_date(void* cal, int* outYear, int* outMonth, int* outDay);
// `year`/`month`/`day` shape matches EbQt6TwoIntCallback's own sibling
// typedefs elsewhere in this package for signals with more than one
// primitive parameter - selectionChanged() itself takes none in real
// Qt, so the shim reads the newly-selected date via selectedDate()
// right when the signal fires and forwards it as three ints instead.
typedef void (*EbQt6DateCallback)(void* userData, int year, int month, int day);
void eb_qt6_calendarwidget_connect_selection_changed(void* cal, EbQt6DateCallback cb, void* userData);

}
