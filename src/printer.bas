' Idiomatic layer: QPrinter, restricted to PDF-file output (not a real
' printer/print dialog) - this sandbox has no real printer to test
' against, and PDF-to-file is the one printing path fully testable
' without any interaction: write a file, then check it exists and has
' non-zero size. A real print dialog isn't bound.

#include once "widget.bas"
#include once "raw/qt6_printer.bas"

TYPE Printer EXTENDS QtObject
END TYPE

''' `path` should end in ".pdf".
FUNCTION NewPdfPrinter(path AS ZSTRING) AS Printer
    DIM p AS Printer
    p.handle = eb_qt6_printer_create_pdf(path)
    NewPdfPrinter = p
END FUNCTION

''' Returns the SAME kind of `painter` handle a PainterWidgetConnectPaint
''' callback receives - every Painter* drawing primitive (painter.bas)
''' works on it identically. Only valid between this call and
''' PrinterEnd - matches QPainter's own begin()/end() RAII bracketing
''' requirement.
FUNCTION PrinterBegin(BYVAL p AS Printer) AS ANY PTR
    PrinterBegin = eb_qt6_printer_begin(p.handle)
END FUNCTION

''' Starts a new blank page - call between drawing primitives to print
''' more than one page.
SUB PrinterNewPage(BYVAL p AS Printer)
    CALL eb_qt6_printer_new_page(p.handle)
END SUB

''' Finalizes and writes the PDF file to disk. The `painter` handle
''' from PrinterBegin is invalid after this call.
SUB PrinterEnd(BYVAL p AS Printer)
    CALL eb_qt6_printer_end(p.handle)
END SUB
