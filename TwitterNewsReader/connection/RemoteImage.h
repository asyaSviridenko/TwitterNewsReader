//
//  RemoteImage.h
//  TwitterNewsReader
//
//  Created by Anastasia Kononova on 9/7/14.
//  Copyright (c) 2014 Asya Kononova. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RemoteImageDelegate;

@interface RemoteImage : NSObject

@property (strong, nonatomic) id<RemoteImageDelegate> delegate;
@property (strong, nonatomic, readonly) NSURL *imageUrl;
@property (strong, nonatomic, readonly) NSData *imageData;
@property (strong, nonatomic, readonly) UIImage *image;
@property (strong, nonatomic, readonly) NSError *lastError;
@property (nonatomic, assign, readonly) BOOL isLoad;
@property (nonatomic, assign, readonly) BOOL isLoading;
@property (nonatomic, assign) float progress;

+ (RemoteImage*)remoteImageWithURL:(NSURL*)url;

- (id)initWithURL:(NSURL*)url;
- (id)initWithImage:(UIImage*)image;

- (void)startLoading;
- (void)stopLoading;
- (void)clear:(BOOL)full;

@end

@protocol RemoteImageDelegate <NSObject>
- (void)remoteImageDidFinishLoading:(RemoteImage*)remoteImage;
- (void)remoteImage:(RemoteImage*)remoteImage loadingFailedWithError:(NSError*)error;
@end
