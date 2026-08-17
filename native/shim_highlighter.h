// eb-qt6 native shim - QSyntaxHighlighter, rule-based: a list of
// (regex pattern -> color/bold) rules applied to every line, not a
// full per-character callback into eBasic. Matches how most real
// syntax highlighters are actually built (including Qt's own official
// examples) and avoids a per-line FFI round trip into eBasic on every
// keystroke.
//
// ShimSyntaxHighlighter needs a real QSyntaxHighlighter subclass
// (Q_OBJECT, like ShimWidget/ShimDragSourceFilter/
// ShimDropTargetFilter before it - see shim_painterwidget.h/
// shim_dragdrop.h's own top comments) because highlightBlock() can
// only be overridden by subclassing, the same reason PainterWidget
// needed one back in Phase 1.
#pragma once

#include <QRegularExpression>
#include <QSyntaxHighlighter>
#include <QTextCharFormat>
#include <QVector>

class ShimSyntaxHighlighter : public QSyntaxHighlighter {
    Q_OBJECT

public:
    explicit ShimSyntaxHighlighter(QTextDocument* document);

    void addRule(const QString& pattern, const QColor& color, bool bold);

protected:
    void highlightBlock(const QString& text) override;

private:
    struct Rule {
        QRegularExpression pattern;
        QTextCharFormat format;
    };
    QVector<Rule> m_rules;
};

extern "C" {

// `textEditDocument` must be a real QTextDocument* from
// eb_qt6_textedit_document (shim_textedit.h). The highlighter attaches
// itself to the document immediately and stays attached for the
// document's lifetime - no separate "install" call, no destroy
// function needed here (parented to the document itself, the same
// "container now owns it" convention used throughout this package).
void* eb_qt6_highlighter_create(void* textEditDocument);
// Adds a rule: any text matching `pattern` (a real QRegularExpression,
// matched per line) is rendered in the given color, optionally bold.
// Rules are applied in the order added - a later rule's match
// overrides an earlier one's for overlapping text. Takes effect
// immediately and on every future edit - no separate "apply"/
// "rehighlight" call needed.
void eb_qt6_highlighter_add_rule(void* highlighter, const char* pattern,
                                  unsigned char r, unsigned char g, unsigned char b, int bold);
// Forces every existing block to be re-scanned against the current
// rule set right now - needed if rules are added after text already
// exists in the document (new edits are always highlighted
// automatically either way, with no separate call needed).
void eb_qt6_highlighter_rehighlight(void* highlighter);

}
