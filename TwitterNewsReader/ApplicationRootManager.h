//
//  ApplicationRootManager.h
//  TwitterNewsReader
//
//  Created by Anastasia Kononova on 9/6/14.
//  Copyright (c) 2014 Asya Kononova. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ConnectionService;
@class AccountsManager;

@interface ApplicationRootManager : NSObject

@property (nonatomic, strong, readonly) UIViewController *rootController;
@property (nonatomic, strong, readonly) ConnectionService *connectionService;
@property (nonatomic, strong, readonly) AccountsManager *accountManager;

@end
