#ifndef FLUTTER_PLUGIN_THIRD_PARTY_BASE_PLUGIN_H_
#define FLUTTER_PLUGIN_THIRD_PARTY_BASE_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace third_party_base {

class ThirdPartyBasePlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  ThirdPartyBasePlugin();

  virtual ~ThirdPartyBasePlugin();

  // Disallow copy and assign.
  ThirdPartyBasePlugin(const ThirdPartyBasePlugin&) = delete;
  ThirdPartyBasePlugin& operator=(const ThirdPartyBasePlugin&) = delete;

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace third_party_base

#endif  // FLUTTER_PLUGIN_THIRD_PARTY_BASE_PLUGIN_H_
