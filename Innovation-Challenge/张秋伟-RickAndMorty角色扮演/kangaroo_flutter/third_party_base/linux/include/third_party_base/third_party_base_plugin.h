#ifndef FLUTTER_PLUGIN_THIRD_PARTY_BASE_PLUGIN_H_
#define FLUTTER_PLUGIN_THIRD_PARTY_BASE_PLUGIN_H_

#include <flutter_linux/flutter_linux.h>

G_BEGIN_DECLS

#ifdef FLUTTER_PLUGIN_IMPL
#define FLUTTER_PLUGIN_EXPORT __attribute__((visibility("default")))
#else
#define FLUTTER_PLUGIN_EXPORT
#endif

typedef struct _ThirdPartyBasePlugin ThirdPartyBasePlugin;
typedef struct {
  GObjectClass parent_class;
} ThirdPartyBasePluginClass;

FLUTTER_PLUGIN_EXPORT GType third_party_base_plugin_get_type();

FLUTTER_PLUGIN_EXPORT void third_party_base_plugin_register_with_registrar(
    FlPluginRegistrar* registrar);

G_END_DECLS

#endif  // FLUTTER_PLUGIN_THIRD_PARTY_BASE_PLUGIN_H_
