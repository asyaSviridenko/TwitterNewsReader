//
//  TweetContentView.h
//  TwitterNewsReader
//
//  Created by Anastasia Kononova on 9/7/14.
//  Copyright (c) 2014 Asya Kononova. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Tweet;

@interface TweetCell : UITableViewCell

@property (nonatomic, strong) Tweet *tweet;

+ (CGFloat)viewHeightForText:(NSString *)text;

@end
