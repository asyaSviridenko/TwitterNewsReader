//
//  AccountsManager.h
//  TwitterNewsReader
//
//  Created by Anastasia Kononova on 9/6/14.
//  Copyright (c) 2014 Asya Kononova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/ACAccount.h>

UIKIT_EXTERN NSString * const AccountsManagerDidLoadAccountsNotification;
UIKIT_EXTERN NSString * const AccountsManagerDidLoadAccountNotification;
UIKIT_EXTERN NSString * const AccountsManagerUnableToLoadAccountNotification;

@interface AccountsManager : NSObject

@property (nonatomic, strong, readonly) NSArray *accounts;
@property (nonatomic, strong) ACAccount *selectedAccount;

- (instancetype)initWithAccountTypeID:(NSString *)typeID;
- (void)loadUserAccounts;

@end
