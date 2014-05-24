//
//  HJYStore.m
//  HaoJiYou
//
//  Created by siddontang on 14-5-18.
//  Copyright (c) 2014年 hjy. All rights reserved.
//

#import "HJYStore.h"
#import "HJYStore+Util.h"
#import "HJYStore+DictStore.h"
#import "HJYDict.h"

@interface HJYStore()

- (BOOL)openStore;
- (BOOL)createStorePath;
- (BOOL)openStoreConfig;
- (BOOL)loadStoreConfig;

@property (strong, nonatomic, readwrite) NSMutableArray* dictList;
@property (strong, nonatomic, readwrite) NSMutableDictionary* dictMap;
@property (strong, nonatomic, readwrite) HJYDict* currentDict;

@end

@implementation HJYStore

- (id)init {
    self = [super init];
    if(self) {
        if([self openStore] != YES) {
            return nil;
        }
    }
    
    return self;
}

- (void)close {
    sqlite3_close(db);
}

- (NSString*)storePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *store = [documentDirectory stringByAppendingPathComponent:@"store"];
    return store;
}

- (NSString*)cacheStorePath {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    return [paths objectAtIndex:0];
}

- (BOOL) createStorePath {
    NSString* path = [self storePath];
    bool exists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if(!exists) {
        NSError *error = nil;
        if([[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error] != YES) {
            NSLog(@"Error create store path %@", error);
            return NO;
        }
        
        if ([self addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:path]] != YES) {
            return NO;
        }
    }

    return YES;
}

- (BOOL) openStore {
    if ([self createStorePath] != YES) {
        return NO;
    }
    
    NSString* path = [[self storePath] stringByAppendingPathComponent:@"hjy.db"];
    if(sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
        NSLog(@"Open Error: %s, Code: %d", sqlite3_errmsg(db), sqlite3_errcode(db));
        return NO;
    }
    
//    path = [[self cacheStorePath] stringByAppendingString:@"hjy_cache.db"];
//    if (sqlite3_open([path UTF8String], &cacheDB) != SQLITE_OK) {
//        NSLog(@"Open Error: %s, Code: %d", sqlite3_errmsg(cacheDB), sqlite3_errcode(cacheDB));
//        return NO;
//    }
    
    if ([self openStoreConfig] != YES) {
        return NO;
    }
    
    if([self createDictStore] != YES) {
        return NO;
    }
    
    if ([self loadDictsFromPList] != YES) {
        return NO;
    }
    
    if ([self loadStoreConfig] != YES) {
        return NO;
    }
    
    return YES;
}

- (BOOL)unlockDict:(HJYDict *)dict {
    if (dict.locked == 0) {
        return YES;
    }
    
    //later, check key number
    
    if ([self unlockDictInStore:dict] != YES) {
        return NO;
    }
    
    return YES;
}

- (BOOL)selectDict:(HJYDict *)dict {
    if (self.currentDict == dict) {
        return YES;
    }
    
    if (dict.locked == 1) {
        NSLog(@"Error, dict %@ is locked, cannot select", dict.name);
        return NO;
    }
    
    if (![self selectDictInStore:dict]) {
        return NO;
    }

    if (self.currentDict) {
        self.currentDict.selected = 0;
    }
    
    self.currentDict = dict;
    self.currentDict.selected = 1;
    
    [self.config setObject:dict.name forKey:@"dict_name"];
    [self saveConfig];
    
    
    return YES;
}

- (BOOL)openStoreConfig {
    NSString* path =[[self storePath] stringByAppendingPathComponent:@"hjy_store.plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        //open path
        self.config = [[NSMutableDictionary alloc]initWithContentsOfFile:path];
    } else {
        //create new plist
        self.config = [[NSMutableDictionary alloc]init];
    }
    
    return YES;
}

- (BOOL)loadStoreConfig {
    NSString* dictName = [self.config objectForKey:@"dict_name"];
    if (dictName) {
        self.currentDict = [self.dictMap objectForKey:dictName];
        self.currentDict.selected = 1;
    }
    
    return YES;
}

- (void)saveConfig {
    NSString* path =[[self storePath] stringByAppendingPathComponent:@"hjy_store.plist"];
    [self.config writeToFile:path atomically:YES];
}

- (NSMutableArray*) selectWords:(NSInteger)status {
    if (!self.currentDict) {
        NSLog(@"Error: no dict selected, cannot select words");
        return nil;
    }
    
    return [self selectWordsFromStore:self.currentDict wordStatus:status];
}

- (NSMutableArray*) selectWordsToRemember:(NSInteger)count {
    if (!self.currentDict) {
        NSLog(@"Error: no dict selected, cannot select words");
        return nil;
    }
    
    return [self selectWordsToRememberFromStore:self.currentDict wordCount:count];
}

static const NSInteger defaultSelectWords = 20;

- (NSMutableArray*) selectWordsToRemember {
    return [self selectWordsToRemember:defaultSelectWords];
}

@end
