#import "BusinessPluginUpdatePlugin.h"
#if __has_include(<business_plugin_update/business_plugin_update-Swift.h>)
#import <business_plugin_update/business_plugin_update-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "business_plugin_update-Swift.h"
#endif

@implementation BusinessPluginUpdatePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftBusinessPluginUpdatePlugin registerWithRegistrar:registrar];
}
@end
