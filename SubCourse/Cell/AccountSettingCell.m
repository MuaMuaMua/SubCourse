//
//  AccountSettingCell.m
//  SubCourse
//
//  Created by wuhaibin on 15/12/28.
//  Copyright © 2015年 wuhaibin. All rights reserved.
//

#import "AccountSettingCell.h"
#import <UIKit/UIKit.h>

@implementation AccountSettingCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

/*
 * type:@“0”为手机号码 type:@“1” 为学号 type:@“2”为昵称 type:@"3"为邮箱 type:@“4”为院校
 */
- (void)layoutSubviews {
    switch (self.type) {
        case 0:
            self.nicknameLabel.text = @"手机号码:(不可更改)";
            self.nicknameField.placeholder = @"PHONE NUMBER";
            self.nicknameField.enabled = NO;
            break;
        case 1:
            self.nicknameLabel.text = @"学号:(必填)";
            self.nicknameField.keyboardType = UIKeyboardTypeNumberPad;
            self.nicknameField.placeholder = @"STUDENT NUMBER";
            break;
        case 2:
            self.nicknameLabel.text = @"昵称:(必填)";
            self.nicknameField.placeholder = @"NICKNAME";
            break;
        case 3:
            self.nicknameLabel.text = @"邮箱:(选填)";
            self.nicknameField.placeholder = @"E-MAIL";
            break;
        case 4:
            self.nicknameLabel.text = @"地址:(选填)";
            self.nicknameField.placeholder = @"ADDRESS";
            break;
        default:
            break;
    }
}




@end
