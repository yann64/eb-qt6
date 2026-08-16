#include "shim_dateedit.h"

#include <QDate>
#include <QDateEdit>
#include <QTime>
#include <QTimeEdit>

extern "C" {

void* eb_qt6_dateedit_create() { return new QDateEdit(); }

void eb_qt6_dateedit_set_date(void* edit, int year, int month, int day) {
    static_cast<QDateEdit*>(edit)->setDate(QDate(year, month, day));
}

void eb_qt6_dateedit_get_date(void* edit, int* outYear, int* outMonth, int* outDay) {
    QDate d = static_cast<QDateEdit*>(edit)->date();
    *outYear = d.year();
    *outMonth = d.month();
    *outDay = d.day();
}

void* eb_qt6_timeedit_create() { return new QTimeEdit(); }

void eb_qt6_timeedit_set_time(void* edit, int hour, int minute, int second) {
    static_cast<QTimeEdit*>(edit)->setTime(QTime(hour, minute, second));
}

void eb_qt6_timeedit_get_time(void* edit, int* outHour, int* outMinute, int* outSecond) {
    QTime t = static_cast<QTimeEdit*>(edit)->time();
    *outHour = t.hour();
    *outMinute = t.minute();
    *outSecond = t.second();
}

}
