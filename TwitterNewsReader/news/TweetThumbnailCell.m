//
//  TweetThumbnailView.m
//  TwitterNewsReader
//
//  Created by Anastasia Kononova on 9/7/14.
//  Copyright (c) 2014 Asya Kononova. All rights reserved.
//

#import "TweetThumbnailCell.h"
#import "TweetThumbnailView.h"
#import "UIView+NIB.h"
#import "Tweet.h"
#import "ImageCache.h"
#import "NSDateFormatter+CreatedAt.h"

@implementation TweetThumbnailCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat offset = 0.0f;
    
    for (UIView *subview in self.contentView.subviews) {
        CGRect rect = subview.frame;
        rect.origin.x = offset;
        subview.frame = rect;
        
        offset += rect.size.width;
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
        TweetThumbnailView *view = [TweetThumbnailView loadFromNIB];
        view.username = [NSDateFormatter stringFromTweetDate:tweet.createdAt];
        view.image = [[ImageCache shared] remoteImageForURL:tweet.imageURL];
        
        [self.contentView addSubview:view];
    }
}

@end
