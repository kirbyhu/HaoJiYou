//
//  HJYDict.h
//  HaoJiYou
//
//  Created by siddontang on 14-5-21.
//  Copyright (c) 2014年 hjy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HJYStore;

@interface HJYDict : NSObject

@property (nonatomic) NSInteger dictID;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* category;
@property (strong, nonatomic) NSString* path;
@property (nonatomic) NSInteger locked;
@property (nonatomic) NSInteger selected;

@property (nonatomic) NSInteger count;
@property (nonatomic) NSInteger knownCount;
@property (nonatomic) NSInteger unkownCount;
@property (nonatomic) NSInteger outstandingCount;

@end
