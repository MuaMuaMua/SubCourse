//
//  LoginViewcontroller.m
//  SubCourse
//
//  Created by wuhaibin on 15/12/28.
//  Copyright © 2015年 wuhaibin. All rights reserved.
//

#import "LoginViewcontroller.h"
#import "SubcourseManager.h"
#import "CacheManager.h"
#import "AppDelegate.h"
#import "MBProgressHUD+MJ.h"
#import "MBProgressHUD.h"
#import "SignUpViewcontroller.h"

#define tablename @"SCBasicInfo"
#define paperTablename @"paperTable"

#define newPaperTablename @"newPaperTablename"
#define newQuestionTable @"questionTablename"
#define favouriteTabel @"favouriteTable"
#define newFavouriteListTable @"newFavouriteListTable"
//_instance.kvs = [[YTKKeyValueStore alloc]initDBWithName:@"SubCourse"];

@interface LoginViewcontroller ()<UITextFieldDelegate,SubcourseManagerDelegate>{
    
    IBOutlet UITextField *_studentField;
    
    IBOutlet UITextField *_passwordField;
    
    IBOutlet UIButton *_signinBtn;
    
    IBOutlet UIButton *_signupBtn;
    
    IBOutlet UIButton *_forgetBtn;
    
    AppDelegate * _appdelegate;
    
    MBProgressHUD * _hud;
    
    SubcourseManager * _scManager;
    
    CacheManager * _cManager;

}

@end

@implementation LoginViewcontroller

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self managerSettings];
//    _signupBtn.hidden = YES;
    _forgetBtn.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - subcourseManager && cacheManager delegate && settings 

- (void)viewWillAppear:(BOOL)animated {
    [self managerSettings];
}

- (void)managerSettings {
    _scManager = [SubcourseManager sharedInstance];
    _cManager = [CacheManager sharedInstance];
    _scManager.delegate = self;
}

- (void)userLoginCallBack:(NSDictionary *)responseData {
    [self managerSettings];
    [_cManager.kvs clearTable:newFavouriteListTable];
    [_cManager.kvs clearTable:newPaperTablename];
    [_cManager.kvs clearTable:newQuestionTable];
    [_cManager.kvs clearTable:favouriteTabel];
    NSNumber * callBackCode = (NSNumber *)[responseData objectForKey:@"code"];
    if (callBackCode.intValue == 405) {
        [MBProgressHUD showError:@"手机号码或者密码出错"];
    }else {
        NSDictionary * userDictionary = [responseData objectForKey:@"user"];
        NSString * phoneNumber = _studentField.text;
        [[NSUserDefaults standardUserDefaults] setObject:phoneNumber forKey:@"loginPhoneNumber"];
        [[NSUserDefaults standardUserDefaults] setObject:responseData forKey:@"loginUserData"];
        [[NSUserDefaults standardUserDefaults] setObject:[userDictionary objectForKey:@"token"] forKey:@"token"];
        [[NSUserDefaults standardUserDefaults] setObject:[userDictionary objectForKey:@"id"] forKey:@"userId"];
        [[NSUserDefaults standardUserDefaults] setObject:[userDictionary objectForKey:@"studentNo"] forKey:@"studentNo"];
        [[NSUserDefaults standardUserDefaults] setObject:_passwordField.text forKey:@"password"];
        [[NSUserDefaults standardUserDefaults] setObject:[userDictionary objectForKey:@"nickName"] forKey:@"nickName"];
        [[NSUserDefaults standardUserDefaults] setObject:[userDictionary objectForKey:@"school"] forKey:@"school"];
        [[NSUserDefaults standardUserDefaults] setObject:[userDictionary objectForKey:@"email"] forKey:@"email"];
        [[NSUserDefaults standardUserDefaults] setObject:[userDictionary objectForKey:@"phone"] forKey:@"phone"];
        [[NSUserDefaults standardUserDefaults] setObject:[userDictionary objectForKey:@"major"] forKey:@"major"];
        [[NSUserDefaults standardUserDefaults] setObject:[userDictionary objectForKey:@"idCard"] forKey:@"idCard"];
        [[NSUserDefaults standardUserDefaults] setObject:[userDictionary objectForKey:@"realName"] forKey:@"realName"];
        [[NSUserDefaults standardUserDefaults] setObject:[userDictionary objectForKey:@"school"] forKey:@"school"];
        [[NSUserDefaults standardUserDefaults] setObject:[userDictionary objectForKey:@"address"] forKey:@"address"];
        [[NSUserDefaults standardUserDefaults] setObject:[userDictionary objectForKey:@"clazz"] forKey:@"clazz"];
        [[NSUserDefaults standardUserDefaults] setObject:[userDictionary objectForKey:@"avatar"] forKey:@"avatar"];
        
        NSString * nickName = [[NSUserDefaults standardUserDefaults]objectForKey:@"nickName"];
        
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:@"登陆成功!"];
        _appdelegate = [[UIApplication sharedApplication]delegate];
        [_appdelegate startEntry];
    }
}

#pragma mark - textField delegate

- (void)initTextFields {
    _studentField.delegate = self;
    _passwordField.delegate = self;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}

- (IBAction)signinAction:(id)sender {
    if (_studentField.text.length == 0) {
        [MBProgressHUD showError:@"手机号码不能为空"];
    }
    if (_studentField.text.length != 11) {
        [MBProgressHUD showError:@"手机号码长度格式不正确"];
    }else {
        if (_passwordField.text.length < 6 || _passwordField.text.length > 12) {
            [MBProgressHUD showError:@"密码长度为6-12位"];
        }else {
            [MBProgressHUD showMessage:@"登陆ing"];
            NSLog(@"%@",_studentField.text);
            NSLog(@"%@",_passwordField.text);
            [_scManager userLogin:_studentField.text Password:_passwordField.text];
        }
    }
}
- (IBAction)signupAction:(id)sender {
    SignUpViewcontroller * signupVC = [[SignUpViewcontroller alloc]init];
    //跳转到注册页面
    [self.navigationController pushViewController:signupVC animated:YES];
}

- (IBAction)forgetAction:(id)sender {
//    _appdelegate = [[UIApplication sharedApplication]delegate];
//    [_appdelegate startEntry];
}


@end
