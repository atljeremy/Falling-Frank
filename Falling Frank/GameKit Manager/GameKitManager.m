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

#pragma mark - Authentication

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

#pragma mark - Leaderboards

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

+ (void)retrieveTopTenScores
{
    GKLeaderboard *leaderboardRequest = [[GKLeaderboard alloc] init];
    if (leaderboardRequest) {
        leaderboardRequest.playerScope = GKLeaderboardPlayerScopeGlobal;
        leaderboardRequest.timeScope = GKLeaderboardTimeScopeAllTime;
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
            leaderboardRequest.identifier = kFrankBoard;
        } else {
            leaderboardRequest.category = kFrankBoard;
        }
        leaderboardRequest.range = NSMakeRange(1,10);
        [leaderboardRequest loadScoresWithCompletionHandler:^(NSArray *scores, NSError *error) {
            if (error) {
                // Handle the error.
            }
            if (scores) {
                NSMutableArray* identifiers = [@[] mutableCopy];
                for (GKScore* score in scores) {
                    [identifiers addObject:score.playerID];
                }
                [self loadPlayerData:identifiers withCompletionHandler:^(NSArray *players, NSError *error) {
                    if (players && players.count > 0) {
                        [Player purgeAllPlayers];
                        for (GKPlayer* currentPlayer in players) {
                            NSNumber* score = [self getPlayerScoreFromScores:scores forPlayerID:currentPlayer.playerID];
                            Player* player = [Player playerWithName:currentPlayer.displayName username:currentPlayer.alias score:score];
                            [player save];
                        }
                    }
                }];
            }
        }];
    }
}

+ (NSNumber*)getPlayerScoreFromScores:(NSArray*)scores forPlayerID:(NSString*)playerID
{
    for (GKScore* score in scores) {
        if ([score.playerID isEqualToString:playerID]) {
            return @(score.value);
        }
    }
    return @(0);
}

+ (void)loadPlayerData:(NSArray*)identifiers withCompletionHandler:(void(^)(NSArray* players, NSError *error))completionHandler
{
    [GKPlayer loadPlayersForIdentifiers:identifiers withCompletionHandler:^(NSArray *players, NSError *error) {
        if (completionHandler) completionHandler(players, error);
    }];
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

#pragma mark - Achievements

+ (void)reportAchievementIdentifier:(NSString*)identifier percentComplete:(float)percent
{
    GKAchievement *achievement = [[GKAchievement alloc] initWithIdentifier:identifier];
    if (achievement) {
        achievement.percentComplete = percent;
        [achievement reportAchievementWithCompletionHandler:^(NSError *error) {
             if (error) {
                 NSLog(@"Error in reporting achievements: %@", error);
             }
         }];
    }
}

@end
