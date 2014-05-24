//
//  HJYStore+Dict.m
//  HaoJiYou
//
//  Created by siddontang on 14-5-21.
//  Copyright (c) 2014年 hjy. All rights reserved.
//

#import "HJYStore+DictStore.h"
#import "HJYStore+Util.h"
#import "HJYDict.h"
#import "HJYWord.h"
#import "HJYStoreConst.h"
#import <stdio.h>
#import <string.h>

@interface HJYStore ()
@property (strong, nonatomic, readwrite) NSMutableArray* dictList;
@property (strong, nonatomic, readwrite) NSMutableDictionary* dictMap;
@end


@implementation HJYStore (DictStore)

- (BOOL)createDictTable {
    const char * table = "create table if not exists `tbl_dict` ("
                         "`id` integer primary key autoincrement,"
                         "`name` text not null unique,"
                         "`category` text not null,"
                         "`locked` integer not null)";
    
    if([self execSql:table] != YES) {
        return NO;
    }

    return YES;
}

- (BOOL)createWordTable {
    const char* table = "create table if not exists `tbl_word` ("
                        "`id` integer primary key autoincrement,"
                        "`word` text not null,"
                        "`pron` text not null,"
                        "`desp` text not null,"
                        "`status` integer not null,"
                        "`dict_id` integer not null)";
    
    if ([self execSql:table] != YES) {
        return NO;
    }
    
    const char* index = "create unique index if not exists `idx_word` on `tbl_word` (`dict_id`, `word`)";
    
    if ([self execSql:index] != YES) {
        return NO;
    }
    
    index = "create index if not exists `idx_status` on `tbl_word` (`dict_id`, `status`)";
    
    if ([self execSql:index] != YES) {
        return NO;
    }
    
    return YES;
}

- (BOOL)createDictStore {
    if ([self createDictTable] != YES) {
        return NO;
    }
    
    if ([self createWordTable] != YES) {
        return NO;
    }
    
    return YES;
}


- (HJYDict*)addDictMetaToStore:(HJYDict *)dict {
    const char * sql = [[NSString stringWithFormat:@"insert into `tbl_dict` (`name`, `category`, `locked`) values ('%@', '%@', 1)",dict.name, dict.category] UTF8String];

    if ([self execSql:sql] != YES) {
        return nil;
    }
    
    dict.dictID = (int)sqlite3_last_insert_rowid(db);
    
    return dict;
}

- (NSInteger) getDictWordCountFromStore:(NSInteger) dictId {
    const char* sql = [[NSString stringWithFormat:@"select count(*) from `tbl_word` where `id` = %d", dictId] UTF8String];
    
    int count = 0;
    sqlite3_stmt* stmt = [self prepareSql:sql];
    if (sqlite3_step(stmt) == SQLITE_ROW) {
        count = sqlite3_column_int(stmt, 1);
    }
    
    sqlite3_finalize(stmt);
    return count;
}

- (NSInteger) getDictWordCountFromStore:(NSInteger) dictId wordStatus:(NSInteger)stauts {
    const char* sql = [[NSString stringWithFormat:@"select count(*) from `tbl_word` where `id` = %d and `status` = %d", dictId, stauts] UTF8String];
    
    int count = 0;
    sqlite3_stmt* stmt = [self prepareSql:sql];
    if (sqlite3_step(stmt) == SQLITE_ROW) {
        count = sqlite3_column_int(stmt, 1);
    }
    
    sqlite3_finalize(stmt);
    return count;
}

