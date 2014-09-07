//
//  AppDelegate.h
//  TwitterNewsReader
//
//  Created by Anastasia Kononova on 9/5/14.
//  Copyright (c) 2014 Asya Kononova. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ApplicationRootManager;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong, readonly) ApplicationRootManager *manager;

+ (instancetype)shared;

@end
