//
//  LeaderboardCell.m
//  Falling Frank
//
//  Created by Jeremy Fox on 10/16/13.
//  Copyright (c) 2013 jeremyfox. All rights reserved.
//

#import "LeaderboardCell.h"

@implementation LeaderboardCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_username release];
    [_score release];
    [super dealloc];
}
@end
