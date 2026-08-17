#include "shim_wizard.h"

#include <QObject>
#include <QString>
#include <QWizard>
#include <QWizardPage>

extern "C" {

void* eb_qt6_wizard_create() { return new QWizard(); }

void* eb_qt6_wizardpage_create(const char* title) {
    QWizardPage* page = new QWizardPage();
    page->setTitle(QString::fromUtf8(title));
    return page;
}

int eb_qt6_wizard_add_page(void* wizard, void* page) {
    return static_cast<QWizard*>(wizard)->addPage(static_cast<QWizardPage*>(page));
}

void eb_qt6_wizard_show(void* wizard) { static_cast<QWizard*>(wizard)->show(); }

void eb_qt6_wizard_connect_accepted(void* wizard, EbQt6VoidCallback cb, void* userData) {
    QObject::connect(static_cast<QWizard*>(wizard), &QWizard::accepted, [cb, userData]() {
        if (cb) cb(userData);
    });
}

}
