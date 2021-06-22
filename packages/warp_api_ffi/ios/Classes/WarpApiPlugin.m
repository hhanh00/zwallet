#import "WarpApiPlugin.h"
#if __has_include(<warp_api/warp_api-Swift.h>)
#import <warp_api/warp_api-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "warp_api-Swift.h"
#endif

@implementation WarpApiPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftWarpApiPlugin registerWithRegistrar:registrar];
}
@end
