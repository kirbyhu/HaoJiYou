//
//  HJYStoreConst.h
//  HaoJiYou
//
//  Created by siddontang on 14-5-21.
//  Copyright (c) 2014年 hjy. All rights reserved.
//

#ifndef HaoJiYou_HJYStoreConst_h
#define HaoJiYou_HJYStoreConst_h

enum HJYDictLevel {
    kHJYBasicLevel         = 1,
    kHJYIntermediateLevel  = 2,
    kHJYAdvancedLevel      = 3,
};

enum HJYWordStatus {
    kHJYNewWord            = 1 << 0,
    kHJYOutstandingWord    = 1 << 1,
    kHJYUnknownWord        = 1 << 2,
    kHJYKnownWord          = 1 << 3,
    kHJYMasteredWord       = 1 << 4,
};

#endif
