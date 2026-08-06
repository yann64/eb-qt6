#include "shim_combobox.h"

#include <QComboBox>
#include <QObject>
#include <QString>

extern "C" {

void* eb_qt6_combobox_create() { return new QComboBox(); }

void eb_qt6_combobox_add_item(void* combo, const char* text) {
    static_cast<QComboBox*>(combo)->addItem(QString::fromUtf8(text));
}

char* eb_qt6_combobox_current_text(void* combo) {
    return eb_qt6_dup_qstring(static_cast<QComboBox*>(combo)->currentText());
}

int eb_qt6_combobox_current_index(void* combo) {
    return static_cast<QComboBox*>(combo)->currentIndex();
}

void eb_qt6_combobox_set_current_index(void* combo, int index) {
    static_cast<QComboBox*>(combo)->setCurrentIndex(index);
}

void eb_qt6_combobox_connect_current_index_changed(void* combo, EbQt6IntCallback cb, void* userData) {
    // Qt6 removed the old Qt5-era ambiguous QString overload of this
    // signal (currentTextChanged is now the separate, dedicated signal
    // for that) - &QComboBox::currentIndexChanged resolves to exactly
    // one real signal here, no QOverload<int>::of(...) disambiguation
    // needed.
    QObject::connect(static_cast<QComboBox*>(combo), &QComboBox::currentIndexChanged,
                      [cb, userData](int index) {
                          if (cb) cb(userData, index);
                      });
}

}
