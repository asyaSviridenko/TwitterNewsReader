//
//  NewsFeedViewController.h
//  TwitterNewsReader
//
//  Created by Anastasia Kononova on 9/6/14.
//  Copyright (c) 2014 Asya Kononova. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ConnectionService;

@interface NewsFeedViewController : UITableViewController

@property (nonatomic, strong) ConnectionService *connectionService;

@end
