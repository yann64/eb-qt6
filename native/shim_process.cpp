#include "shim_process.h"

#include <QObject>
#include <QProcess>
#include <QString>

extern "C" {

void* eb_qt6_process_create(void* parent) {
    return new QProcess(static_cast<QObject*>(parent));
}

void eb_qt6_process_start(void* process, const char* command) {
    static_cast<QProcess*>(process)->startCommand(QString::fromUtf8(command));
}

int eb_qt6_process_wait_for_finished(void* process, int timeoutMs) {
    return static_cast<QProcess*>(process)->waitForFinished(timeoutMs) ? 1 : 0;
}

int eb_qt6_process_exit_code(void* process) { return static_cast<QProcess*>(process)->exitCode(); }

char* eb_qt6_process_read_all_standard_output(void* process) {
    QByteArray bytes = static_cast<QProcess*>(process)->readAllStandardOutput();
    return eb_qt6_dup_qstring(QString::fromUtf8(bytes));
}

char* eb_qt6_process_read_all_standard_error(void* process) {
    QByteArray bytes = static_cast<QProcess*>(process)->readAllStandardError();
    return eb_qt6_dup_qstring(QString::fromUtf8(bytes));
}

void eb_qt6_process_connect_finished(void* process, EbQt6TwoIntCallback cb, void* userData) {
    QObject::connect(static_cast<QProcess*>(process), &QProcess::finished,
                      [cb, userData](int exitCode, QProcess::ExitStatus exitStatus) {
                          if (cb) cb(userData, exitCode, static_cast<int>(exitStatus));
                      });
}

}
