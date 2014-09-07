//
//  AccountsSelectionController.m
//  TwitterNewsReader
//
//  Created by Anastasia Kononova on 9/6/14.
//  Copyright (c) 2014 Asya Kononova. All rights reserved.
//

#import "AccountsSelectionController.h"
#import <Accounts/ACAccount.h>

@interface AccountsSelectionController ()

@end

@implementation AccountsSelectionController {
    NSArray *_accounts;
}

- (id)initWithAccounts:(NSArray *)accounts
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        _accounts = accounts;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Select Account";
    
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _accounts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    
    ACAccount *account = [_accounts objectAtIndex:indexPath.row];
    cell.textLabel.text = account.username;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_delegate accountSelectionController:self didSelectAccount:[_accounts objectAtIndex:indexPath.row]];
}

@end
