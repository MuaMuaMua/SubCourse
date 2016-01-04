//
//  UpdateInfoCell.m
//  SubCourse
//
//  Created by wuhaibin on 15/12/31.
//  Copyright © 2015年 wuhaibin. All rights reserved.
//

#import "UpdateInfoCell.h"

@implementation UpdateInfoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([self.updateTextField.text isEqualToString:self.originalContent]) {
        [self.delegate enableSendBtn:NO];
    }else {
        [self.delegate enableSendBtn:YES];
    }
}

- (void)layoutSubviews {
    [self.updateTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

//[textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//...
//第二步,实现回调函数
- (void) textFieldDidChange:(id) sender {
    UITextField *_field = (UITextField *)sender;
    NSLog(@"%@,%d",[_field text],_field.text.length);
    if([self.updateTextField.text isEqualToString:self.originalContent]) {
        [self.delegate enableSendBtn:NO];
    }else {
        [self.delegate enableSendBtn:YES];
    }
}


@end
