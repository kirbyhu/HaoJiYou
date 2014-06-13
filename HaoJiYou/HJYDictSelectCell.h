//
//  HJYDictSelectCell.h
//  HaoJiYou
//
//  Created by tangliu on 14-6-13.
//  Copyright (c) 2014年 hjy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HJYDictSelectCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lockedLabel;
@property (weak, nonatomic) IBOutlet UIButton *unlockButton;
@end
