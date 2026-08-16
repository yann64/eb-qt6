// eb-qt6 native shim - QFrame, a simple bordered/shadowed container
// widget for visual grouping, distinct from QGroupBox (shim_groupbox.h)
// in having no title. A real QWidget subclass, so WidgetShow/
// WidgetSetLayout/etc. (shim_widget.h) already work on its handle.
#pragma once

extern "C" {

void* eb_qt6_frame_create();
// `shape`/`shadow` match real Qt::QFrame::Shape/Shadow enum values:
// shape - 0=NoFrame, 1=Box, 2=Panel, 4=StyledPanel, 5=HLine, 6=VLine
// shadow - 0x10=Plain, 0x20=Raised, 0x30=Sunken
void eb_qt6_frame_set_frame_style(void* frame, int shape, int shadow);

}
