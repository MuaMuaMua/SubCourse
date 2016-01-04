//
//  FavouriteCell.m
//  SubCourse
//
//  Created by wuhaibin on 15/12/30.
//  Copyright © 2015年 wuhaibin. All rights reserved.
//

#import "FavouriteCell.h"

@implementation FavouriteCell{

    IBOutlet UILabel *_titleLabel;
    
    IBOutlet UILabel *_dateLabel;
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
