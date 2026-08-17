' Raw FFI layer: QSyntaxHighlighter, rule-based (`ebqt6shim`).

Extern "C" Lib "ebqt6shim"
    Declare Function eb_qt6_highlighter_create(ByVal textEditDocument AS ANY PTR) AS ANY PTR
    Declare Sub eb_qt6_highlighter_add_rule(ByVal highlighter AS ANY PTR, ByVal pattern AS ZSTRING, ByVal r AS UBYTE, ByVal g AS UBYTE, ByVal b AS UBYTE, ByVal bold AS INTEGER)
    Declare Sub eb_qt6_highlighter_rehighlight(ByVal highlighter AS ANY PTR)
End Extern
