//
//  ApplicationRootManager.m
//  TwitterNewsReader
//
//  Created by Anastasia Kononova on 9/6/14.
//  Copyright (c) 2014 Asya Kononova. All rights reserved.
//

#import "ApplicationRootManager.h"
#import "NewsFeedViewController.h"
#import "ConnectionService.h"
#import "AccountsManager.h"
#import <Accounts/ACAccountType.h>
#import "AccountsSelectionController.h"
#import "AppDelegate.h"

@interface ApplicationRootManager () <AccountsSelectionControllerDelegate>
@end

@implementation ApplicationRootManager {
    NewsFeedViewController *_rootController;
    NSURL *_rootURL;
}

+ (ApplicationRootManager *)shared
{
    return [AppDelegate shared].manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _rootURL = [NSURL URLWithString:@"https://api.twitter.com/1.1/"];
        
        _accountManager = [[AccountsManager alloc] initWithAccountTypeID:ACAccountTypeIdentifierTwitter];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSeveralAccountsLoaded) name:AccountsManagerDidLoadAccountsNotification object:_accountManager];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onOneAccountLoaded) name:AccountsManagerDidLoadAccountNotification object:_accountManager];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAccountLoadFailed) name:AccountsManagerUnableToLoadAccountNotification object:_accountManager];
        
        [_accountManager loadUserAccounts];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notification Actions

- (void)onSeveralAccountsLoaded
{
    AccountsSelectionController *controller = [[AccountsSelectionController alloc] initWithAccounts:_accountManager.accounts];
    controller.delegate = self;
    [_rootController presentViewController:controller animated:YES completion:nil];
}

- (void)onOneAccountLoaded
{
    _connectionService = [[ConnectionService alloc] initWithURL:_rootURL account:_accountManager.selectedAccount];
    _rootController.connectionService = _connectionService;
}

- (void)onAccountLoadFailed
{
    [[[UIAlertView alloc] initWithTitle:nil message:@"Unable to load account." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil] show];
}

#pragma mark - Properties

- (UIViewController *)rootController
{
    if (_rootController == nil) {
        _rootController = [NewsFeedViewController new];
    }
    return _rootController;
}

#pragma mark - AccountsSelectionControllerDelegate

- (void)accountSelectionController:(UIViewController *)controller didSelectAccount:(ACAccount *)account
{
    _accountManager.selectedAccount = account;
    [self onOneAccountLoaded];
    
    [_rootController dismissViewControllerAnimated:YES completion:nil];
}

@end
