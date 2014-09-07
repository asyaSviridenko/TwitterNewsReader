//
//  NSDateFormatter+CreatedAt.h
//  TwitterNewsReader
//
//  Created by Anastasia Kononova on 9/7/14.
//  Copyright (c) 2014 Asya Kononova. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (CreatedAt)

+ (NSDateFormatter *)createdAtFormatter;
+ (NSDateFormatter *)tweetFormatter;
@end
