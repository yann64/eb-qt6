' Idiomatic layer: QSyntaxHighlighter, rule-based - a list of
' (regex pattern -> color/bold) rules applied to every line, not a
' full per-character callback into eBasic. Matches how most real
' syntax highlighters are actually built and avoids a per-line FFI
' round trip into eBasic on every keystroke.

#include once "textedit.bas"
#include once "raw/qt6_highlighter.bas"

TYPE SyntaxHighlighter EXTENDS QtObject
END TYPE

''' Attaches to `document` (TextEditDocument) immediately and stays
''' attached for the document's lifetime - no separate "install" call,
''' no destroy function needed (parented to the document itself, the
''' same "container now owns it" convention used throughout this
''' package).
FUNCTION NewSyntaxHighlighter(BYVAL document AS ANY PTR) AS SyntaxHighlighter
    DIM h AS SyntaxHighlighter
    h.handle = eb_qt6_highlighter_create(document)
    NewSyntaxHighlighter = h
END FUNCTION

''' Adds a rule: any text matching `pattern` (a real regular
''' expression, matched per line) is rendered in the given color,
''' optionally bold. Rules are applied in the order added - a later
''' rule's match overrides an earlier one's for overlapping text.
''' Takes effect immediately and on every future edit - call
''' HighlighterRehighlight afterward if `document` already has text in
''' it and you want this rule applied retroactively.
SUB HighlighterAddRule(BYVAL h AS SyntaxHighlighter, pattern AS ZSTRING, r AS UBYTE, g AS UBYTE, b AS UBYTE, bold AS INTEGER)
    CALL eb_qt6_highlighter_add_rule(h.handle, pattern, r, g, b, bold)
END SUB

''' Forces every existing block to be re-scanned against the current
''' rule set right now.
SUB HighlighterRehighlight(BYVAL h AS SyntaxHighlighter)
    CALL eb_qt6_highlighter_rehighlight(h.handle)
END SUB
