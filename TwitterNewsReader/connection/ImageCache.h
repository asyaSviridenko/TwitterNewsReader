//
//  ImageCash.h
//  TwitterNewsReader
//
//  Created by Anastasia Kononova on 9/7/14.
//  Copyright (c) 2014 Asya Kononova. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RemoteImage;

@interface ImageCache : NSObject

+ (ImageCache *)shared;

- (RemoteImage*)remoteImageForURL:(NSURL*)url;

- (BOOL)hasRemoteImageForURL:(NSURL *)url;

@end
