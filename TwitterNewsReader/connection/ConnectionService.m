//
//  ConnectionService.m
//  TwitterNewsReader
//
//  Created by Anastasia Kononova on 9/5/14.
//  Copyright (c) 2014 Asya Kononova. All rights reserved.
//

#import "ConnectionService.h"
#import "AppDelegate.h"

@implementation ConnectionService {
    NSURL *_rootURL;
}

- (instancetype)initWithURL:(NSURL *)url account:(ACAccount *)account
{
    self = [super init];
    if (self) {
        _rootURL = url;
    }
    return self;
}

#pragma mark - Internals

#pragma mark - Public
@end