- (BOOL)addDictDataToStore:(NSString*) dataFile dictId:(NSInteger) did {
    if ([self getDictWordCountFromStore:did] > 0) {
        return YES;
    }
    
    NSError* error = nil;
    NSString* content = [NSString stringWithContentsOfFile:dataFile encoding:NSUTF8StringEncoding error:&error];
    if (!content) {
        NSLog(@"Error: load dict data error %@", error);
        return NO;
    }
    
    NSArray* lines =
    [content componentsSeparatedByString:@"\n"];
    
    char buffer[1024];
    buffer[sizeof(buffer) - 1] = '\0';
    const char* delims = ",";
    char* savePtr = 0;
    
    const char* sql = "insert into `tbl_word` (`word`, `pron`, `desp`, `status`, `dict_id`) "
                      "values (?, ?, ?, ?, ?)";
    sqlite3_stmt* stmt = [self prepareSql:sql];
    if (!stmt) {
        return NO;
    }
    
    for (int i = 0; i < [lines count]; i++) {
        NSString* line = [[lines objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        strncpy(buffer, [line UTF8String], sizeof(buffer) - 1);
        
        char* name = strtok_r(buffer, delims, &savePtr);
        char* pron = strtok_r(NULL, delims, &savePtr);
        char* desp = savePtr;
        if (name == NULL || pron == NULL || desp == NULL) {
            continue;
        }
        
        sqlite3_bind_text(stmt, 1, name, strlen(name), SQLITE_STATIC);
        sqlite3_bind_text(stmt, 2, pron, strlen(pron), SQLITE_STATIC);
        sqlite3_bind_text(stmt, 3, desp, strlen(desp), SQLITE_STATIC);
        sqlite3_bind_int(stmt, 4, kHJYNewWord);
        sqlite3_bind_int(stmt, 5, did);
        
        if(sqlite3_step(stmt) != SQLITE_DONE){
            NSLog(@"Step Error: %s, Code: %d", sqlite3_errmsg(db), sqlite3_errcode(db));
            sqlite3_finalize(stmt);
            return NO;
        }
        
        sqlite3_reset(stmt);
    }
    
    sqlite3_finalize(stmt);
    
    return YES;
}

- (BOOL) clearDictDataFromStore:(NSInteger)dictId {
    const char* sql = [[NSString stringWithFormat:@"delete from `tbl_word` where `dict_id` = %d", dictId] UTF8String];
    
    if ([self execSql:sql] != YES) {
        NSLog(@"delete dict data error");
    }
    
    return YES;
}

- (HJYDict*) getDictByNameFromStore:(NSString*)name {
    const char* sql = [[NSString stringWithFormat:@"select `id`, `category`, `locked` from `tbl_dict` where `name` = '%@'", name] UTF8String];
    sqlite3_stmt* stmt = [self prepareSql:sql];
    
    HJYDict* dict = nil;
    int n = sqlite3_step(stmt);
    if (n == SQLITE_ROW) {
        dict = [[HJYDict alloc]init];
        dict.dictID = sqlite3_column_int(stmt, 1);
        dict.name = name;
        dict.category = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(stmt, 2)];
        dict.locked = sqlite3_column_int(stmt, 3);
    }
    
    sqlite3_finalize(stmt);
    
    return dict;
}

- (BOOL) loadDictsFromPList {
    NSString* plist = [[NSBundle mainBundle] pathForResource:@"dict" ofType:@"plist"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:plist]) {
        NSLog(@"file not exist");
        return NO;
    }

    NSArray* dictMetas = [[NSArray alloc]initWithContentsOfFile:plist];

    self.dictList = [[NSMutableArray alloc] initWithCapacity:[dictMetas count]];
    
    self.dictMap = [[NSMutableDictionary alloc] initWithCapacity:[dictMetas count]];
    
    for (int i = 0; i < [dictMetas count]; i++) {
        NSDictionary* meta = [dictMetas objectAtIndex:i];
    
        NSString* name = [meta objectForKey:@"name"];
        
        if ([self.dictMap objectForKey:name]) {
            NSLog(@"dict name conflict %@, ignore", name);
            continue;
        }
        
        NSString* path = [meta objectForKey:@"path"];

        if (![[NSFileManager defaultManager]fileExistsAtPath:[[NSBundle mainBundle] pathForResource:path ofType:@"csv"]]) {
            NSLog(@"dict %@ file %@ not exists ignore", name, path);
            continue;
        }

        
        HJYDict* dict = [self getDictByNameFromStore:name];
        if (!dict) {
            dict = [[HJYDict alloc]init];
            dict.name = name;
            dict.category = [meta objectForKey:@"category"];
            dict.locked = 1;

            dict = [self addDictMetaToStore:dict];
            if (!dict) {
                NSLog(@"add dict meta error");
                return NO;
            }
        } else {
            //update category if changed
            //later update something ....
        }
        
        dict.path = path;
        
        [self.dictList addObject:dict];
        
        [self.dictMap setObject:dict forKey:name];
    }
    
    return YES;
}

