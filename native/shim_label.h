// eb-qt6 native shim - QLabel. Originally no signals (a quick win to
// pair with QPushButton for the classic "click updates a label" demo)
// - linkActivated (Phase 17) is the first one.
#pragma once

#include "shim_common.h"

extern "C" {

void* eb_qt6_label_create(const char* text);
void eb_qt6_label_set_text(void* label, const char* text);
// Caller frees the result via eb_qt6_free_string.
char* eb_qt6_label_get_text(void* label);
// Loads an image file and displays it, replacing any text. Returns 1
// on success, 0 if the file couldn't be loaded as an image (e.g.
// missing/unsupported format) - the label is left unchanged on
// failure.
int eb_qt6_label_set_pixmap_from_file(void* label, const char* path);
// Sets the label's pixmap from an already-loaded QPixmap handle (see
// shim_pixmap.h) - the label makes its own internal copy (Qt's
// implicit sharing means this is cheap, not a real deep copy), so
// `pixmap` may be destroyed or reused for other widgets/draws right
// after this call returns.
void eb_qt6_label_set_pixmap(void* label, void* pixmap);
// `alignment` matches real Qt::Alignment flag combinations - the
// common ones: 1=Left, 2=Right, 4=HCenter, 0x20=Top, 0x40=Bottom,
// 0x80=VCenter (OR horizontal and vertical together, e.g. 4|0x80 for
// centered both ways - see Qt's own Qt::AlignmentFlag docs for the
// full set).
void eb_qt6_label_set_alignment(void* label, int alignment);
// When on, long text wraps across multiple lines instead of being
// clipped/overflowing - off by default, matching real QLabel.
void eb_qt6_label_set_word_wrap(void* label, int wordWrap);

// Real Qt auto-detects HTML in eb_qt6_label_set_text and renders
// <a href="..."> links automatically - open == 1 makes clicking such a
// link open it in the OS's default handler (a real browser, etc), same
// as QLabel::setOpenExternalLinks(true). Off by default; combine with
// eb_qt6_label_connect_link_activated below to instead handle the
// click yourself (e.g. in-app navigation) without opening anything
// externally.
void eb_qt6_label_set_open_external_links(void* label, int open);
// Fires when the user clicks a link inside the label's rich text -
// `link` (the href) is BORROWED, same convention as
// eb_qt6_lineedit_connect_text_changed's own text parameter. Fires
// regardless of eb_qt6_label_set_open_external_links's own setting.
void eb_qt6_label_connect_link_activated(void* label, EbQt6StringCallback cb, void* userData);

}
