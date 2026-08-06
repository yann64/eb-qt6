#include "shim_groupbox.h"

#include <QGroupBox>
#include <QString>

extern "C" {

void* eb_qt6_groupbox_create(const char* title) { return new QGroupBox(QString::fromUtf8(title)); }

}
