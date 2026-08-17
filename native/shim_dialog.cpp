#include "shim_dialog.h"

#include <QDialog>
#include <QFileDialog>
#include <QMessageBox>
#include <QObject>
#include <QString>
#include <QWidget>

extern "C" {

void* eb_qt6_dialog_create() { return new QDialog(); }

int eb_qt6_dialog_exec(void* dialog) {
    return static_cast<QDialog*>(dialog)->exec() == QDialog::Accepted ? 1 : 0;
}

void eb_qt6_dialog_accept(void* dialog) { static_cast<QDialog*>(dialog)->accept(); }

void eb_qt6_dialog_reject(void* dialog) { static_cast<QDialog*>(dialog)->reject(); }

void eb_qt6_dialog_connect_finished(void* dialog, EbQt6IntCallback cb, void* userData) {
    QObject::connect(static_cast<QDialog*>(dialog), &QDialog::finished,
                      [cb, userData](int result) {
                          if (cb) cb(userData, result == QDialog::Accepted ? 1 : 0);
                      });
}

void eb_qt6_messagebox_information(void* parent, const char* title, const char* text) {
    QMessageBox::information(static_cast<QWidget*>(parent), QString::fromUtf8(title), QString::fromUtf8(text));
}

void eb_qt6_messagebox_warning(void* parent, const char* title, const char* text) {
    QMessageBox::warning(static_cast<QWidget*>(parent), QString::fromUtf8(title), QString::fromUtf8(text));
}

void eb_qt6_messagebox_critical(void* parent, const char* title, const char* text) {
    QMessageBox::critical(static_cast<QWidget*>(parent), QString::fromUtf8(title), QString::fromUtf8(text));
}

int eb_qt6_messagebox_question(void* parent, const char* title, const char* text) {
    QMessageBox::StandardButton result = QMessageBox::question(
        static_cast<QWidget*>(parent), QString::fromUtf8(title), QString::fromUtf8(text));
    return result == QMessageBox::Yes ? 1 : 0;
}

char* eb_qt6_filedialog_get_open_file_name(void* parent, const char* caption, const char* dir, const char* filter) {
    QString result = QFileDialog::getOpenFileName(
        static_cast<QWidget*>(parent), QString::fromUtf8(caption), QString::fromUtf8(dir), QString::fromUtf8(filter));
    return eb_qt6_dup_qstring(result);
}

char* eb_qt6_filedialog_get_save_file_name(void* parent, const char* caption, const char* dir, const char* filter) {
    QString result = QFileDialog::getSaveFileName(
        static_cast<QWidget*>(parent), QString::fromUtf8(caption), QString::fromUtf8(dir), QString::fromUtf8(filter));
    return eb_qt6_dup_qstring(result);
}

}
