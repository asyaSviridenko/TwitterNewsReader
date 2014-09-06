//
//  ConnectionService.h
//  TwitterNewsReader
//
//  Created by Anastasia Kononova on 9/5/14.
//  Copyright (c) 2014 Asya Kononova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/ACAccount.h>

@interface ConnectionService : NSObject

- (instancetype)initWithURL:(NSURL *)url account:(ACAccount *)account;

@end
