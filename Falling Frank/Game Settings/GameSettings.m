//
//  GameSettings.m
//  Falling Frank
//
//  Created by Jeremy Fox on 10/13/13.
//  Copyright (c) 2013 jeremyfox. All rights reserved.
//

#import "GameSettings.h"

@implementation GameSettings

#pragma mark -----------------------------
#pragma mark NSUSerDefaults
#pragma mark -----------------------------

+ (void)addGameLives:(NSInteger)lives forLabel:(CCLabelTTF*)label
{
    NSNumber* livesLeft = [[NSUserDefaults standardUserDefaults] objectForKey:kGameLivesKey];
    lives = [livesLeft integerValue] + lives;
    [self setInteger:lives forKey:kGameLivesKey onLabel:label];
}

+ (void)subtractGameLives:(NSInteger)lives forLabel:(CCLabelTTF*)label
{
    NSNumber* livesLeft = [[NSUserDefaults standardUserDefaults] objectForKey:kGameLivesKey];
    lives = [livesLeft integerValue] - lives;
    [self setInteger:lives forKey:kGameLivesKey onLabel:label];
}

+ (void)setGameLives:(NSInteger)lives
{
    [self setInteger:lives forKey:kGameLivesKey onLabel:nil];
}

+ (void)resetGameLives
{
    [self setInteger:DEFAULT_GAME_LIVES_COUNT forKey:kGameLivesKey onLabel:nil];
}

+ (void)addGameScore:(NSInteger)score forLabel:(CCLabelTTF*)label
{
    NSNumber* currentScore = [[NSUserDefaults standardUserDefaults] objectForKey:kGameScoreKey];
    score = [currentScore integerValue] + score;
    [self setInteger:score forKey:kGameScoreKey onLabel:label];
}

+ (void)subtractGameScore:(NSInteger)score forLabel:(CCLabelTTF*)label
{
    NSNumber* currentScore = [[NSUserDefaults standardUserDefaults] objectForKey:kGameScoreKey];
    score = [currentScore integerValue] - score;
    [self setInteger:score forKey:kGameScoreKey onLabel:label];
}

+ (void)setGameScore:(NSInteger)score
{
    [self setInteger:score forKey:kGameScoreKey onLabel:nil];
}

+ (void)resetGameScore
{
    [self setInteger:DEFAULT_GAME_SCORE forKey:kGameScoreKey onLabel:nil];
}

+ (void)setInteger:(NSInteger)value forKey:(NSString*)key onLabel:(CCLabelTTF*)label
{
    [[NSUserDefaults standardUserDefaults] setObject:@(value) forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (label) [label setString:[NSString stringWithFormat:@"%d", value]];
}

@end
