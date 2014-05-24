//
//  HJYWord.h
//  HaoJiYou
//
//  Created by siddontang on 14-5-24.
//  Copyright (c) 2014年 hjy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HJYDict;
@interface HJYWord : NSObject

@property (nonatomic) NSInteger wordId;
@property (nonatomic) NSInteger status;
@property (nonatomic, strong, readwrite) NSString* word;
@property (nonatomic, strong, readwrite) NSString* description;
@property (nonatomic, strong, readwrite) NSString* pronunciation;

@end
