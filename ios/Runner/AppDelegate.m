#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import <UMCommon/UMConfigure.h>
#import "FlutterNativePlugin.h"
#import <SVProgressHUD/SVProgressHUD.h>
#
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  [FlutterNativePlugin registerWithRegistrar:[self registrarForPlugin:@"FlutterNativePlugin"]];
  // Override point for customization after application launch.
  [UMConfigure setLogEnabled:YES];
  [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
