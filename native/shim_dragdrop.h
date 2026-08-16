// eb-qt6 native shim - drag-and-drop, implemented via QObject event
// filters rather than a widget subclass, so it works on ANY existing
// widget (Label, Button, LineEdit, ...) without needing a dedicated
// Shim* subclass per draggable/droppable widget type - a deliberately
// different approach from ShimWidget (shim_painterwidget.h), which
// exists specifically because QWidget::paintEvent can only be
// overridden by subclassing. QObject::installEventFilter lets a
// second, separate QObject intercept another QObject's events without
// subclassing it - exactly what's needed for drag source
// (MouseButtonPress/MouseMove) and drop target (DragEnter/Drop)
// behavior on a widget whose real C++ class this package never
// subclasses.
//
// Two small filter classes (both need Q_OBJECT/moc, the 2nd and 3rd
// Q_OBJECT classes in this package's history after ShimWidget) - each
// `new`'d with the watched widget as its own QObject parent, so Qt
// manages its lifetime automatically, tied to the widget (matches the
// "container now owns it" convention used elsewhere, e.g. validators
// parented to their line edit in shim_lineedit.cpp).
#pragma once

#include "shim_common.h"

#include <QObject>
#include <QPoint>
#include <QString>

// Starts a QDrag carrying fixed text (fDragText) once the mouse moves
// past Qt's own real drag-start distance threshold while the left
// button is held - matches the standard real-Qt "click and drag"
// gesture recognition, not a custom threshold.
class ShimDragSourceFilter : public QObject {
    Q_OBJECT

public:
    ShimDragSourceFilter(QObject* watched, const QString& dragText)
        : QObject(watched), fDragText(dragText) {}

protected:
    bool eventFilter(QObject* watched, QEvent* event) override;

private:
    QString fDragText;
    QPoint fPressPos;
    bool fPressed = false;
};

// Accepts a drop carrying plain text and forwards it to a stored C
// callback - does NOT accept other MIME types (files, images, etc.),
// not bound in this package yet.
class ShimDropTargetFilter : public QObject {
    Q_OBJECT

public:
    ShimDropTargetFilter(QObject* watched, EbQt6StringCallback cb, void* userData)
        : QObject(watched), fCallback(cb), fUserData(userData) {}

protected:
    bool eventFilter(QObject* watched, QEvent* event) override;

private:
    EbQt6StringCallback fCallback;
    void* fUserData;
};

extern "C" {

void eb_qt6_widget_enable_drag_source(void* widget, const char* dragText);
void eb_qt6_widget_enable_drop_target(void* widget, EbQt6StringCallback cb, void* userData);

}
