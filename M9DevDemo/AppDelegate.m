//
//  AppDelegate.m
//  M9Dev
//
//  Created by MingLQ on 2014-07-05.
//  Copyright (c) 2014 MingLQ <minglq.9@gmail.com>. All rights reserved.
//

#import "AppDelegate.h"

#import "M9Utilities.h"
#import "M9Networking.h"

#import "M9DevTestTableViewController.h"
#import "M9URLAction.h"
#import "M9URLAction+1.0.h"
#import "VideosJSCollectionViewController+action.h"

#define APP_VERSION_KEY @"CFBundleShortVersionString"
#define APP_VERSION [[[NSBundle mainBundle] objectForInfoDictionaryKey:APP_VERSION_KEY] description]

#define APP_BUILD_VERSION_KEY @"CFBundleVersion"
#define APP_BUILD_VERSION [[[NSBundle mainBundle] objectForInfoDictionaryKey:APP_BUILD_VERSION_KEY] description]

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"<#format#>: %@ - %@", APP_VERSION, APP_BUILD_VERSION);
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    // M9NETWORKING.requestConfig.baseURL = [NSURL URLWithString:@"http://localhost:3000"];
    M9NETWORKING.requestConfig.baseURL = [NSURL URLWithString:@"http://10.2.10.187:3000"];
    M9NETWORKING.requestConfig.dataParser = M9ResponseDataParser_All;
    
    UIViewController *rootViewController = [[M9DevTestTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    
    [M9URLAction setActionSettings:
     @{ @"action.hello":
            [M9URLActionSetting actionSettingWithBlock:^void(M9URLAction *action, M9URLActionFinishBlock finish)
             {
                 NSLog(@"%@", action);
                 if (finish) finish(@{ @"x": @1, @"y": @2 });
             }],
        @"action.test":
            [M9URLActionSetting actionSettingWithTarget:self
                                       actionSelector:@selector(testWithAction:finish:)],
        @"webview.open":
            [M9URLActionSetting actionSettingWithBlock:^void(M9URLAction *action, M9URLActionFinishBlock finish)
             {
                 NSLog(@"%@", action);
                 if (finish) finish(@{ @"x": @1, @"y": @2 });
             }],
        @"channel.goto":
            [M9URLActionSetting actionSettingWithBlock:^void(M9URLAction *action, M9URLActionFinishBlock finish)
             {
                 NSLog(@"%@", action);
                 if (finish) finish(@{ @"x": @1, @"y": @2 });
             }],
        @"videos.open":
            [M9URLActionSetting actionSettingWithTarget:[VideosJSCollectionViewController class]
                                     instanceSelector:@selector(new)
                                       actionSelector:@selector(openWithAction:finish:)],
        @"videos.goto":
            [M9URLActionSetting actionSettingWithTarget:[VideosJSCollectionViewController class]
                                     instanceSelector:@selector(new)
                                       actionSelector:@selector(gotoWithAction:finish:)],
        @"root.goto":
            [M9URLActionSetting actionSettingWithBlock:^void(M9URLAction *action, M9URLActionFinishBlock finish)
             {
                 __block UIViewController *rootViewController = [UIViewController gotoRootViewControllerAnimated:YES completion:^{
                     NSLog(@"rootViewController: %@", rootViewController);
                     if (finish) finish(@{ @"key": @"value" });
                 }];
             }]
        }];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"got url: %@", url);
    
    NSURL *actionURL = nil;
    if ([url.host isEqualToString:@"action"]) {
        NSString *actionString = [url.queryDictionary stringForKey:@"url"];
        actionURL = [NSURL URLWithString:actionString];
        NSLog(@"action 2.0: %@", actionURL);
    }
    else if ([[url.host lowercaseString] isEqualToString:@"action.cmd"]
             || [[url.path lowercaseString] isEqualToString:@"//action.cmd"]) {
        actionURL = [M9URLAction actionURLFrom_1_0:[url absoluteString]];
        NSLog(@"translate to action 2.0: %@", actionURL);
    }
    
    // !!!: do this in action 1.0 manager
    
    // filter action 2.0
    if ([M9URLAction performActionWithURL:actionURL completion:nil]) {
        NSLog(@"action 2.0");
    }
    // forward action 1.0, a new method without translating
    else {
        NSLog(@"action 1.0");
    }
    
    return YES;
}

- (void)testWithAction:(M9URLAction *)action finish:(M9URLActionFinishBlock)finish {
    NSLog(@"%@ / %@", action, action.prevActionResult);
    if (finish) finish(nil);
}

@end