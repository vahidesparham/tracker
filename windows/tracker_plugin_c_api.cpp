#include "include/tracker/tracker_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "tracker_plugin.h"

void TrackerPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  tracker::TrackerPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
