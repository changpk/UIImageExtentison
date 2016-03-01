//
//  AppDelegate.m
//  SpotLight
//
//  Created by sinagame on 16/3/1.
//  Copyright © 2016年 changpengkai. All rights reserved.
//

#import "AppDelegate.h"
#import "SpotlightUtil.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    SpotlightUtil *spotlightUtil = [SpotlightUtil shareInstance];
    
    [spotlightUtil deleteAllSeachableItems];
    NSData *thumnailData = UIImageJPEGRepresentation([UIImage imageNamed:@"1.jpg"], 0.9);
    [spotlightUtil insertSearchableItem:thumnailData spotlightTitle:@"测试单挑2" description:@"替换图片不管用吗" keywords:@[@"说话",@"地图",@"sss"] spotlightInfo:@"测试跳转id1" domainId:@"测试跳转domain1"];
    return YES;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler {
    
    if ([[userActivity activityType] isEqualToString:CSSearchableItemActionType]) {
        NSString *uniqueIdentifier = [userActivity.userInfo objectForKey: CSSearchableItemActivityIdentifier];
        // 接受事先定义好的数值,如果是多个参数可以使用把json转成string传递过来,接受后把string在转换为json
        NSLog(@"传递过来的值%@", uniqueIdentifier);
    }
    return YES;
    
}

@end
