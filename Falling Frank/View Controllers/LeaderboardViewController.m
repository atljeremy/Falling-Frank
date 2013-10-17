//
//  LeaderboardViewController.m
//  Falling Frank
//
//  Created by Jeremy Fox on 10/16/13.
//  Copyright (c) 2013 jeremyfox. All rights reserved.
//

#import "LeaderboardViewController.h"
#import "LeaderboardCell.h"

static NSString* const kLeaderBoardCellID = @"LeaderboardCell";

@interface LeaderboardViewController ()
@property (nonatomic, retain) NSArray* scores;
@end

@implementation LeaderboardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _scores = [[SQLiteManager sharedInstance] getPlayersByScoreDesc:YES withRange:NSMakeRange(0, 10)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismiss)]];
    [self.navigationItem setTitle:@"Top 10"];
    
    [self.tableView registerNib:[UINib nibWithNibName:kLeaderBoardCellID bundle:nil] forCellReuseIdentifier:kLeaderBoardCellID];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_tableView release];
    [super dealloc];
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.scores.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeaderboardCell* cell = [tableView dequeueReusableCellWithIdentifier:kLeaderBoardCellID];
    Player* player = [self.scores objectAtIndex:indexPath.row];
    if (player) {
        cell.username.text = player.username;
        cell.score.text = player.score;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
