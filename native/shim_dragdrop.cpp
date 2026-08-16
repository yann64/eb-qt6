#include "shim_dragdrop.h"

#include <QApplication>
#include <QDrag>
#include <QDropEvent>
#include <QMimeData>
#include <QMouseEvent>
#include <QWidget>

bool ShimDragSourceFilter::eventFilter(QObject* watched, QEvent* event) {
    switch (event->type()) {
        case QEvent::MouseButtonPress: {
            QMouseEvent* mouseEvent = static_cast<QMouseEvent*>(event);
            if (mouseEvent->button() == Qt::LeftButton) {
                fPressPos = mouseEvent->pos();
                fPressed = true;
            }
            break;
        }
        case QEvent::MouseMove: {
            if (fPressed) {
                QMouseEvent* mouseEvent = static_cast<QMouseEvent*>(event);
                if ((mouseEvent->pos() - fPressPos).manhattanLength() >= QApplication::startDragDistance()) {
                    fPressed = false;
                    QMimeData* mimeData = new QMimeData();
                    mimeData->setText(fDragText);
                    QDrag* drag = new QDrag(qobject_cast<QWidget*>(watched));
                    drag->setMimeData(mimeData);
                    drag->exec(Qt::CopyAction);
                }
            }
            break;
        }
        case QEvent::MouseButtonRelease:
            fPressed = false;
            break;
        default:
            break;
    }
    return false;
}

bool ShimDropTargetFilter::eventFilter(QObject* watched, QEvent* event) {
    (void)watched;
    if (event->type() == QEvent::DragEnter) {
        QDragEnterEvent* dragEvent = static_cast<QDragEnterEvent*>(event);
        if (dragEvent->mimeData()->hasText()) {
            dragEvent->acceptProposedAction();
            return true;
        }
        return false;
    }
    if (event->type() == QEvent::Drop) {
        QDropEvent* dropEvent = static_cast<QDropEvent*>(event);
        if (dropEvent->mimeData()->hasText()) {
            QByteArray utf8 = dropEvent->mimeData()->text().toUtf8();
            if (fCallback) fCallback(fUserData, utf8.constData());
            dropEvent->acceptProposedAction();
            return true;
        }
        return false;
    }
    return false;
}

extern "C" {

void eb_qt6_widget_enable_drag_source(void* widget, const char* dragText) {
    QWidget* w = static_cast<QWidget*>(widget);
    w->installEventFilter(new ShimDragSourceFilter(w, QString::fromUtf8(dragText)));
}

void eb_qt6_widget_enable_drop_target(void* widget, EbQt6StringCallback cb, void* userData) {
    QWidget* w = static_cast<QWidget*>(widget);
    w->setAcceptDrops(true);
    w->installEventFilter(new ShimDropTargetFilter(w, cb, userData));
}

}
