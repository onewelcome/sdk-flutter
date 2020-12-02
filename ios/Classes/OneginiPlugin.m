#import "OneginiPlugin.h"
#if __has_include(<onegini/onegini-Swift.h>)
#import <onegini/onegini-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "onegini-Swift.h"
#endif

@implementation OneginiPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftOneginiPlugin registerWithRegistrar:registrar];
}
@end
