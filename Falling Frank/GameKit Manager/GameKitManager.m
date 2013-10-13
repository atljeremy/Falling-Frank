//
//  GameKitManager.m
//  Falling Frank
//
//  Created by Jeremy Fox on 10/12/13.
//  Copyright (c) 2013 jeremyfox. All rights reserved.
//

#import "GameKitManager.h"

static NSString* const kFrankBoard = @"frank_board";

@interface GameKitManager()
@property (nonatomic, strong, readwrite) NSArray* leaderboards;
@property (nonatomic, strong, readwrite) GKLeaderboard* frankboard;
@end

@implementation GameKitManager

+ (instancetype)sharedInstance
{
    static GameKitManager* sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

+ (void)authenticateLocalPlayerWithAuthenticateBlock:(void(^)(UIViewController* viewController))authenticateBlock authenticatedBlock:(void(^)(GKLocalPlayer* localPlayer))authenticatedBlock
{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        if (viewController != nil) {
            if (authenticateBlock) authenticateBlock(viewController);
        } else {
            if (authenticatedBlock) authenticatedBlock(localPlayer);
        }
    };
}

+ (void)reportScore:(int64_t)score forLeaderboardID:(NSString*)identifier
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
        GKScore *scoreReporter = [[GKScore alloc] initWithLeaderboardIdentifier: identifier];
        scoreReporter.value = score;
        scoreReporter.context = 0;
        NSArray *scores = @[scoreReporter];
        [GKScore reportScores:scores withCompletionHandler:^(NSError *error) {
            NSLog(@"Scores sent to Apple");
        }];
    } else {
        GKScore *scoreReporter = [[GKScore alloc] initWithCategory:identifier];
        scoreReporter.value = score;
        scoreReporter.context = 0;
        [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
            NSLog(@"Scores sent to Apple");
        }];
    }
    
}

- (void)loadLeaderboards
{
    [GKLeaderboard loadLeaderboardsWithCompletionHandler:^(NSArray *leaderboards, NSError *error) {
        self.leaderboards = leaderboards;
        for (GKLeaderboard* leaderboard in self.leaderboards) {
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
                if ([leaderboard.identifier isEqualToString:kFrankBoard]) {
                    self.frankboard = leaderboard;
                }
            } else {
                if ([leaderboard.category isEqualToString:kFrankBoard]) {
                    self.frankboard = leaderboard;
                }
            }
        }
    }];
}

@end
