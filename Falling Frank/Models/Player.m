//
//  Player.m
//  Falling Frank
//
//  Created by Jeremy Fox on 10/14/13.
//  Copyright (c) 2013 jeremyfox. All rights reserved.
//

#import "Player.h"
#import "ZIMOrmSelectStatement.h"

// Player DB
NSString* const PLAYERS_TABLE           = @"players";
NSString* const PLAYER_ID               = @"id";
NSString* const PLAYER_NAME             = @"name";
NSString* const PLAYER_USERNAME         = @"username";
NSString* const PLAYER_FORMATTED_SCORE  = @"formattedScore";
NSString* const PLAYER_SCORE            = @"score";
NSString* const PLAYER_UPDATED_AT       = @"updatedAt";
NSString* const PLAYER_CREATED_AT       = @"createdAt";

@implementation Player

- (id)init {
    if (self = [super init]) {
        _saved = nil;
        _delegate = self;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name              forKey:PLAYER_NAME];
    [aCoder encodeObject:self.username          forKey:PLAYER_USERNAME];
    [aCoder encodeObject:self.score             forKey:PLAYER_SCORE];
    [aCoder encodeObject:self.formattedScore    forKey:PLAYER_FORMATTED_SCORE];
    [aCoder encodeObject:self.updatedAt         forKey:PLAYER_UPDATED_AT];
    [aCoder encodeObject:self.createdAt         forKey:PLAYER_CREATED_AT];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _name           = [aDecoder decodeObjectForKey:PLAYER_NAME];
        _username       = [aDecoder decodeObjectForKey:PLAYER_USERNAME];
        _score          = [aDecoder decodeObjectForKey:PLAYER_SCORE];
        _formattedScore = [aDecoder decodeObjectForKey:PLAYER_FORMATTED_SCORE];
        _updatedAt      = [aDecoder decodeObjectForKey:PLAYER_UPDATED_AT];
        _createdAt      = [aDecoder decodeObjectForKey:PLAYER_CREATED_AT];
    }
    return self;
}

- (instancetype)initWithName:(NSString*)name username:(NSString*)username score:(NSNumber*)score
{
    if (self = [super init]) {
        _name       = name;
        _username   = username;
        _score      = score;
        _formattedScore = [self getFormattedScoreFromScore:score];
        NSDate* now = [NSDate date];
        _updatedAt  = now;
        _createdAt  = now;
    }
    return self;
}

+ (instancetype)playerWithName:(NSString*)name username:(NSString*)username score:(NSNumber*)score
{
    if (!name || !username || !score) {
        return nil;
    }
    return [[Player alloc] initWithName:name username:username score:score];
}

#pragma mark -------------------
#pragma mark ZIMOrmModel Stack
#pragma mark -------------------

+ (NSString *)dataSource {
	return LEADERBOARD_DB;
}

+ (NSString *)table {
	return PLAYERS_TABLE;
}

+ (NSArray *)primaryKey {
	return @[PLAYER_ID];
}

+ (NSArray *)queryableColumns {
    return @[PLAYER_ID, PLAYER_NAME, PLAYER_USERNAME, PLAYER_SCORE];
}

+ (BOOL)isAutoIncremented {
	return YES;
}

#pragma mark -------------------
#pragma mark SELECT
#pragma mark -------------------

+ (NSArray*)allPlayers {
    ZIMOrmSelectStatement *select = [[ZIMOrmSelectStatement alloc] initWithModel:[Player class]];
    return [select query];
}

#pragma mark -------------------
#pragma mark UPDATE
#pragma mark -------------------

- (void)updateName:(NSString*)name username:(NSString*)username score:(NSNumber*)score
{
    if (name) self.name = name;
    if (username) self.username = username;
    if (score) self.score = score;
    [self save];
}

+ (void)purgeAllPlayers
{
    [[SQLiteManager sharedInstance] purgePlayersTable];
}

#pragma mark -------------------
#pragma mark UPDATE
#pragma mark -------------------

- (NSString*)getFormattedScoreFromScore:(NSNumber*)score
{
    NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    return [[formatter stringFromNumber:score] stringByAppendingString:@"points"];
}

@end
