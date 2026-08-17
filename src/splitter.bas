' Idiomatic layer: QSplitter.
'
' QtHorizontal/QtVertical (Qt::Orientation values, also used by
' NewSlider) live in common.bas.

#include once "widget.bas"
#include once "common.bas"
#include once "raw/qt6_splitter.bas"

TYPE Splitter EXTENDS QtWidget
END TYPE

''' `orientation` matches real Qt::Orientation values - pass QtHorizontal
''' or QtVertical (defined in common.bas).
FUNCTION NewSplitter(orientation AS INTEGER) AS Splitter
    DIM s AS Splitter
    s.handle = eb_qt6_splitter_create(orientation)
    NewSplitter = s
END FUNCTION

''' The splitter now owns `widget` - see widget.bas's own top comment on
''' the "container now owns it" convention.
SUB SplitterAddWidget(BYVAL s AS Splitter, BYVAL widget AS QtWidget)
    CALL eb_qt6_splitter_add_widget(s.handle, widget.handle)
END SUB

''' Sets the first two panes' initial pixel sizes (covers the common
''' two-pane case; any panes beyond the first two keep their default
''' size). Real Qt treats these as proportional weights, not hard pixel
''' constraints - the splitter still respects each widget's own
''' minimum size.
SUB SplitterSetSizes2(BYVAL s AS Splitter, firstSize AS INTEGER, secondSize AS INTEGER)
    CALL eb_qt6_splitter_set_sizes_2(s.handle, firstSize, secondSize)
END SUB
