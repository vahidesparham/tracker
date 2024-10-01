#ifndef FLUTTER_PLUGIN_TRACKER_PLUGIN_H_
#define FLUTTER_PLUGIN_TRACKER_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace tracker {

class TrackerPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  TrackerPlugin();

  virtual ~TrackerPlugin();

  // Disallow copy and assign.
  TrackerPlugin(const TrackerPlugin&) = delete;
  TrackerPlugin& operator=(const TrackerPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace tracker

#endif  // FLUTTER_PLUGIN_TRACKER_PLUGIN_H_
