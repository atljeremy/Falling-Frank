//
//  HelloWorldLayer.h
//  Falling Frank
//
//  Created by Jeremy Fox on 9/3/13.
//  Copyright jeremyfox 2013. All rights reserved.
//

#import <GameKit/GameKit.h>

@interface MainMenuLayer : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>

+ (CCScene *)scene;

@end
