// eb-qt6 native shim - QSplashScreen.
#pragma once

extern "C" {

// Loads an image file to show as the splash. If the file can't be
// loaded as an image, the splash screen is still created and usable,
// just blank (no picture) - matching QPixmap's own silent-failure
// behavior, no separate success flag to check.
void* eb_qt6_splashscreen_create_from_file(const char* path);
void eb_qt6_splashscreen_show(void* splash);
// Real Qt idiom: call this right before showing your real main window,
// then this one closes itself automatically.
void eb_qt6_splashscreen_finish(void* splash, void* mainWindow);
// `message` overlays on top of the splash image - useful for "Loading
// ..." style progress text during startup.
void eb_qt6_splashscreen_show_message(void* splash, const char* message);

}
