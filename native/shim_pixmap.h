// eb-qt6 native shim - QPixmap, a standalone loaded-once image handle.
//
// PainterDrawPixmap (shim_painter.h) and LabelSetPixmapFromFile
// (shim_label.h) have loaded an image file fresh on every single call
// since Phase 1/10 - fine for one-off demos, but a real app repainting
// often (animation, resize) pays the file-decode cost every single
// frame. This shim loads once into a real QPixmap and lets callers
// reuse the same decoded image across many draws/labels.
//
// QPixmap is a plain value type, not a QObject/QWidget - it has no
// natural parent to tie its lifetime to (unlike every other handle in
// this package since Phase 7's QTimer), so it needs an explicit
// destroy function, the first one since eb_qt6_widget_destroy itself.
#pragma once

extern "C" {

// Always returns a real (non-null) handle, even if `path` couldn't be
// loaded - check eb_qt6_pixmap_is_null before using it, matching
// QPixmap's own silent-failure behavior (an invalid/empty pixmap, not
// a crash or exception).
void* eb_qt6_pixmap_create_from_file(const char* path);
int eb_qt6_pixmap_is_null(void* pixmap);
int eb_qt6_pixmap_width(void* pixmap);
int eb_qt6_pixmap_height(void* pixmap);
// QPixmap has no natural widget-tree owner (see this file's own top
// comment) - call this explicitly once nothing needs the pixmap
// anymore. Safe to call after every consumer (labels, draw calls) has
// already used it - Qt's implicit sharing means a QLabel that already
// had SetPixmap called on it keeps its own internal copy, unaffected
// by destroying the original handle.
void eb_qt6_pixmap_destroy(void* pixmap);
// Writes the pixmap to `path` in the format implied by its extension
// (.png, .jpg, ...) - real QPixmap::save. Returns 1 on success, 0 on
// failure (e.g. an unwritable path or unrecognized extension).
int eb_qt6_pixmap_save(void* pixmap, const char* path);

}
