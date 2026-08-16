// eb-qt6 native shim - QLabel. No signals - a quick win to pair with
// QPushButton for the classic "click updates a label" demo.
#pragma once

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
// `alignment` matches real Qt::Alignment flag combinations - the
// common ones: 1=Left, 2=Right, 4=HCenter, 0x20=Top, 0x40=Bottom,
// 0x80=VCenter (OR horizontal and vertical together, e.g. 4|0x80 for
// centered both ways - see Qt's own Qt::AlignmentFlag docs for the
// full set).
void eb_qt6_label_set_alignment(void* label, int alignment);
// When on, long text wraps across multiple lines instead of being
// clipped/overflowing - off by default, matching real QLabel.
void eb_qt6_label_set_word_wrap(void* label, int wordWrap);

}
