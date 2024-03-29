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
    
    _tableView.allowsSelection = NO;
    _tableView.tableFooterView = [UIView new];
    _tableView.pullArrowImage = [UIImage imageNamed:@"PullDown.png"];
    _tableView.backgroundColor = self.view.backgroundColor;
    _tableView.pullBackgroundColor = _tableView.backgroundColor;
    _tableView.loadBackgroundColor = _tableView.backgroundColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [self setRightBarButtonItem];
    [self showLoadingView:NO];
    [self registerCellClasses];
}

#pragma mark - Public

- (void)setConnectionService:(ConnectionService *)connectionService
{
    if (![_connectionService isEqual:connectionService]) {
        _connectionService = connectionService;
        
        [self showLoadingView:YES];
        [_connectionService getTimeLineSince:voidParameter till:voidParameter resultHandler:[self loadMoreHandler]];
    }
}

#pragma mark - Internals

- (void)onSwitchViewMode
{
    _isGridMode = !_isGridMode;
    [self setRightBarButtonItem];
    _tableView.separatorStyle = _isGridMode ? UITableViewCellSeparatorStyleNone : UITableViewCellSeparatorStyleSingleLine;
    
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

- (ResultHandler)loadMoreHandler
{
    __block NewsFeedViewController *blockSelf = self;
    
    return [^(NSArray *newTweets) {
        [blockSelf->_tweets addObjectsFromArray:newTweets];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [blockSelf applyUpdates];
        });
    } copy];
}

- (ResultHandler)refreshHandler
{
    __block NewsFeedViewController *blockSelf = self;
    
    return [^(NSArray *newTweets) {
        [blockSelf->_tweets insertObjects:newTweets atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newTweets.count)]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [blockSelf applyUpdates];
        });
    } copy];
}

- (void)applyUpdates
{
    _tableView.pullTableIsLoadingMore = NO;
    _tableView.pullTableIsRefreshing = NO;
    
    [_tableView reloadData];
    
    _noResultsLabel.hidden = _tweets.count > 0;
    [self showLoadingView:NO];
}

- (void)registerCellClasses
{
    [_tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"tableCellID"];
    
    [_tableView registerClass:[TweetThumbnailCell class] forCellReuseIdentifier:@"gridCellID"];
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
        cell.rowTweets = [self getRowTweetsForIndexPath:indexPath];
        return cell;
        
    } else {
        TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCellID"];
        cell.tweet = [_tweets objectAtIndex:indexPath.row];
        return cell;
    }
}

#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [_connectionService getTimeLineSince:voidParameter till:((Tweet *)_tweets.lastObject).tweetID - 1 resultHandler:[self loadMoreHandler]];
}

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    [_connectionService getTimeLineSince:((Tweet *)_tweets.firstObject).tweetID + 1 till:voidParameter resultHandler:[self refreshHandler]];
}

@end
