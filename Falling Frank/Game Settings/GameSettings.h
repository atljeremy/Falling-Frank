//
//  GameSettings.h
//  Falling Frank
//
//  Created by Jeremy Fox on 10/13/13.
//  Copyright (c) 2013 jeremyfox. All rights reserved.
//

#import <Foundation/Foundation.h>

static const int MAX_HIT_COUNT                  = 20;
static const int FEET_TILL_GROUND_ORANGE        = 2000;
static const int FEET_TILL_GROUND_RED           = 1000;
static const int FEET_TILL_GROUND_SUCCEEDED     = 100;
static const int DEFAULT_GAME_LIVES_COUNT       = 2;
static const int DEFAULT_GAME_SCORE             = 100;
static const int GAME_SCORE_HIT_BY_BIRD         = 10; //Subtracted
static const int GAME_SCORE_COLLECTED_POWER_UP  = 100;
static const int GAME_SCORE_COMPLETED_LEVEL     = 500;
static const int GAME_SCORE_PERFECT_LEVEL       = 1000;
static const int TEMP_POWER_UP_SECONDS          = 10;

static NSString* const kGameLivesKey = @"kGameLivesKey";
static NSString* const kGameScoreKey = @"kGameScoreKey";

@interface GameSettings : NSObject

+ (void)addGameLives:(NSInteger)lives forLabel:(CCLabelTTF*)label;
+ (void)subtractGameLives:(NSInteger)lives forLabel:(CCLabelTTF*)label;
+ (void)setGameLives:(NSInteger)lives;
+ (void)resetGameLives;
+ (void)addGameScore:(NSInteger)score forLabel:(CCLabelTTF*)label;
+ (void)subtractGameScore:(NSInteger)score forLabel:(CCLabelTTF*)label;
+ (void)setGameScore:(NSInteger)score;
+ (void)resetGameScore;

@end
