//
//  GameKitManager.h
//  Falling Frank
//
//  Created by Jeremy Fox on 10/12/13.
//  Copyright (c) 2013 jeremyfox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

static NSString* const kAchievementLevelOneComplete = @"level1_complete";
static NSString* const kAchievementLevelTwoComplete = @"level2_complete";
static NSString* const kAchievementPowerUpNinjaLevelOne = @"powerupninja_level1";
static NSString* const kAchievementPowerUpNinjaLevelTwo = @"powerupninja_level2";
static NSString* const kAchievementPowerUpNinjaLevelThree = @"powerupninja_level3";
static NSString* const kAchievementPerfectLevelBonues = @"perfect_level_bonus";
static NSString* const kAchievementBirdMagnet = @"bird_magnet";

@interface GameKitManager : NSObject

@property (nonatomic, strong, readonly) NSArray* leaderboards;
@property (nonatomic, strong, readonly) GKLeaderboard* frankboard;

+ (instancetype)sharedInstance;
+ (void)authenticateLocalPlayerWithAuthenticateBlock:(void(^)(UIViewController* viewController))authenticateBlock authenticatedBlock:(void(^)(GKLocalPlayer* localPlayer))authenticatedBlock;
+ (void)reportScore:(int64_t)score forLeaderboardID:(NSString*)identifier;
+ (void)retrieveTopTenScores;
- (void)loadLeaderboards;
+ (void)reportAchievementIdentifier:(NSString*)identifier percentComplete:(float)percent;

@end
