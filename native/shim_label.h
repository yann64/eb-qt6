// eb-qt6 native shim - QLabel. No signals - a quick win to pair with
// QPushButton for the classic "click updates a label" demo.
#pragma once

extern "C" {

void* eb_qt6_label_create(const char* text);
void eb_qt6_label_set_text(void* label, const char* text);
// Caller frees the result via eb_qt6_free_string.
char* eb_qt6_label_get_text(void* label);

}
