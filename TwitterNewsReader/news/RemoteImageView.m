//
//  RemoteImageView.m
//  TwitterNewsReader
//
//  Created by Anastasia Kononova on 9/6/14.
//  Copyright (c) 2014 Asya Kononova. All rights reserved.
//

#import "RemoteImageView.h"
#import "RemoteImage.h"

@implementation RemoteImageView {
    CGFloat totalProgressWidth;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        totalProgressWidth = _progressView.frame.size.width;
    }
    return self;
}

- (void)awakeFromNib
{
    totalProgressWidth = _progressView.frame.size.width;
    _progressView.layer.cornerRadius = 6;
    _placeholder.layer.cornerRadius = 6;
}

- (void)_displayImage:(UIImage*)image
{
    _placeholder.hidden = image != nil;
    
    _imageView.hidden = image == nil;
    _imageView.image = image;
    
    if (_isCircular) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = self.frame.size.width / 2;
    }
}

- (void)setProgress:(float)progress
{
    CGRect rect = _progressView.frame;
    rect.size = CGSizeMake(totalProgressWidth * progress, _progressView.frame.size.height);
    _progressView.frame = rect;
}

- (void)displayImage:(RemoteImage*)image
{
    [_image removeObserver:self forKeyPath:@"progress"];
    [_image removeObserver:self forKeyPath:@"isLoad"];
    
    _image = image;
    
    [_image addObserver:self forKeyPath:@"progress" options:0 context:NULL];
    [_image addObserver:self forKeyPath:@"isLoad" options:0 context:NULL];
    
    [self _displayImage:_image.image];
    
    [self setProgress:_image.image ? 1.0 : 0.0];
    [_image startLoading];
}

- (void)dealloc
{
    [_image removeObserver:self forKeyPath:@"isLoad"];
    [_image removeObserver:self forKeyPath:@"progress"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"progress"]) {
        [self setProgress:_image.progress];
    }
    if([keyPath isEqualToString:@"isLoad"]) {
        [self _displayImage:_image.image];
        if (_image.image && [_delegate respondsToSelector:@selector(remoteImageView:didLoadImage:)]) {
            [_delegate remoteImageView:self didLoadImage:_image.image];
        }
    }
}

@end
