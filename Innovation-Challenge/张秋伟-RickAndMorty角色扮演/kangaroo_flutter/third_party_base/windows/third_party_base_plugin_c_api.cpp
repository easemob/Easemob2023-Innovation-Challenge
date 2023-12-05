#include "include/third_party_base/third_party_base_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "third_party_base_plugin.h"

void ThirdPartyBasePluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  third_party_base::ThirdPartyBasePlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
