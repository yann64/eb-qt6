#include "shim_highlighter.h"

#include <QColor>
#include <QString>
#include <QTextDocument>

ShimSyntaxHighlighter::ShimSyntaxHighlighter(QTextDocument* document) : QSyntaxHighlighter(document) {}

void ShimSyntaxHighlighter::addRule(const QString& pattern, const QColor& color, bool bold) {
    Rule rule;
    rule.pattern = QRegularExpression(pattern);
    rule.format.setForeground(color);
    if (bold) rule.format.setFontWeight(QFont::Bold);
    m_rules.append(rule);
}

void ShimSyntaxHighlighter::highlightBlock(const QString& text) {
    for (const Rule& rule : m_rules) {
        QRegularExpressionMatchIterator it = rule.pattern.globalMatch(text);
        while (it.hasNext()) {
            QRegularExpressionMatch match = it.next();
            setFormat(match.capturedStart(), match.capturedLength(), rule.format);
        }
    }
}

extern "C" {

void* eb_qt6_highlighter_create(void* textEditDocument) {
    return new ShimSyntaxHighlighter(static_cast<QTextDocument*>(textEditDocument));
}

void eb_qt6_highlighter_add_rule(void* highlighter, const char* pattern,
                                  unsigned char r, unsigned char g, unsigned char b, int bold) {
    static_cast<ShimSyntaxHighlighter*>(highlighter)->addRule(
        QString::fromUtf8(pattern), QColor(r, g, b), bold != 0);
}

void eb_qt6_highlighter_rehighlight(void* highlighter) {
    static_cast<ShimSyntaxHighlighter*>(highlighter)->rehighlight();
}

}
