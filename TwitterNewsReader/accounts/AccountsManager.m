//
//  AccountsManager.m
//  TwitterNewsReader
//
//  Created by Anastasia Kononova on 9/6/14.
//  Copyright (c) 2014 Asya Kononova. All rights reserved.
//

#import "AccountsManager.h"
#import <Accounts/ACAccountStore.h>

NSString * const AccountsManagerDidLoadAccountsNotification = @"AccountsManagerDidLoadAccountsNotification";
NSString * const AccountsManagerDidLoadAccountNotification = @"AccountsManagerDidLoadAccountNotification";
NSString * const AccountsManagerUnableToLoadAccountNotification = @"AccountsManagerUnableToLoadAccountNotification";

@implementation AccountsManager {
    NSString *_accountTypeID;
}

- (instancetype)initWithAccountTypeID:(NSString *)typeID
{
    self = [super init];
    if (self) {
        _accountTypeID = typeID.copy;
    }
    return self;
}

- (void)loadUserAccounts
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:_accountTypeID];
    
    __block AccountsManager *blockSelf = self;
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        blockSelf->_accounts = [accountStore accountsWithAccountType:accountType];
        
        NSString *notificationName;
        if (!granted || blockSelf->_accounts.count == 0) {
            notificationName = AccountsManagerUnableToLoadAccountNotification;
        } else if (blockSelf->_accounts.count > 1){
            notificationName = AccountsManagerDidLoadAccountsNotification;
        } else {
            blockSelf->_selectedAccount = blockSelf->_accounts.firstObject;
            notificationName = AccountsManagerDidLoadAccountNotification;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:blockSelf];
        });
    }];
}

@end
