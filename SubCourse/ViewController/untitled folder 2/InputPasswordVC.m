//
//  InputPasswordVC.m
//  SubCourse
//
//  Created by wuhaibin on 15/12/28.
//  Copyright © 2015年 wuhaibin. All rights reserved.
//

#import "InputPasswordVC.h"
#import "AccountSettingVC.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"


@interface InputPasswordVC ()<UITextFieldDelegate,MBProgressHUDDelegate>{
    
    IBOutlet UITextField *_passwordField;
    
    IBOutlet UITextField *_passwordAgainField;
    
    IBOutlet UIButton *_nextBtn;
}

@end

@implementation InputPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _passwordAgainField.keyboardType = UIKeyboardTypeNumberPad;
    _passwordField.keyboardType = UIKeyboardTypeNumberPad;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)nextAction:(id)sender {
    //先判断密码长度再验证 两次密码输入是否一致
    if (_passwordAgainField .text.length < 6 || _passwordAgainField.text.length > 12) {
        [MBProgressHUD showError:@"密码长度要求为6-12位"];
//        [MBProgressHUD showError:@"手机号码长度不正确"];
    }else {
        if ([_passwordAgainField.text isEqualToString:_passwordField.text]) {
            [[NSUserDefaults standardUserDefaults]setObject:_passwordField.text forKey:@"password"];
            AccountSettingVC * accountSettingVC = [[AccountSettingVC alloc]init];
            [self.navigationController pushViewController:accountSettingVC animated:YES];
        }else {
            [MBProgressHUD showError:@"两次输入不一致"];
        }
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}

@end
