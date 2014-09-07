//
//  ConnectionService.h
//  TwitterNewsReader
//
//  Created by Anastasia Kononova on 9/5/14.
//  Copyright (c) 2014 Asya Kononova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/ACAccount.h>

typedef void(^ResultHandler)(NSArray *tweets);

@interface ConnectionService : NSObject

+ (instancetype)shared;

- (instancetype)initWithURL:(NSURL *)url account:(ACAccount *)account;

- (void)getTimeLineSince:(int64_t)sinceID till:(int64_t)tillID resultHandler:(ResultHandler)handler;

@end
