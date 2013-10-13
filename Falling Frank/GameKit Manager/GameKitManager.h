//
//  GameKitManager.h
//  Falling Frank
//
//  Created by Jeremy Fox on 10/12/13.
//  Copyright (c) 2013 jeremyfox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface GameKitManager : NSObject

@property (nonatomic, strong, readonly) NSArray* leaderboards;
@property (nonatomic, strong, readonly) GKLeaderboard* frankboard;

+ (instancetype)sharedInstance;
+ (void)authenticateLocalPlayerWithAuthenticateBlock:(void(^)(UIViewController* viewController))authenticateBlock authenticatedBlock:(void(^)(GKLocalPlayer* localPlayer))authenticatedBlock;
+ (void)reportScore:(int64_t)score forLeaderboardID:(NSString*)identifier;

- (void)loadLeaderboards;

@end
