//
//  NSDictionary+Helpers.m
//  TwitterNewsReader
//
//  Created by Anastasia Kononova on 9/7/14.
//  Copyright (c) 2014 Asya Kononova. All rights reserved.
//

#import "NSDictionary+Helpers.h"

@implementation NSDictionary (Helpers)

- (id)nonNullObjectForKey:(id)key
{
    id value = [self objectForKey:key];
    
    if (value != nil && [value isKindOfClass:[NSNull class]]) {
        value = nil;
    }
    
    return value;
}

- (NSURL*)urlForKey:(id)key
{
    NSString *str = [self objectForKey:key];
    
    if (![str isKindOfClass:[NSString class]]) return nil;
    
    return [NSURL URLWithString:str];
}


- (NSDate*)dateForKey:(id)key formatter:(NSDateFormatter*)formatter
{
    id date = [self nonNullObjectForKey:key];
    
    if (date != nil && [date isKindOfClass:[NSString class]]) {
        date = [formatter dateFromString:date];
    }
    
    return date;
}

- (int64_t)int64ForKey:(id)key
{
    return [[self objectForKey:key] longLongValue];
}

@end
