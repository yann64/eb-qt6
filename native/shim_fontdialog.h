// eb-qt6 native shim - QFontDialog. A static convenience dialog, not a
// persistent widget, matching QMessageBox/QFileDialog (shim_dialog.h).
// Only exposes family name + point size, not the full QFont surface
// (bold/italic/underline/etc. aren't bound yet).
#pragma once

extern "C" {

// `parent` may be a null ANY PTR for no parent window. Caller frees the
// result via eb_qt6_free_string. Fills `outPointSize` and `outValid`
// (1 if the user picked a font, 0 if they cancelled) - on cancel, the
// returned string is empty and `outPointSize` is left untouched.
char* eb_qt6_fontdialog_get_font(void* parent, int* outPointSize, int* outValid);

}
