' Raw FFI layer: QPixmap (`ebqt6shim`).

Extern "C" Lib "ebqt6shim"
    Declare Function eb_qt6_pixmap_create_from_file(ByVal path AS ZSTRING) AS ANY PTR
    Declare Function eb_qt6_pixmap_is_null(ByVal pixmap AS ANY PTR) AS INTEGER
    Declare Function eb_qt6_pixmap_width(ByVal pixmap AS ANY PTR) AS INTEGER
    Declare Function eb_qt6_pixmap_height(ByVal pixmap AS ANY PTR) AS INTEGER
    Declare Sub eb_qt6_pixmap_destroy(ByVal pixmap AS ANY PTR)
End Extern
