' Idiomatic layer: shared helpers - see native/shim_common.h's own top
' comment on the owned-heap-allocation string-return convention every
' "get text"-style function in this package uses (ButtonGetText,
' LabelGetText, LineEditGetText, ...).

#include once "raw/qt6_common.bas"

''' Matches real Qt::Orientation values - pass directly to NewSlider/
''' NewSplitter.
CONST QtHorizontal = 1
CONST QtVertical = 2

''' Frees a string returned by ButtonGetText/LabelGetText/
''' LineEditGetText (or any of this package's other functions with the
''' same "raw ANY PTR, caller frees it" shape).
SUB FreeQtString(rawPtr AS ANY PTR)
    CALL eb_qt6_free_string(rawPtr)
END SUB
