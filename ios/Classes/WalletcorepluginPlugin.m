#import "WalletcorepluginPlugin.h"
#if __has_include(<walletcoreplugin/walletcoreplugin-Swift.h>)
#import <walletcoreplugin/walletcoreplugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "walletcoreplugin-Swift.h"
#endif

@implementation WalletcorepluginPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftWalletcorepluginPlugin registerWithRegistrar:registrar];
}
@end
