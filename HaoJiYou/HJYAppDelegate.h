//
//  HJYAppDelegate.h
//  HaoJiYou
//
//  Created by siddontang on 14-5-18.
//  Copyright (c) 2014年 hjy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HJYStore;

@interface HJYAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic, readonly) HJYStore *store;

@end
