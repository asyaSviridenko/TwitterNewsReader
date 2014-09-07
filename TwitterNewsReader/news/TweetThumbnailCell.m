//
//  TweetThumbnailView.m
//  TwitterNewsReader
//
//  Created by Anastasia Kononova on 9/7/14.
//  Copyright (c) 2014 Asya Kononova. All rights reserved.
//

#import "TweetThumbnailCell.h"
#import "RemoteImageView.h"
#import "UIView+NIB.h"
#import "Tweet.h"
#import "ImageCache.h"

@implementation TweetThumbnailCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = MIN(self.bounds.size.width/_rowTweets.count, self.bounds.size.height);
    CGFloat offset = 0.0f;
    CGFloat gap = 10.0f;
    
    for (UIView *subview in self.contentView.subviews) {
        subview.frame = CGRectMake(offset + gap, gap, width - 2 * gap, width - 2 * gap);
        offset += width;
    }
}

- (void)setRowTweets:(NSArray *)rowTweets
{
    if (![_rowTweets isEqualToArray:rowTweets]) {
        _rowTweets = rowTweets.copy;
        
        [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self addRemoteImageViews];
    }
}

- (void)addRemoteImageViews
{
    for (Tweet *tweet in _rowTweets) {
        RemoteImageView *imageView = [RemoteImageView loadFromNIB];
        imageView.isCircular = YES;
        [imageView displayImage:[[ImageCache shared] remoteImageForURL:tweet.imageURL]];
        
        [self.contentView addSubview:imageView];
    }
}

@end
