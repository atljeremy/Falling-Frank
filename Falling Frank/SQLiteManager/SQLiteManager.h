//
//  SQLiteManager.h
//  Falling Frank
//
//  Created by Jeremy Fox on 10/14/13.
//  Copyright (c) 2013 jeremyfox. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SQLog(message) NSLog(@"Performing SQL Statement: %@", message)

extern NSString* const LEADERBOARD_DB;

@interface SQLiteManager : NSObject

+ (instancetype)sharedInstance;

- (void)purgePlayersTable;

@end
