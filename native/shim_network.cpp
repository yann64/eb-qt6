#include "shim_network.h"

#include <QEventLoop>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QObject>
#include <QString>
#include <QTimer>
#include <QUrl>
#include <QVariant>

extern "C" {

void* eb_qt6_network_manager_create(void* parent) {
    return new QNetworkAccessManager(static_cast<QObject*>(parent));
}

void* eb_qt6_network_get(void* manager, const char* url) {
    QNetworkRequest request(QUrl(QString::fromUtf8(url)));
    return static_cast<QNetworkAccessManager*>(manager)->get(request);
}

int eb_qt6_network_reply_wait_for_finished(void* reply, int timeoutMs) {
    QNetworkReply* r = static_cast<QNetworkReply*>(reply);
    if (r->isFinished()) return 1;
    QEventLoop loop;
    QObject::connect(r, &QNetworkReply::finished, &loop, &QEventLoop::quit);
    if (timeoutMs >= 0) {
        QTimer::singleShot(timeoutMs, &loop, &QEventLoop::quit);
    }
    loop.exec();
    return r->isFinished() ? 1 : 0;
}

void eb_qt6_network_reply_connect_finished(void* reply, EbQt6VoidCallback cb, void* userData) {
    QObject::connect(static_cast<QNetworkReply*>(reply), &QNetworkReply::finished,
                      [cb, userData]() {
                          if (cb) cb(userData);
                      });
}

int eb_qt6_network_reply_has_error(void* reply) {
    return static_cast<QNetworkReply*>(reply)->error() != QNetworkReply::NoError ? 1 : 0;
}

char* eb_qt6_network_reply_error_string(void* reply) {
    return eb_qt6_dup_qstring(static_cast<QNetworkReply*>(reply)->errorString());
}

int eb_qt6_network_reply_status_code(void* reply) {
    QVariant status = static_cast<QNetworkReply*>(reply)->attribute(QNetworkRequest::HttpStatusCodeAttribute);
    return status.isValid() ? status.toInt() : 0;
}

char* eb_qt6_network_reply_read_all(void* reply) {
    QByteArray bytes = static_cast<QNetworkReply*>(reply)->readAll();
    return eb_qt6_dup_qstring(QString::fromUtf8(bytes));
}

void eb_qt6_network_reply_delete_later(void* reply) {
    static_cast<QNetworkReply*>(reply)->deleteLater();
}

}
