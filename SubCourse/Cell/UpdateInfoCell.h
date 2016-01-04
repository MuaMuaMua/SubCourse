//
//  UpdateInfoCell.h
//  SubCourse
//
//  Created by wuhaibin on 15/12/31.
//  Copyright © 2015年 wuhaibin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UpdateInfoCellDelegate <NSObject>

- (void)enableSendBtn :(BOOL)enable;

@end

@interface UpdateInfoCell : UITableViewCell<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *updateTextField;

@property (strong, nonatomic) NSString * originalContent;

@property (strong, nonatomic) id<UpdateInfoCellDelegate> delegate;

@end
