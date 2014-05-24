//
//  HJYStore.h
//  HaoJiYou
//
//  Created by siddontang on 14-5-18.
//  Copyright (c) 2014年 hjy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@class HJYDict;

@interface HJYStore : NSObject {
    sqlite3* db;
    
    sqlite3* cacheDB;
}

- (id)init;
- (NSString*) storePath;
- (NSString*) cacheStorePath;
- (void)close;

- (void)saveConfig;

- (BOOL) unlockDict:(HJYDict*) dict;
- (BOOL) selectDict:(HJYDict*) dict;

- (NSMutableArray*) selectWords:(NSInteger) status;
- (NSMutableArray*) selectWordsToRemember;
- (NSMutableArray*) selectWordsToRemember:(NSInteger) count;

@property (strong, nonatomic, readonly) NSMutableArray* dictList;
@property (strong, nonatomic, readonly) NSMutableDictionary* dictMap;
@property (strong, nonatomic) NSMutableDictionary* config;
@property (strong, nonatomic, readonly) HJYDict* currentDict;


@end
