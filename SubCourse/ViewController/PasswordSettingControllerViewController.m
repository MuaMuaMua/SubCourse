//
//  PasswordSettingControllerViewController.m
//  SubCourse
//
//  Created by wuhaibin on 15/11/29.
//  Copyright © 2015年 wuhaibin. All rights reserved.
//

#import "PasswordSettingControllerViewController.h"
#import "PersonalCell.h"
#import "SCTitleMenu.h"
#import "ExerciseViewController.h"
#import "QRCodeViewController.h"
#import "MBProgressHUD+MJ.h"
#import "MBProgressHUD.h"
#import "SubcourseManager.h"
#import "AppDelegate.h"
#import "YTKKeyValueStore.h"
#import "CacheManager.h"
#import "CLLASSTextField.h"

#define newPaperTablename @"newPaperTablename"
#define newQuestionTable @"questionTablename"
#define favouriteTabel @"favouriteTable"
#define newFavouriteListTable @"newFavouriteListTable"

@interface PasswordSettingControllerViewController ()<SubcourseManagerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>{
    
    IBOutlet UILabel *_nicknameLabel;
    
    IBOutlet CLLASSTextField *_originalPasswordField;
    
    IBOutlet CLLASSTextField *_newPasswordField;
    
    IBOutlet CLLASSTextField *_newPasswordComfirmField;
    
    SubcourseManager * _scManager;
    
    AppDelegate * _appDelegate;
    
    UIImagePickerController * _picker;
    
    YTKKeyValueStore * _kvs;
    
    CacheManager * _cManager;
    
    
}

@property (strong, nonatomic) SCTitleMenu * titleMenu;

@end

@implementation PasswordSettingControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self subcourseManagerSetting];
//    [self setLeftViewForTextField];
    //去掉扫码部分的icon
//    [self.rightBtn.customView setHidden:YES];
//    [self.rightBtn setEnabled:NO];
    //初始化 titleBtn
    UIButton * titleBtn = [[UIButton alloc] init];
    [titleBtn setTitle:@"密码设置" forState:UIControlStateNormal];
    titleBtn.backgroundColor = [UIColor blueColor];
    [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [titleBtn setImage:[UIImage imageNamed:@"dd"] forState:UIControlStateNormal];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.titleView = titleBtn;
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"nickName"]!=nil) {
        _nicknameLabel.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"nickName"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)alreadyLoginSetting {
    
}

#pragma mark - setTextFieldsLeftViews

- (void)setLeftViewForTextField {
//    UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 50)];
//    _originalPasswordField.leftViewMode = UITextFieldViewModeAlways;
//    _newPasswordComfirmField.leftViewMode = UITextFieldViewModeAlways;
//    _newPasswordField.leftViewMode = UITextFieldViewModeAlways;
//    _originalPasswordField.leftViewMode = UITextFieldViewModeAlways;
//    _originalPasswordField.leftView = leftView;
//    _newPasswordField.leftView = leftView;
//    _newPasswordComfirmField.leftView = leftView;
}

#pragma mark - subcourse delegate && settings 

- (void)subcourseManagerSetting {
    _scManager = [SubcourseManager sharedInstance];
    _scManager.delegate = self;
    _cManager = [CacheManager sharedInstance];
}

- (void)userLogoutCallBack:(NSDictionary *)responseData {
    [self subcourseManagerSetting];
    [_cManager.kvs clearTable:newFavouriteListTable];
    [_cManager.kvs clearTable:newPaperTablename];
    [_cManager.kvs clearTable:newQuestionTable];
    [_cManager.kvs clearTable:favouriteTabel];
    NSLog(@"%@",responseData);
    [MBProgressHUD showSuccess:@"注销成功"];
    NSString*appDomain = [[NSBundle mainBundle]bundleIdentifier];
    [[NSUserDefaults standardUserDefaults]removePersistentDomainForName:appDomain];
    _appDelegate = [[UIApplication sharedApplication]delegate];
    [_appDelegate showLoginView];
}

- (void)changePassowrdCallBack:(NSDictionary *)responseData {
    
    NSLog(@"旧密码");
    NSNumber * code = [responseData objectForKey:@"code"];
    if (code.intValue == 200) {
        [MBProgressHUD showSuccess:@"成功修改密码"];
        [[NSUserDefaults standardUserDefaults]setObject:_newPasswordComfirmField.text forKey:@"password"];
        
        [_originalPasswordField setText:@""];
        [_newPasswordField setText:@""];
        [_newPasswordComfirmField setText:@""];
        
    }
}

#pragma mark - resetPassword

- (IBAction)resetPasswordAction:(id)sender {
    [MBProgressHUD showMessage:@"修改ING"];
    NSString * originalPassword = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    if (![_originalPasswordField.text isEqualToString:originalPassword]) {
        [MBProgressHUD showError:@"密码错误"];
    }else {
        if (_newPasswordField.text.length < 6 || _newPasswordField.text.length > 12) {
            [MBProgressHUD showError:@"密码长度为6-12位"];
        }else {
            if (![_newPasswordComfirmField.text isEqualToString:_newPasswordField.text]) {
                [MBProgressHUD showError:@"两次输入的密码不一致"];
            }else {
                [_scManager changePassword:_originalPasswordField.text NewPassword:_newPasswordField.text];
            }
        }
    }
}



- (IBAction)logoutAction:(id)sender {
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"确定注销？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.delegate = self;
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSLog(@"取消");
    }else if (buttonIndex == 1){

        [_scManager userLogout];
    }
}
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//    UIAlertView *alertView;
//    switch (buttonIndex) {
//        case 0:
//            _picker = [[UIImagePickerController alloc]init];
//            _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//            _picker.delegate = self;
//            _picker.allowsEditing = YES;
//            [self presentViewController:_picker animated:YES completion:nil];
//            break;
//        case 1:
//            _picker = [[UIImagePickerController alloc]init];
//            _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//            _picker.delegate = self;
//            _picker.allowsEditing = YES;
//            [self presentViewController:_picker animated:YES completion:nil];
////            _picker 
//            break;
//            
//        default:
//            break;
//    }
//}

@end
