//
//  FlutterNativePlugin.m
//  Runner
//
//  Created by iOSDev_glenn on 2021/1/19.
//

#import "FlutterNativePlugin.h"
#import <SVProgressHUD/SVProgressHUD.h>

@implementation FlutterNativePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:@"qxb_method_channel" binaryMessenger:[registrar messenger]];
    FlutterNativePlugin *instance = [[FlutterNativePlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([call.method isEqualToString:@"showHud"]) {
        [SVProgressHUD show];
    }
    if ([call.method isEqualToString:@"dismissHud"]) {
        [SVProgressHUD dismiss];
    }
    if ([call.method isEqualToString:@"showHudWithStatus"]) {
        NSString *msg = call.arguments;
        [SVProgressHUD showInfoWithStatus:msg];
    }
}
@end
