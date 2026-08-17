' Raw FFI layer: QPrinter, PDF-file output only (`ebqt6shim`).

Extern "C" Lib "ebqt6shim"
    Declare Function eb_qt6_printer_create_pdf(ByVal path AS ZSTRING) AS ANY PTR
    Declare Function eb_qt6_printer_begin(ByVal printer AS ANY PTR) AS ANY PTR
    Declare Sub eb_qt6_printer_new_page(ByVal printer AS ANY PTR)
    Declare Sub eb_qt6_printer_end(ByVal printer AS ANY PTR)
End Extern
