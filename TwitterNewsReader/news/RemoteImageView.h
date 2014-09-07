//
//  RemoteImageView.h
//  TwitterNewsReader
//
//  Created by Anastasia Kononova on 9/6/14.
//  Copyright (c) 2014 Asya Kononova. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RemoteImageViewDelegate;
@class RemoteImage;

@interface RemoteImageView : UIView

@property (nonatomic, strong, readonly) RemoteImage *image;

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIView *placeholder;
@property (nonatomic, weak) IBOutlet UIView *progressView;

@property (nonatomic, assign) BOOL isCircular;
@property (nonatomic, weak) id<RemoteImageViewDelegate> delegate;

- (void)displayImage:(RemoteImage*)imaged;

@end

@protocol RemoteImageViewDelegate <NSObject>
@optional
- (void)remoteImageView:(RemoteImageView*)view didLoadImage:(UIImage*)image;
@end