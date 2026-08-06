#include "shim_common.h"

#include <cstdlib>
#include <cstring>

#include <QByteArray>
#include <QString>

char* eb_qt6_dup_qstring(const QString& s) {
    QByteArray utf8 = s.toUtf8();
    char* copy = static_cast<char*>(std::malloc(static_cast<size_t>(utf8.size()) + 1));
    std::memcpy(copy, utf8.constData(), static_cast<size_t>(utf8.size()));
    copy[utf8.size()] = '\0';
    return copy;
}

extern "C" {

void eb_qt6_free_string(char* s) { std::free(s); }

}
