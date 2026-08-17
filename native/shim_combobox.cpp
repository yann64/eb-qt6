#include "shim_combobox.h"

#include <QComboBox>
#include <QIcon>
#include <QObject>
#include <QString>

extern "C" {

void* eb_qt6_combobox_create() { return new QComboBox(); }

void eb_qt6_combobox_add_item(void* combo, const char* text) {
    static_cast<QComboBox*>(combo)->addItem(QString::fromUtf8(text));
}

void eb_qt6_combobox_add_item_with_icon_from_theme(void* combo, const char* text, const char* themeIconName) {
    static_cast<QComboBox*>(combo)->addItem(QIcon::fromTheme(QString::fromUtf8(themeIconName)), QString::fromUtf8(text));
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

void eb_qt6_combobox_set_editable(void* combo, int editable) {
    static_cast<QComboBox*>(combo)->setEditable(editable != 0);
}

void eb_qt6_combobox_set_edit_text(void* combo, const char* text) {
    static_cast<QComboBox*>(combo)->setEditText(QString::fromUtf8(text));
}

void eb_qt6_combobox_connect_edit_text_changed(void* combo, EbQt6StringCallback cb, void* userData) {
    QObject::connect(static_cast<QComboBox*>(combo), &QComboBox::editTextChanged,
                      [cb, userData](const QString& text) {
                          if (cb) {
                              char* utf8 = eb_qt6_dup_qstring(text);
                              cb(userData, utf8);
                              eb_qt6_free_string(utf8);
                          }
                      });
}

int eb_qt6_combobox_count(void* combo) { return static_cast<QComboBox*>(combo)->count(); }

void eb_qt6_combobox_clear(void* combo) { static_cast<QComboBox*>(combo)->clear(); }

}
