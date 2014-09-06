//
//  AppDelegate.m
//  TwitterNewsReader
//
//  Created by Anastasia Kononova on 9/5/14.
//  Copyright (c) 2014 Asya Kononova. All rights reserved.
//

#import "AppDelegate.h"
#import "ApplicationRootManager.h"

@implementation AppDelegate {
    UIWindow *_window;
}

+ (AppDelegate*)shared
{
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _manager = [ApplicationRootManager new];
    
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.backgroundColor = [UIColor whiteColor];
    
    _window.rootViewController = _manager.rootController;
    [_window makeKeyAndVisible];
    
    return YES;
    
}

@end
