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
#import "TweetThumbnailCell.h"
#import "TweetCell.h"
#import "Tweet.h"
#import "UITableViewCell+NIB.h"

static const int64_t voidParameter = -1;
static const int gridThumbnailCount = 3;

@interface NewsFeedViewController ()<PullTableViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet PullTableView *tableView;
@property (nonatomic, weak) IBOutlet UIView *loadingView;
@property (nonatomic, weak) IBOutlet UILabel *noResultsLabel;

@end

@implementation NewsFeedViewController {
    NSMutableArray *_tweets;
    BOOL _isGridMode;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _tweets = [NSMutableArray array];
        _isGridMode = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"News Feed";
    
    [self setRightBarButtonItem];
    
    _tableView.allowsSelection = NO;
    _tableView.tableFooterView = [UIView new];
    _tableView.pullArrowImage = [UIImage imageNamed:@"PullDown.png"];
    _tableView.backgroundColor = self.view.backgroundColor;
    _tableView.pullBackgroundColor = _tableView.backgroundColor;
    _tableView.loadBackgroundColor = _tableView.backgroundColor;
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

- (void)onSwitchViewMode
{
    _isGridMode = !_isGridMode;
    [self setRightBarButtonItem];
    [_tableView reloadData];
}

- (void)setRightBarButtonItem
{
    NSString *name = _isGridMode ? @"Selector_active.png" : @"Selector.png";
    UIImage *image = [[UIImage imageNamed:name] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(onSwitchViewMode)];
}

- (void)showLoadingView:(BOOL)show
{
    _loadingView.hidden = !show;
}

- (NSArray *)getRowTweetsForIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *rowTweets = [NSMutableArray array];
    
    for (int i = 0; i < gridThumbnailCount; i++) {
        int row = gridThumbnailCount * indexPath.row + i;
        if (row < _tweets.count) {
            [rowTweets addObject:[_tweets objectAtIndex:row]];
        }
    }
    
    return rowTweets;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Tweet *tweet = [_tweets objectAtIndex:indexPath.row];
    CGFloat width = tableView.frame.size.width;
    return _isGridMode ? width/gridThumbnailCount : [TweetCell viewHeightForText:tweet.text];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _isGridMode ? (NSInteger)ceil((double)_tweets.count/gridThumbnailCount) : _tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isGridMode) {
        TweetThumbnailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"gridCellID"];
        
        if (cell == nil) {
            cell = [[TweetThumbnailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"gridCellID"];
        }
        
        cell.rowTweets = [self getRowTweetsForIndexPath:indexPath];
        return cell;
        
    } else {
        
        TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
        
        if (cell == nil) {
            cell = [TweetCell loadFromNib];
        }
        
        cell.tweet = [_tweets objectAtIndex:indexPath.row];
        cell.backgroundColor = indexPath.row % 2 ? [UIColor greenColor] : [UIColor redColor];
        return cell;
    }
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
