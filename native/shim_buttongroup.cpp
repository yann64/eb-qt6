#include "shim_buttongroup.h"

#include <QAbstractButton>
#include <QButtonGroup>
#include <QObject>
#include <QWidget>

extern "C" {

void* eb_qt6_buttongroup_create(void* parent) { return new QButtonGroup(static_cast<QWidget*>(parent)); }

void eb_qt6_buttongroup_add_button(void* group, void* button) {
    static_cast<QButtonGroup*>(group)->addButton(static_cast<QAbstractButton*>(button));
}

void* eb_qt6_buttongroup_checked_button(void* group) {
    return static_cast<QButtonGroup*>(group)->checkedButton();
}

void eb_qt6_buttongroup_connect_button_clicked(void* group, EbQt6PtrCallback cb, void* userData) {
    QObject::connect(static_cast<QButtonGroup*>(group), &QButtonGroup::buttonClicked,
                      [cb, userData](QAbstractButton* button) {
                          if (cb) cb(userData, button);
                      });
}

}
