//
//  SQLiteManager.m
//  Falling Frank
//
//  Created by Jeremy Fox on 10/14/13.
//  Copyright (c) 2013 jeremyfox. All rights reserved.
//

#import "SQLiteManager.h"
#import "ZIMDbSdk.h"
#import "ZIMSqlSdk.h"
#import "ZIMOrmSdk.h"

/**
 * All Database versions
 *
 * New database versions MUST be created as a new constant matching
 * the style of the versions below
 *
 * The ZIMDbMigrationDelegate method migratingDataSource:fromVersion:toVersion:
 * utilizes each version in a switch statement to ensure proper migration
 * from one version to the next
 */
NSInteger const DB_VERSION_ZERO = 0; // New user
NSInteger const DB_VERSION_ONE  = 1;
//NSInteger const DB_VERSION_TWO  = 2; // Next version

NSString* const LEADERBOARD_DB = @"leaderboard";

@interface SQLiteManager() <ZIMDbMigrationDelegate>
@property (nonatomic, strong) ZIMDbConnection* db;
@end

@implementation SQLiteManager

- (id)init {
    if (self = [super init]) {
        ZIMDbMigration* dbMigration = [[ZIMDbMigration alloc] initWithDataSource:LEADERBOARD_DB andDelegate:self];
        [dbMigration performMigrationIfRequireForVersion:DB_VERSION_ONE];
    }
    return self;
}

+ (instancetype)sharedInstance
{
    static SQLiteManager* sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark -------------------
#pragma mark CREATE STATEMENTS
#pragma mark -------------------

- (void)createPlayersTable {
    @synchronized (self) {
        [self openConnection];
        ZIMSqlCreateTableStatement *create = [[ZIMSqlCreateTableStatement alloc] init];
        [create table:[Player table]];
        [create column:PLAYER_ID            type:ZIMSqlDataTypeInteger defaultValue:ZIMSqlDefaultValueIsAutoIncremented];
        [create column:PLAYER_NAME          type:ZIMSqlDataTypeVarChar(255)];
        [create column:PLAYER_USERNAME      type:ZIMSqlDataTypeVarChar(255)];
        [create column:PLAYER_SCORE         type:ZIMSqlDataTypeVarChar(255)];
        [create column:PLAYER_UPDATED_AT    type:ZIMSqlDataTypeDateTime];
        [create column:PLAYER_CREATED_AT    type:ZIMSqlDataTypeDateTime];
        NSString* statement = [create statement];
        SQLog(statement);
        NSNumber* result = [self.db execute:statement];
        NSLog(@"Players Table %@ created!", ([result boolValue]) ? @"Was" : @"Was NOT");
        [self.db close];
    }
}

#pragma mark -------------------
#pragma mark SELECT STATEMENTS
#pragma mark -------------------

- (NSArray*)getPlayersByScoreDesc:(BOOL)desc withRange:(NSRange)range {
    @synchronized (self) {
        [self openConnection];
        ZIMSqlSelectStatement* select = [[ZIMSqlSelectStatement alloc] init];
        [select from:[Player table]];
        [select orderBy:PLAYER_SCORE descending:desc];
        [select where:PLAYER_ID operator:ZIMSqlOperatorGreaterThanOrEqualTo value:@(range.location)];
        [select limit:range.length];
        NSString* statement = [select statement];
        SQLog(statement);
        NSArray* players = [self.db query:statement asObject:[Player class]];
        return players;
    }
}

#pragma mark -------------------
#pragma mark DELETE STATEMENTS
#pragma mark -------------------

- (void)dropPlayersTable {
    @synchronized (self) {
        [self openConnection];
        ZIMSqlDropTableStatement *drop = [[ZIMSqlDropTableStatement alloc] init];
        [drop table:[Player table] exists:YES];
        NSString *statement = [drop statement];
        SQLog(statement);
        [self.db execute:statement];
        [self.db close];
    }
}

- (void)deleteAllPlayerRecords {
    @synchronized (self) {
        [self openConnection];
        NSString* sql = [NSString stringWithFormat:@"DELETE FROM %@;", [Player table]];
        ZIMSqlPreparedStatement* deleteAll = [[ZIMSqlPreparedStatement alloc] initWithSqlStatement:sql];
        NSString* statement = [deleteAll statement];
        SQLog(statement);
        NSNumber* success = [self.db execute:statement];
        NSLog(@"All Player Records %@ Deleted!", ([success boolValue] ? @"Were" : @"Were Not" ));
        [self.db close];
    }
}

#pragma mark -------------------
#pragma mark HELPER METHODS
#pragma mark -------------------

- (void)openConnection {
    if (!self.db) {
        self.db = [[ZIMDbConnection alloc] initWithDataSource:LEADERBOARD_DB withMultithreadingSupport:YES];
    } else if (![self.db isConnected]) {
        [self.db open];
    }
}

- (void)purgePlayersTable {
    [self deleteAllPlayerRecords];
}

#pragma mark -------------------
#pragma mark ZIMDbMigrationDelegate
#pragma mark -------------------

- (void)migratingDataSource:(NSString*)dataSource fromVersion:(NSInteger)oldVersion toVersion:(NSInteger)newVersion {
    
    /**
     * Switch statement for migrating the database in proper order.
     *
     * VERY IMPORTANT: Each case must NOT 'break;'. This would cause the migration to
     * fail because it would skip over any additional db versions during migration.
     */
    switch (oldVersion) {
        case DB_VERSION_ZERO:
            // Migrating from version 0 to version 1
            [self createPlayersTable];
            
            //case DB_VERSION_ONE:
            // PLACEHOLDER: Migrating from version 1 to version 2
            
    }
}

@end
