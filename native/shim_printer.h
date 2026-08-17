// eb-qt6 native shim - QPrinter, restricted to PDF-file output (not a
// real printer/print dialog) - this sandbox has no real printer to
// test against, and PDF-to-file is the one printing path fully
// testable without any interaction: write a file, then check it
// exists and has non-zero size. A real QPrintDialog isn't bound.
//
// Like QApplication itself, QPrinter aborts the process (a Qt fatal
// log, not a C++ exception) if constructed before a QCoreApplication
// exists - confirmed by direct reproduction. Callers must construct
// the Application (eb_qt6_application_create) before the first
// eb_qt6_printer_create_pdf call.
#pragma once

extern "C" {

// `path` should end in ".pdf" - real Qt doesn't enforce this, but a
// real printer driver would otherwise be selected instead of the PDF
// one, which this shim deliberately forces via QPrinter::setOutputFormat.
void* eb_qt6_printer_create_pdf(const char* path);
// Returns the SAME kind of `painter` handle a PainterWidget's paint
// callback receives - every eb_qt6_painter_* drawing primitive
// (shim_painter.h) works on it identically. Only valid between this
// call and eb_qt6_printer_end - matches QPainter's own begin()/end()
// RAII bracketing requirement (see shim_painterwidget.h's own
// confirmed-not-crashing-but-silently-inert-after-end note, which
// applies here too).
void* eb_qt6_printer_begin(void* printer);
// Starts a new blank page - call between drawing primitives to print
// more than one page.
void eb_qt6_printer_new_page(void* printer);
// Finalizes and writes the PDF file to disk. The `painter` handle from
// eb_qt6_printer_begin is invalid after this call.
void eb_qt6_printer_end(void* printer);

}
