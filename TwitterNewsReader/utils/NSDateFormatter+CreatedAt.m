//
//  NSDateFormatter+CreatedAt.m
//  TwitterNewsReader
//
//  Created by Anastasia Kononova on 9/7/14.
//  Copyright (c) 2014 Asya Kononova. All rights reserved.
//

#import "NSDateFormatter+CreatedAt.h"

@implementation NSDateFormatter (CreatedAt)

+ (NSDateFormatter *)createdAtFormatter
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEE MMM dd HH:mm:ss '+0000' yyyy"];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en-US"]];
    
    return formatter;
}

+ (NSDateFormatter *)tweetFormatter
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd.MM.yy HH:mm"];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en-US"]];
    
    return formatter;
}

@end
