' Idiomatic layer: QLabel - no signals, a quick win to pair with Button
' for the classic "click updates a label" demo.

#include once "widget.bas"
#include once "common.bas"
#include once "pixmap.bas"
#include once "raw/qt6_label.bas"

TYPE Label EXTENDS QtWidget
END TYPE

FUNCTION NewLabel(text AS ZSTRING) AS Label
    DIM l AS Label
    l.handle = eb_qt6_label_create(text)
    NewLabel = l
END FUNCTION

SUB LabelSetText(BYVAL l AS Label, text AS ZSTRING)
    CALL eb_qt6_label_set_text(l.handle, text)
END SUB

''' See ButtonGetText's own doc comment on the owned-allocation/
''' FreeQtString convention.
FUNCTION LabelGetText(BYVAL l AS Label) AS ANY PTR
    LabelGetText = eb_qt6_label_get_text(l.handle)
END FUNCTION

''' Loads an image file and displays it, replacing any text. Returns
''' non-zero on success, zero if the file couldn't be loaded as an
''' image (e.g. missing/unsupported format) - the label is left
''' unchanged on failure.
FUNCTION LabelSetPixmapFromFile(BYVAL l AS Label, path AS ZSTRING) AS INTEGER
    LabelSetPixmapFromFile = eb_qt6_label_set_pixmap_from_file(l.handle, path)
END FUNCTION

''' Sets the label's pixmap from an already-loaded Pixmap (pixmap.bas)
''' - the label makes its own internal copy, so `p` may be destroyed or
''' reused for other widgets/draws right after this call returns.
''' Preferred over LabelSetPixmapFromFile for anything setting the same
''' image on many labels, or repeatedly (no repeated file I/O).
SUB LabelSetPixmap(BYVAL l AS Label, BYVAL p AS Pixmap)
    CALL eb_qt6_label_set_pixmap(l.handle, p.handle)
END SUB

''' Matches real Qt::AlignmentFlag values - combine a horizontal and a
''' vertical one via eBasic's own bitwise `OR` operator (e.g.
''' `QtAlignHCenter OR QtAlignVCenter`) and pass to LabelSetAlignment.
CONST QtAlignLeft = 1
CONST QtAlignRight = 2
CONST QtAlignHCenter = 4
CONST QtAlignTop = 32
CONST QtAlignBottom = 64
CONST QtAlignVCenter = 128

SUB LabelSetAlignment(BYVAL l AS Label, alignment AS INTEGER)
    CALL eb_qt6_label_set_alignment(l.handle, alignment)
END SUB

''' When on, long text wraps across multiple lines instead of being
''' clipped/overflowing - off by default, matching real QLabel.
SUB LabelSetWordWrap(BYVAL l AS Label, wordWrap AS INTEGER)
    CALL eb_qt6_label_set_word_wrap(l.handle, wordWrap)
END SUB

''' Real Qt auto-detects HTML in LabelSetText and renders
''' <a href="..."> links automatically - openExternal on (non-zero)
''' makes clicking such a link open it in the OS's default handler (a
''' real browser, etc). Off by default; combine with
''' LabelConnectLinkActivated to instead handle the click yourself
''' (e.g. in-app navigation) without opening anything externally.
SUB LabelSetOpenExternalLinks(BYVAL l AS Label, openExternal AS INTEGER)
    CALL eb_qt6_label_set_open_external_links(l.handle, openExternal)
END SUB

''' Connects `handler` (a top-level `SUB YourName(userData AS ANY PTR,
''' link AS ZSTRING)`) to fire when the user clicks a link inside the
''' label's rich text - `link` (the href) is borrowed, same convention
''' as LineEditConnectTextChanged's own text parameter. Fires
''' regardless of LabelSetOpenExternalLinks's own setting.
SUB LabelConnectLinkActivated(BYVAL l AS Label, handler AS ANY PTR, userData AS ANY PTR)
    CALL eb_qt6_label_connect_link_activated(l.handle, handler, userData)
END SUB
