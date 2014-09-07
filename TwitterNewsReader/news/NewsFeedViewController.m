//
//  NewsFeedViewController.m
//  TwitterNewsReader
//
//  Created by Anastasia Kononova on 9/6/14.
//  Copyright (c) 2014 Asya Kononova. All rights reserved.
//

#import "NewsFeedViewController.h"
#import "ConnectionService.h"
#import "PullTableView.h"
#import "Tweet.h"

static const int64_t voidParameter = -1;

@interface NewsFeedViewController ()<PullTableViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet PullTableView *tableView;
@property (nonatomic, weak) IBOutlet UIView *loadingView;
@property (nonatomic, weak) IBOutlet UILabel *noResultsLabel;

@end

@implementation NewsFeedViewController {
    NSMutableArray *_tweets;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _tweets = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"News Feed";

    _tableView.allowsSelection = NO;
    _tableView.tableFooterView = [UIView new];
}

#pragma mark - Public

- (void)setConnectionService:(ConnectionService *)connectionService
{
    if (![_connectionService isEqual:connectionService]) {
        _connectionService = connectionService;
        
        [_connectionService getTimeLineSince:voidParameter till:voidParameter resultHandler:[self resultHandler]];
    }
}

#pragma mark - Internals

- (void)showLoadingView:(BOOL)show
{
    _loadingView.hidden = !show;
}

- (ResultHandler)resultHandler
{
    __block NewsFeedViewController *blockSelf = self;
    
    return [^(NSArray *newTweets) {
        [blockSelf->_tweets addObjectsFromArray:newTweets];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            blockSelf->_tableView.pullTableIsLoadingMore = NO;
            blockSelf->_tableView.pullTableIsRefreshing = NO;
            
            [blockSelf->_tableView reloadData];
            
            blockSelf->_noResultsLabel.hidden = blockSelf->_tweets.count > 0;
            [blockSelf showLoadingView:NO];
        });
    } copy];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    
    Tweet *tweet = [_tweets objectAtIndex:indexPath.row];
    cell.textLabel.text = tweet.text;
    
    return cell;
}

#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [_connectionService getTimeLineSince:voidParameter till:((Tweet *)_tweets.lastObject).tweetID - 1 resultHandler:[self resultHandler]];
}

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    [_connectionService getTimeLineSince:((Tweet *)_tweets.firstObject).tweetID + 1 till:voidParameter resultHandler:[self resultHandler]];
}

@end
