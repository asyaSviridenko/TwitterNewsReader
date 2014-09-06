//
//  AccountsSelectionController.h
//  TwitterNewsReader
//
//  Created by Anastasia Kononova on 9/6/14.
//  Copyright (c) 2014 Asya Kononova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/ACAccount.h>

@protocol AccountsSelectionControllerDelegate;

@interface AccountsSelectionController : UITableViewController

@property (nonatomic, weak) id<AccountsSelectionControllerDelegate> delegate;

- (instancetype)initWithAccounts:(NSArray *)accounts;

@end

@protocol AccountsSelectionControllerDelegate<NSObject>
- (void)accountSelectionController:(UIViewController *)controller didSelectAccount:(ACAccount *)account;
@end
