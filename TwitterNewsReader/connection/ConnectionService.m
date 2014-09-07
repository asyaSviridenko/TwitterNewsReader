//
//  ConnectionService.m
//  TwitterNewsReader
//
//  Created by Anastasia Kononova on 9/5/14.
//  Copyright (c) 2014 Asya Kononova. All rights reserved.
//

#import "ConnectionService.h"
#import "ApplicationRootManager.h"
#import <Social/Social.h>
#import "Tweet.h"
#import "NSDictionary+Helpers.h"

#define ADD_IF_NOT_EMPTY(dict, val, key) if (val > 0) { [parameters setObject:[NSString stringWithFormat:@"%lld", val] forKey:key];}

@implementation ConnectionService {
    NSURL *_rootURL;
    ACAccount *_account;
}

+ (instancetype)shared
{
    return [ApplicationRootManager shared].connectionService;
}

- (instancetype)initWithURL:(NSURL *)url account:(ACAccount *)account
{
    self = [super init];
    if (self) {
        _rootURL = url;
        _account = account;
    }
    return self;
}

#pragma mark - Public

- (void)getTimeLineSince:(int64_t)sinceID till:(int64_t)tillID resultHandler:(ResultHandler)handler
{
    NSURL *requestURL = [NSURL URLWithString:@"statuses/home_timeline.json" relativeToURL:_rootURL];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObject:@"20" forKey:@"count"];
    ADD_IF_NOT_EMPTY(parameters, sinceID, @"since_id");
    ADD_IF_NOT_EMPTY(parameters, tillID, @"max_id");
    
    SLRequest *postRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                requestMethod:SLRequestMethodGET
                                                          URL:requestURL
                                                   parameters:parameters];
    
    postRequest.account = _account;
    
    [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error){
        NSArray *tweets = [self parseTimeLine:[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (handler != nil) {
                handler(tweets);
            }
        });
     }];
}

#pragma mark - Internals

- (NSArray *)parseTimeLine:(id)response
{
    NSAssert([response isKindOfClass:[NSArray class]], @"Wrong response format!");
    
    NSArray *tweetsData = (NSArray *)response;
    NSMutableArray *tweets = [NSMutableArray array];
    
    for (NSDictionary *data in tweetsData) {
        Tweet *tweet = [Tweet new];
        tweet.tweetID = [data int64ForKey:@"id_str"];
        tweet.text = [data nonNullObjectForKey:@"text"];
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        //[format setDateFormat:@"hh:mm:ss"];
        tweet.createdAt = [data dateForKey:@"created_at" formatter:format];
        
        NSDictionary *userData = (NSDictionary *)[data objectForKey:@"user"];
        tweet.user = [userData nonNullObjectForKey:@"name"];
        tweet.imageURL = [userData urlForKey:@"profile_image_url"];
        
        [tweets addObject:tweet];
    }
    
    return tweets;
}

@end
