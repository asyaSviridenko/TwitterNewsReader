//
//  NSDictionary+Helpers.h
//  TwitterNewsReader
//
//  Created by Anastasia Kononova on 9/7/14.
//  Copyright (c) 2014 Asya Kononova. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Helpers)

- (id)nonNullObjectForKey:(id)key;
- (NSDate*)dateForKey:(id)key formatter:(NSDateFormatter*)formatter;
- (NSURL*)urlForKey:(id)key;

@end
