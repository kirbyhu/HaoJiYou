//
//  HJYStore+Private.h
//  HaoJiYou
//
//  Created by siddontang on 14-5-21.
//  Copyright (c) 2014年 hjy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HJYStore.h"

@interface HJYStore (Util)
- (BOOL)execSql:(const char*) sqlStr;
- (sqlite3_stmt*)prepareSql:(const char*) sql;
- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;
@end
