//
//  HJYStore+Dict.h
//  HaoJiYou
//
//  Created by siddontang on 14-5-21.
//  Copyright (c) 2014年 hjy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HJYStoreConst.h"
#import "HJYStore.h"

@class HJYDict;

@interface HJYStore (DictStore)

- (NSMutableArray*) selectWordsFromStore:(HJYDict*)dict wordStatus:(NSInteger)wordStatus;
- (NSMutableArray*) selectWordsToRememberFromStore:(HJYDict*) dict wordCount:(NSInteger) count;

- (BOOL)selectDictInStore:(HJYDict*)dict;

- (BOOL)loadDictsFromPList;
- (BOOL)unlockDictInStore:(HJYDict*)dict;

- (HJYDict*)getDictByNameFromStore:(NSString*)name;

- (HJYDict*)addDictMetaToStore:(HJYDict*) dict;
- (BOOL)addDictDataToStore:(NSString*) dataFile dictId:(NSInteger) did;
- (BOOL)clearDictDataFromStore:(NSInteger) dictId;

- (BOOL)updateDictMetaInStore:(HJYDict*) dict;

- (NSInteger)getDictWordCountFromStore:(NSInteger)dictId;
- (NSInteger)getDictWordCountFromStore:(NSInteger)dictId wordStatus:(NSInteger) stauts;

- (NSMutableArray*) selectWordsFromStmt:(sqlite3_stmt*) stmt wordStatus:(NSInteger) wordStatus;

- (BOOL)createDictStore;
- (BOOL)createDictTable;
- (BOOL)createWordTable;

@end
