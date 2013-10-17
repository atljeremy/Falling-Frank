//
//  Player.h
//  Falling Frank
//
//  Created by Jeremy Fox on 10/14/13.
//  Copyright (c) 2013 jeremyfox. All rights reserved.
//

#import "ZIMOrmModel.h"

extern NSString* const PLAYERS_TABLE;
extern NSString* const PLAYER_ID;
extern NSString* const PLAYER_NAME;
extern NSString* const PLAYER_USERNAME;
extern NSString* const PLAYER_FORMATTED_SCORE;
extern NSString* const PLAYER_SCORE;
extern NSString* const PLAYER_UPDATED_AT;
extern NSString* const PLAYER_CREATED_AT;

@interface Player : ZIMOrmModel {
@protected
    NSString* _id;
    NSString* _name;
    NSString* _username;
    NSString* _formattedScore;
    NSNumber* _score;
    NSDate* _updatedAt;
    NSDate* _createdAt;
}

@property (nonatomic, strong) NSString* id;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* username;
@property (nonatomic, strong) NSString* formattedScore;
@property (nonatomic, strong) NSNumber* score;
@property (nonatomic, strong) NSDate* updatedAt;
@property (nonatomic, strong) NSDate* createdAt;

+ (instancetype)playerWithName:(NSString*)name username:(NSString*)username score:(NSNumber*)score;
+ (NSArray*)allPlayers;
- (void)updateName:(NSString*)name username:(NSString*)username score:(NSNumber*)score;
+ (void)purgeAllPlayers;

@end
