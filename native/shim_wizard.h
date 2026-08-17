// eb-qt6 native shim - QWizard/QWizardPage. Unlike most real-world Qt
// wizard code, no QWizardPage subclassing is needed here - a plain
// QWizardPage instance works fine with WidgetSetLayout (shim_widget.h)
// composing its contents, the same "compose an existing widget with an
// existing layout" pattern used everywhere else in this package. The
// wizard itself provides Next/Back/Finish/Cancel navigation
// automatically - nothing to wire up manually.
#pragma once

#include "shim_common.h"

extern "C" {

void* eb_qt6_wizard_create();
void* eb_qt6_wizardpage_create(const char* title);
// Returns the new page's index. The wizard now owns `page` - the same
// "container now owns it" convention as QBoxLayout::addWidget.
int eb_qt6_wizard_add_page(void* wizard, void* page);
void eb_qt6_wizard_show(void* wizard);
// QWizard::Wizard::accepted() signal - fires when the user completes
// the wizard via the Finish button (not Cancel/close).
void eb_qt6_wizard_connect_accepted(void* wizard, EbQt6VoidCallback cb, void* userData);

}
