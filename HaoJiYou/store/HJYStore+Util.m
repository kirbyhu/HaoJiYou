//
//  HJYStore+Private.m
//  HaoJiYou
//
//  Created by siddontang on 14-5-21.
//  Copyright (c) 2014年 hjy. All rights reserved.
//

#import "HJYStore+Util.h"

@implementation HJYStore (Util)

- (BOOL)execSql:(const char *)sqlStr {
    char* error = 0;
    if(sqlite3_exec(db, sqlStr, NULL, NULL, &error) != SQLITE_OK){
        NSLog(@"Exec Error: %s, Code: %d", sqlite3_errmsg(db), sqlite3_errcode(db));
        return NO;
    }
    return YES;
}

- (sqlite3_stmt*)prepareSql:(const char*) sql {
    sqlite3_stmt* stmt = 0;
    if(sqlite3_prepare(db, sql, -1, &stmt, 0)!=SQLITE_OK) {
        NSLog(@"Prepare Error: %s, Code: %d", sqlite3_errmsg(db), sqlite3_errcode(db));
        return 0;
    }
    
    return stmt;
}

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey
                                   error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

@end
