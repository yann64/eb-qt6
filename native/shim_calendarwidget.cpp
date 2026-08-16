#include "shim_calendarwidget.h"

#include <QCalendarWidget>
#include <QDate>
#include <QObject>

extern "C" {

void* eb_qt6_calendarwidget_create() { return new QCalendarWidget(); }

void eb_qt6_calendarwidget_get_selected_date(void* cal, int* outYear, int* outMonth, int* outDay) {
    QDate d = static_cast<QCalendarWidget*>(cal)->selectedDate();
    *outYear = d.year();
    *outMonth = d.month();
    *outDay = d.day();
}

void eb_qt6_calendarwidget_connect_selection_changed(void* cal, EbQt6DateCallback cb, void* userData) {
    QCalendarWidget* calendar = static_cast<QCalendarWidget*>(cal);
    QObject::connect(calendar, &QCalendarWidget::selectionChanged, [cb, userData, calendar]() {
        if (cb) {
            QDate d = calendar->selectedDate();
            cb(userData, d.year(), d.month(), d.day());
        }
    });
}

}
