' Idiomatic layer: QPixmap, a standalone loaded-once image handle.
'
' PainterDrawPixmap (painter.bas) and LabelSetPixmapFromFile
' (label.bas) load an image file fresh on every single call - fine for
' one-off demos, but a real app repainting often (animation, resize)
' pays the file-decode cost every single frame. Load once via
' NewPixmapFromFile and reuse the same Pixmap across many
' PainterDrawPixmapHandle/LabelSetPixmap calls instead.
'
' A plain value type, not a QObject/QWidget - it has no natural parent
' to tie its lifetime to (unlike every other handle in this package
' since Phase 7's QTimer), so it needs an explicit PixmapDestroy.

#include once "widget.bas"
#include once "common.bas"
#include once "raw/qt6_pixmap.bas"

TYPE Pixmap EXTENDS QtObject
END TYPE

''' Always returns a real (non-null) handle, even if `path` couldn't be
''' loaded - check PixmapIsNull before using it, matching QPixmap's own
''' silent-failure behavior (an invalid/empty pixmap, not a crash).
FUNCTION NewPixmapFromFile(path AS ZSTRING) AS Pixmap
    DIM p AS Pixmap
    p.handle = eb_qt6_pixmap_create_from_file(path)
    NewPixmapFromFile = p
END FUNCTION

FUNCTION PixmapIsNull(BYVAL p AS Pixmap) AS INTEGER
    PixmapIsNull = eb_qt6_pixmap_is_null(p.handle)
END FUNCTION

FUNCTION PixmapWidth(BYVAL p AS Pixmap) AS INTEGER
    PixmapWidth = eb_qt6_pixmap_width(p.handle)
END FUNCTION

FUNCTION PixmapHeight(BYVAL p AS Pixmap) AS INTEGER
    PixmapHeight = eb_qt6_pixmap_height(p.handle)
END FUNCTION

''' QPixmap has no natural widget-tree owner (see this file's own top
''' comment) - call this explicitly once nothing needs the pixmap
''' anymore. Safe to call even after a label/draw call already used it
''' - Qt's implicit sharing means those consumers keep their own
''' internal copy, unaffected by destroying the original handle.
SUB PixmapDestroy(BYVAL p AS Pixmap)
    CALL eb_qt6_pixmap_destroy(p.handle)
END SUB