- (BOOL)updateDictMetaInStore:(HJYDict *)dict {
    const char* sql = [[NSString stringWithFormat:@"update `tbl_dict` set `category` = '%@', `locked` = %d", dict.category, dict.locked] UTF8String];
    
    return [self execSql:sql];
}

- (BOOL)unlockDictInStore:(HJYDict *)dict {
    NSString* dictData =[[NSBundle mainBundle] pathForResource:dict.path ofType:@"csv"];
    
    if (![self addDictDataToStore:dictData dictId:dict.dictID]) {
        [self clearDictDataFromStore:dict.dictID];
        NSLog(@"add dict data error");
        return NO;
    }
    
    dict.locked = 0;
    if (![self updateDictMetaInStore:dict]) {
        NSLog(@"update dict meta error");
        dict.locked = 1;
        return NO;
    }
    
    return YES;
}

- (BOOL)selectDictInStore:(HJYDict *)dict {
    dict.count = [self getDictWordCountFromStore:dict.dictID];
    dict.knownCount = [self getDictWordCountFromStore:dict.dictID wordStatus:kHJYKnownWord] + [self getDictWordCountFromStore:dict.dictID wordStatus:kHJYMasteredWord];
    dict.outstandingCount = [self getDictWordCountFromStore:dict.dictID wordStatus:kHJYOutstandingWord];
    dict.unkownCount = [self getDictWordCountFromStore:dict.dictID wordStatus:kHJYUnknownWord];
    
    return YES;
}

- (NSMutableArray*) selectWordsFromStore:(HJYDict *)dict wordStatus:(NSInteger)wordStatus {
    const char * sql = [[NSString stringWithFormat:@"select `id`, `word`, `pron`, `desp` from `tbl_word` where `dict_id` = %d and `status` = %d", dict.dictID, wordStatus] UTF8String];
    
    sqlite3_stmt* stmt = [self prepareSql:sql];
    if (!stmt) {
        return nil;
    }
    
    return [self selectWordsFromStmt:stmt wordStatus:wordStatus];
}

- (NSMutableArray*) selectWordsToRememberFromStore:(HJYDict *)dict wordCount:(NSInteger)count {
    //now we only use newwords
    const char * sql = [[NSString stringWithFormat:@"select `id`, `word`, `pron`, `desp` from `tbl_word` where `dict_id` = %d and `status` = %d order by `word` limit %d", dict.dictID, kHJYNewWord, count] UTF8String];
    
    sqlite3_stmt* stmt = [self prepareSql:sql];
    if (!stmt) {
        return nil;
    }
    
    return [self selectWordsFromStmt:stmt wordStatus:kHJYNewWord];
}

- (NSMutableArray*) selectWordsFromStmt:(sqlite3_stmt*) stmt wordStatus:(NSInteger) wordStatus {
    NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity:64];
    
    while (sqlite3_step(stmt) == SQLITE_ROW) {
        HJYWord* word = [[HJYWord alloc] init];
        word.status = wordStatus;
        word.wordId = sqlite3_column_int(stmt, 1);
        word.word =  [NSString stringWithUTF8String:(char*)sqlite3_column_text(stmt, 2)];
        [array addObject:word];
    }
    
    sqlite3_finalize(stmt);
    return array;
}

@end
