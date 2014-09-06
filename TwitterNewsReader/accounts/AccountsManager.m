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
    
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        _accounts = [accountStore accountsWithAccountType:accountType];
        
        NSString *notificationName;
        if (!granted || _accounts.count == 0) {
            _selectedAccount = _accounts.firstObject;
            notificationName = AccountsManagerUnableToLoadAccountNotification;
        } else if (_accounts.count > 1){
            notificationName = AccountsManagerDidLoadAccountsNotification;
        } else {
            notificationName = AccountsManagerDidLoadAccountNotification;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:self];
    }];
}

@end
