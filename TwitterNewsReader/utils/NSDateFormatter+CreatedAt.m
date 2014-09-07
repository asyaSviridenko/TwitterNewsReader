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
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    
    return formatter;
}

+ (NSString *)stringFromTweetDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en-US"]];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:[NSDate date]];
    NSDate *today = [cal dateFromComponents:components];
    components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:date];
    NSDate *otherDate = [cal dateFromComponents:components];
    
    if([today isEqualToDate:otherDate]) {
        [formatter setDateFormat:@"HH:mm"];
    } else {
        [formatter setDateFormat:@"dd.MM.yy HH:mm"];
    }
    
    return [formatter stringFromDate:date];
}

@end
