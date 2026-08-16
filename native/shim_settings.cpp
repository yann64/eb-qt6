#include "shim_settings.h"

#include "shim_common.h"

#include <QSettings>
#include <QString>
#include <QWidget>

extern "C" {

void* eb_qt6_settings_create(const char* organization, const char* application, void* parent) {
    return new QSettings(QString::fromUtf8(organization), QString::fromUtf8(application),
                          static_cast<QWidget*>(parent));
}

void eb_qt6_settings_set_string(void* settings, const char* key, const char* value) {
    static_cast<QSettings*>(settings)->setValue(QString::fromUtf8(key), QString::fromUtf8(value));
}

char* eb_qt6_settings_get_string(void* settings, const char* key, const char* defaultValue) {
    QVariant result = static_cast<QSettings*>(settings)->value(QString::fromUtf8(key), QString::fromUtf8(defaultValue));
    return eb_qt6_dup_qstring(result.toString());
}

void eb_qt6_settings_set_int(void* settings, const char* key, int value) {
    static_cast<QSettings*>(settings)->setValue(QString::fromUtf8(key), value);
}

int eb_qt6_settings_get_int(void* settings, const char* key, int defaultValue) {
    QVariant result = static_cast<QSettings*>(settings)->value(QString::fromUtf8(key), defaultValue);
    return result.toInt();
}

void eb_qt6_settings_sync(void* settings) { static_cast<QSettings*>(settings)->sync(); }

}
