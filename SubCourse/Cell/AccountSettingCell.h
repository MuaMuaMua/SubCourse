//
//  AccountSettingCell.h
//  SubCourse
//
//  Created by wuhaibin on 15/12/28.
//  Copyright © 2015年 wuhaibin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AccountSettingCellDelegate <NSObject>

- (void)selectTextField:(int)textFieldType;

@end

@interface AccountSettingCell : UITableViewCell<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UILabel *nicknameLabel;

@property (strong, nonatomic) IBOutlet UITextField *nicknameField;


/*
 * type:@“0”为手机号码 type:@“1” 为学号 type:@“2”为昵称 type:@"3"为邮箱
 */
@property (strong, nonatomic) NSString * textFieldType;

@property int type;

@property (strong, nonatomic) id<AccountSettingCellDelegate> delegate;

@end
