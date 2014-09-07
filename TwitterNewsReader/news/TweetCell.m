//
//  TweetContentView.m
//  TwitterNewsReader
//
//  Created by Anastasia Kononova on 9/7/14.
//  Copyright (c) 2014 Asya Kononova. All rights reserved.
//

#import "TweetCell.h"
#import "Tweet.h"
#import "RemoteImageView.h"
#import "UIView+NIB.h"
#import "ImageCache.h"
#import "NSDateFormatter+CreatedAt.h"

@interface TweetCell ()
@property (nonatomic, weak) IBOutlet UIView *avatarPlaceholder;
@property (nonatomic, weak) IBOutlet UILabel *userLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *tweetLabel;
@end

@implementation TweetCell {
    RemoteImageView *_imageView;
}

- (void)awakeFromNib
{
    _imageView = [RemoteImageView loadFromNIB];
    _imageView.frame = _avatarPlaceholder.bounds;
    _imageView.isCircular = YES;
    [_avatarPlaceholder addSubview:_imageView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = _tweetLabel.frame;
    rect.size.height = self.bounds.size.height - CGRectGetMaxY(_userLabel.frame) - 4.0f;
    _tweetLabel.frame = rect;
}

- (void)setTweet:(Tweet *)tweet
{
    if (![_tweet isEqual:tweet]) {
        _tweet = tweet;
        
        _userLabel.text = _tweet.username;
        _tweetLabel.text = _tweet.text;
        [_imageView displayImage:[[ImageCache shared] remoteImageForURL:_tweet.imageURL]];
        _dateLabel.text = [NSDateFormatter stringFromTweetDate:_tweet.createdAt];
    }
}

+ (CGFloat)viewHeightForText:(NSString *)text
{
    CGRect textRect = [text boundingRectWithSize:CGSizeMake(242, NSIntegerMax)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0f]}
                                         context:nil];

    return  textRect.size.height + 34.0f;
}

@end
