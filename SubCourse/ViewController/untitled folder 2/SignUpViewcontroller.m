//
//  SignUpViewcontroller.m
//  SubCourse
//
//  Created by wuhaibin on 15/12/28.
//  Copyright © 2015年 wuhaibin. All rights reserved.
//

#import "SignUpViewcontroller.h"
#import "SubcourseManager.h"
#import "CacheManager.h"
#import "InputPasswordVC.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"

@interface SignUpViewcontroller ()<SubcourseManagerDelegate,MBProgressHUDDelegate>{
    
    IBOutlet UITextField *_phoneField;
    
    IBOutlet UITextField *_validationField;
    
    IBOutlet UIButton *_validateBtn;
    
    IBOutlet UIButton *_backBtn;
    
    SubcourseManager * _scManager;
    
    CacheManager * _cManager;
}

@end

@implementation SignUpViewcontroller

- (void)viewDidLoad {
    [super viewDidLoad];
//    _phoneField.
    _phoneField.keyboardType = UIKeyboardTypeNumberPad;
    _validationField.keyboardType = UIKeyboardTypeNumberPad;
    self.navigationController.navigationBar.hidden = YES;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - subcourseManager delegate && cacheManager settings 

- (void)scManagerAndcManagerSetting {
    _scManager = [SubcourseManager sharedInstance];
    _cManager = [CacheManager sharedInstance];
    _scManager.delegate = self;
}

#pragma mark - textField rightView initialization 

- (void)textFieldRightViewSetting {
    
}

- (IBAction)validateAction:(id)sender {
    if (_phoneField.text.length != 11) {
        [MBProgressHUD showError:@"手机号码长度不正确"];
    }else {
        if ([_validationField.text isEqualToString:@"666666"]) {
            [[NSUserDefaults standardUserDefaults]setObject:_phoneField.text forKey:@"PhoneNumber"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            InputPasswordVC * inputPasswordVC =[[InputPasswordVC alloc]init];
            [self.navigationController pushViewController:inputPasswordVC animated:YES];
        }else {
            [MBProgressHUD showError:@"验证码不正确"];
        }
    }
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
