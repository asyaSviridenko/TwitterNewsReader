//
//  TweetThumbnailView.h
//  TwitterNewsReader
//
//  Created by Anastasia Kononova on 9/7/14.
//  Copyright (c) 2014 Asya Kononova. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RemoteImage;

@interface TweetThumbnailView : UIView

@property (nonatomic, copy) NSString *username;
@property (nonatomic, strong) RemoteImage *image;

@end
