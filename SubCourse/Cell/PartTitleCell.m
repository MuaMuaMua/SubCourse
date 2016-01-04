//
//  PartTitleCell.m
//  SubCourse
//
//  Created by wuhaibin on 15/12/25.
//  Copyright © 2015年 wuhaibin. All rights reserved.
//

#import "PartTitleCell.h"

@implementation PartTitleCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    self.contentView.backgroundColor = [UIColor colorWithRed:18.0/255 green:18.0/255 blue:18.0/255 alpha:1];
    self.partLabel.textColor = [UIColor whiteColor];
}

@end
