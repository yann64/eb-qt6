#include "shim_printer.h"

#include <QPainter>
#include <QPrinter>
#include <QString>

// The `printer` handle eBasic holds is actually one of these, not a
// bare QPrinter* - needed because the active QPainter must persist
// across separate begin/new_page/end FFI calls (unlike
// PainterWidget's own QPainter, which lives entirely within one C++
// paintEvent call and never needs to survive across calls).
struct EbQt6PrinterHandle {
    QPrinter* printer;
    QPainter* painter = nullptr;
};

extern "C" {

void* eb_qt6_printer_create_pdf(const char* path) {
    QPrinter* printer = new QPrinter();
    printer->setOutputFormat(QPrinter::PdfFormat);
    printer->setOutputFileName(QString::fromUtf8(path));
    EbQt6PrinterHandle* handle = new EbQt6PrinterHandle();
    handle->printer = printer;
    return handle;
}

void* eb_qt6_printer_begin(void* printer) {
    EbQt6PrinterHandle* handle = static_cast<EbQt6PrinterHandle*>(printer);
    handle->painter = new QPainter(handle->printer);
    return handle->painter;
}

void eb_qt6_printer_new_page(void* printer) {
    static_cast<EbQt6PrinterHandle*>(printer)->printer->newPage();
}

void eb_qt6_printer_end(void* printer) {
    EbQt6PrinterHandle* handle = static_cast<EbQt6PrinterHandle*>(printer);
    if (handle->painter) {
        handle->painter->end();
        delete handle->painter;
        handle->painter = nullptr;
    }
}

}
