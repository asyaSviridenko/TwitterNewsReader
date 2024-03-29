//
//  Tweet.h
//  TwitterNewsReader
//
//  Created by Anastasia Kononova on 9/7/14.
//  Copyright (c) 2014 Asya Kononova. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweet : NSObject

@property (nonatomic, assign) int64_t tweetID;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *shortUsername;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) NSDate *createdAt;

@end
