// eb-qt6 native shim - QDateEdit/QTimeEdit. Dates/times are marshaled
// as separate int components (year/month/day, hour/min/sec) rather than
// introducing a QDate/QTime wrapper TYPE - matching this package's
// existing preference for primitive-shaped signals/getters over new
// value types (see EbQt6TwoIntCallback's own top comment in
// shim_common.h).
#pragma once

extern "C" {

void* eb_qt6_dateedit_create();
void eb_qt6_dateedit_set_date(void* edit, int year, int month, int day);
void eb_qt6_dateedit_get_date(void* edit, int* outYear, int* outMonth, int* outDay);

void* eb_qt6_timeedit_create();
void eb_qt6_timeedit_set_time(void* edit, int hour, int minute, int second);
void eb_qt6_timeedit_get_time(void* edit, int* outHour, int* outMinute, int* outSecond);

}
