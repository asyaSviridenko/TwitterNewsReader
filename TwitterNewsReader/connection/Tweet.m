//
//  Tweet.m
//  TwitterNewsReader
//
//  Created by Anastasia Kononova on 9/7/14.
//  Copyright (c) 2014 Asya Kononova. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (NSString *)description
{
    return [NSString stringWithFormat:@"Tweet[%p]: id: %@, user: %@, createdAt: %@, image: %@, text: %@", self, _tweetID, _user, _createdAt, _imageURL, _text];
}

@end
