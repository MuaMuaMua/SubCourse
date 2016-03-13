//
//  SCRootViewController.h
//  SubCourse
//
//  Created by wuhaibin on 15/11/27.
//  Copyright © 2015年 wuhaibin. All rights reserved.
//

#import "UMViewController.h"

@interface SCRootViewController : UMViewController

@property (strong, nonatomic) UIBarButtonItem * rightBtn;

@property (strong, nonatomic) UIButton * qrCodeBtn;

- (void)clickQRCodeBtn;

@end
