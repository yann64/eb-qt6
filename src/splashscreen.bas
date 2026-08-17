' Idiomatic layer: QSplashScreen.

#include once "widget.bas"
#include once "raw/qt6_splashscreen.bas"

TYPE SplashScreen EXTENDS QtWidget
END TYPE

''' Loads an image file to show as the splash. If the file can't be
''' loaded as an image, the splash screen is still created and usable,
''' just blank (no picture).
FUNCTION NewSplashScreenFromFile(path AS ZSTRING) AS SplashScreen
    DIM s AS SplashScreen
    s.handle = eb_qt6_splashscreen_create_from_file(path)
    NewSplashScreenFromFile = s
END FUNCTION

SUB SplashScreenShow(BYVAL s AS SplashScreen)
    CALL eb_qt6_splashscreen_show(s.handle)
END SUB

''' Real Qt idiom: call this right before showing your real main
''' window - the splash screen then closes itself automatically.
SUB SplashScreenFinish(BYVAL s AS SplashScreen, BYVAL mainWindow AS QtWidget)
    CALL eb_qt6_splashscreen_finish(s.handle, mainWindow.handle)
END SUB

''' Overlays `message` on top of the splash image - useful for
''' "Loading..." style progress text during startup.
SUB SplashScreenShowMessage(BYVAL s AS SplashScreen, message AS ZSTRING)
    CALL eb_qt6_splashscreen_show_message(s.handle, message)
END SUB
