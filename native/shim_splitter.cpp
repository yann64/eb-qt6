#include "shim_splitter.h"

#include <QList>
#include <QSplitter>
#include <QWidget>

extern "C" {

void* eb_qt6_splitter_create(int orientation) {
    return new QSplitter(static_cast<Qt::Orientation>(orientation));
}

void eb_qt6_splitter_add_widget(void* splitter, void* widget) {
    static_cast<QSplitter*>(splitter)->addWidget(static_cast<QWidget*>(widget));
}

void eb_qt6_splitter_set_sizes_2(void* splitter, int firstSize, int secondSize) {
    static_cast<QSplitter*>(splitter)->setSizes(QList<int>{firstSize, secondSize});
}

}
