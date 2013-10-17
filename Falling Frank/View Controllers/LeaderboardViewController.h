//
//  LeaderboardViewController.h
//  Falling Frank
//
//  Created by Jeremy Fox on 10/16/13.
//  Copyright (c) 2013 jeremyfox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeaderboardViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)valueChanged:(id)sender;

@end
