// eb-qt6 native shim - ShimWidget, the ONE class in this whole package
// needing a real C++ subclass (and therefore moc/Q_OBJECT) - every other
// widget forwards its signals via a plain lambda+connect (see
// shim_button.h for that pattern), which needs no subclass at all.
//
// A subclass is unavoidable here specifically because QWidget::paintEvent
// is a real C++ virtual method Qt calls directly, not a signal - the
// same reason eb-haiku needed a ShimView subclass for BView::Draw.
// Budget new Q_OBJECT subclasses like eb-haiku budgets its own Shim*
// classes (six total across its entire history) - not something to add
// per-widget.
//
// IMPORTANT, confirmed by direct reproduction (the same "confirmed, not
// assumed" discipline eb-haiku holds itself to - and a good example of
// why: the actual behavior differs from the naive guess): the
// `QPainter*` handle passed to the paint callback is a C++ stack-local
// constructed fresh inside paintEvent, per Qt's own RAII begin()/end()
// bracketing requirement - it is ONLY valid for the duration of that one
// callback invocation. Calling an eb_qt6_painter_* drawing primitive
// after the callback has returned does NOT crash (verified directly,
// stashing the handle and drawing with it later) - QPainter's own
// internal isActive() check makes it a silent no-op, with a
// "QPainter::fillRect: Painter not active"-style warning printed to
// stderr. Still a real bug if it happens (nothing gets drawn), just a
// safer failure mode than the crash this file originally assumed before
// testing. This mirrors the same restriction eb-haiku's own
// shim_interface.h documents for BView drawing primitives ("callable
// only from within a Draw callback"), with a gentler real consequence.
#pragma once

#include <QWidget>

typedef void (*EbQt6PaintCallback)(void* userData, void* painterHandle);

class ShimWidget : public QWidget {
    Q_OBJECT

public:
    using QWidget::QWidget;

    void SetPaintCallback(EbQt6PaintCallback cb, void* userData) {
        fPaintCallback = cb;
        fPaintUserData = userData;
    }

protected:
    void paintEvent(QPaintEvent* event) override;

private:
    EbQt6PaintCallback fPaintCallback = nullptr;
    void* fPaintUserData = nullptr;
};

extern "C" {

void* eb_qt6_painterwidget_create();
void eb_qt6_painterwidget_set_paint_callback(void* widget, EbQt6PaintCallback cb, void* userData);

}
