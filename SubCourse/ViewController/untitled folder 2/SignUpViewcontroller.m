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

@interface SignUpViewcontroller ()<SubcourseManagerDelegate,MBProgressHUDDelegate,UITextFieldDelegate>{
    
    IBOutlet UITextField *_phoneField;
    
    IBOutlet UITextField *_validationField;
    
    IBOutlet UIButton *_validateBtn;
    
    IBOutlet UIButton *_backBtn;
    
    SubcourseManager * _scManager;
    
    CacheManager * _cManager;
    
    NSTimer * _timer;// 验证码计时器
    
    int _second; // 计时器 60 秒
    
    IBOutlet UIButton * _sendVerificationCodeBtn;
}

@end

@implementation SignUpViewcontroller

- (void)viewDidLoad {
    [super viewDidLoad];
//    _phoneField.
    _second = 60;
    _phoneField.keyboardType = UIKeyboardTypeNumberPad;
    _validationField.keyboardType = UIKeyboardTypeNumberPad;
    self.navigationController.navigationBar.hidden = YES;
//    _sendVerificationCodeBtn = [[UIButton alloc]init];
//    _sendVerificationCodeBtn .backgroundColor = [UIColor grayColor];
    [_sendVerificationCodeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_sendVerificationCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];

    [_phoneField addSubview:_sendVerificationCodeBtn];
//    _phoneField.rightView = _sendVerificationCodeBtn;
//    _phoneField.rightViewMode = UITextFieldViewModeAlways;

    [_sendVerificationCodeBtn addTarget:self action:@selector(initTimer) forControlEvents:UIControlEventTouchUpInside];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(valideSuccess) name:@"validateSuccess" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(valideFail) name:@"validateFail" object:nil];
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideSoftKeyboard)];
    tapGesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)hideSoftKeyboard{
    NSLog(@"点击输入框外部UIView（其实已经变成拉UIController），软键盘隐藏");
    [self.view endEditing:YES];
}

#pragma mark - 初始化  计时器

- (void)initTimer {
    _scManager = [SubcourseManager sharedInstance];
    if (_phoneField.text.length  != 11) {
        [MBProgressHUD showError:@"密码长度不正确"];
    }else {
        _phoneField.enabled = NO;
//        [_scManager isPhoneExist:_phoneField.text];
//        [self scManagerAndcManagerSetting];
        [_scManager sendVerificationCode:_phoneField.text];
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timePast) userInfo:nil repeats:YES];
        [_timer fire];
    }
}

- (void)valideSuccess {
//    [_scManager sendVerificationCode:_phoneField.text];
//    _phoneField.enabled = YES;
    [[NSUserDefaults standardUserDefaults] setObject:_validationField.text forKey:@"validateCode"];
    [[NSUserDefaults standardUserDefaults] setObject:_phoneField.text forKey:@"signupPhone"];
    InputPasswordVC * ipvc = [[InputPasswordVC alloc]init];
    
    [self.navigationController pushViewController:ipvc animated:YES];
}

- (void)valideFail {
    [MBProgressHUD showError:@"验证失败"];
    _phoneField.enabled = YES;
}

- (void)timePast {
    NSString * secondString = [NSString stringWithFormat:@"%d S",_second];
    _second -- ;
    [_sendVerificationCodeBtn setEnabled:NO];
    [_sendVerificationCodeBtn setTitle:secondString forState:UIControlStateNormal];
    if (_second == 0) {
        [_timer invalidate];
        [_sendVerificationCodeBtn setEnabled:YES];
        [_sendVerificationCodeBtn setTitle:@"重新发送验证码" forState:UIControlStateNormal];
        [_sendVerificationCodeBtn addTarget:self action:@selector(initTimer) forControlEvents:UIControlEventTouchUpInside];
    }
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
        if (_validationField.text.length != 6) {
            [MBProgressHUD showError:@"验证码长度不正确"];
        }else {
//            [MBProgressHUD showMessage:@""];
            [_scManager checkVerificationCode:_phoneField.text verifictionCode:_validationField.text];
        }
    }
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

//-(IBAction)textFiledReturnEditing:(id)sender {
//    [sender resignFirstResponder];
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
