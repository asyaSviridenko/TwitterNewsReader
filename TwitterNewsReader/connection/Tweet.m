//
//  Tweet.m
//  TwitterNewsReader
//
//  Created by Anastasia Kononova on 9/7/14.
//  Copyright (c) 2014 Asya Kononova. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (void)setImageURL:(NSURL *)imageURL
{
    if (![_imageURL isEqual:imageURL]) {
        NSString *urlStr = [imageURL.absoluteString stringByReplacingOccurrencesOfString:@"normal" withString:@"bigger"];
        _imageURL = [NSURL URLWithString:urlStr];
    }
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Tweet[%p]: id: %lld, user: %@, createdAt: %@, image: %@, text: %@", self, _tweetID, _username, _createdAt, _imageURL, _text];
}

@end
