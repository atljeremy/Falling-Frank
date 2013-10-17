//
//  LeaderboardCell.h
//  Falling Frank
//
//  Created by Jeremy Fox on 10/16/13.
//  Copyright (c) 2013 jeremyfox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeaderboardCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *username;
@property (retain, nonatomic) IBOutlet UILabel *score;

@end
