//
//  PageDetailCell.m
//  SubCourse
//
//  Created by wuhaibin on 15/12/25.
//  Copyright © 2015年 wuhaibin. All rights reserved.
//

#import "PageDetailCell.h"

@implementation PageDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
//    self.contentView.backgroundColor = [UIColor colorWithRed:18.0/255 green:18.0/255 blue:18.0/255 alpha:1];
    self.pageTitleLabel.textColor = [UIColor whiteColor];
    self.countLabel.textColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor clearColor];
}

@end
