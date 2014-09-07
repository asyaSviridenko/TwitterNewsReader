//
//  TweetThumbnailView.m
//  TwitterNewsReader
//
//  Created by Anastasia Kononova on 9/7/14.
//  Copyright (c) 2014 Asya Kononova. All rights reserved.
//

#import "TweetThumbnailView.h"
#import "RemoteImageView.h"
#import "UIView+NIB.h"

@interface TweetThumbnailView ()
@property (nonatomic, weak) IBOutlet UIView *placeholderView;
@property (nonatomic, weak) IBOutlet UILabel *usernameLabel;
@end

@implementation TweetThumbnailView {
    RemoteImageView *_imageView;
}

- (void)awakeFromNib
{
    _imageView = [RemoteImageView loadFromNIB];
    _imageView.frame = _placeholderView.bounds;
    _imageView.isCircular = YES;
    [_placeholderView addSubview:_imageView];
}

- (RemoteImage *)image
{
    return _imageView.image;
}

- (void)setImage:(RemoteImage *)image
{
    [_imageView displayImage:image];
}

- (NSString *)username
{
    return _usernameLabel.text;
}

- (void)setUsername:(NSString *)username
{
    _usernameLabel.text = username;
}

@end
