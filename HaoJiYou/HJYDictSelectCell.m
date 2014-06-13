//
//  HJYDictSelectCell.m
//  HaoJiYou
//
//  Created by tangliu on 14-6-13.
//  Copyright (c) 2014年 hjy. All rights reserved.
//

#import "HJYDictSelectCell.h"

@implementation HJYDictSelectCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
