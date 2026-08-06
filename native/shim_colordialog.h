// eb-qt6 native shim - QColorDialog. A static convenience dialog, not a
// persistent widget, matching QMessageBox/QFileDialog (shim_dialog.h).
#pragma once

extern "C" {

// `parent` may be a null ANY PTR for no parent window. `init*` seed the
// dialog's starting color. Fills `out*` and returns 1 if the user
// picked a color (QColor::isValid()), 0 if they cancelled (in which
// case `out*` are left untouched).
int eb_qt6_colordialog_get_color(void* parent, const char* title,
                                  unsigned char initR, unsigned char initG, unsigned char initB,
                                  unsigned char* outR, unsigned char* outG, unsigned char* outB);

}
