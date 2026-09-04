// eb-qt6 native shim - ShimMainWindow, this package's 5th Q_OBJECT
// subclass (still well under eb-haiku's own six-Shim*-class historical
// budget). A subclass is unavoidable here because QWidget::closeEvent is
// a real C++ virtual method Qt calls directly, not a signal (the same
// reason ShimWidget - shim_painterwidget.h - needed one for paintEvent).
//
// eb_qt6_mainwindow_create() now returns a ShimMainWindow instead of a
// plain QMainWindow - a source-compatible upgrade (every existing caller
// still just holds/passes it around as a QMainWindow*) that lets an
// eb_qt6_mainwindow_set_close_callback call be attached to ANY window
// created this way, not just ones that opt in at construction time.
#pragma once

#include <QMainWindow>

// Return nonzero to ALLOW the close to proceed, zero to VETO it -
// matches eb-haiku's own BWindow::QuitRequested polarity (NOT GTK4's
// "close-request" signal, which is the other way around: TRUE vetoes
// there). Called from QMainWindow::closeEvent, translated into
// QCloseEvent::accept()/ignore() internally.
typedef int (*EbQt6CloseCallback)(void* userData);

class ShimMainWindow : public QMainWindow {
    Q_OBJECT

public:
    using QMainWindow::QMainWindow;

    void SetCloseCallback(EbQt6CloseCallback cb, void* userData) {
        fCloseCallback = cb;
        fCloseUserData = userData;
    }

protected:
    void closeEvent(QCloseEvent* event) override;

private:
    EbQt6CloseCallback fCloseCallback = nullptr;
    void* fCloseUserData = nullptr;
};

extern "C" {

void* eb_qt6_mainwindow_create();
void eb_qt6_mainwindow_set_central_widget(void* window, void* widget);
void eb_qt6_mainwindow_set_close_callback(void* window, EbQt6CloseCallback cb, void* userData);

}
