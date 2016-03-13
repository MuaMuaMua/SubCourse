//
//  AccountSettingVC.m
//  SubCourse
//
//  Created by wuhaibin on 15/12/28.
//  Copyright © 2015年 wuhaibin. All rights reserved.
//

#import "AccountSettingVC.h"
#import "AccountSettingCell.h"
#import "UIImage+Blur.h"
#import "SubcourseManager.h"
#import "MBProgressHUD+MJ.h"
#import "MBProgressHUD.h"
#import "SubcourseManager.h"
#import "AppDelegate.h"
#import "CacheManager.h"

#define tablename @"SCBasicInfo"
#define paperTablename @"paperTable"
#define newPaperTablename @"newPaperTablename"
#define newQuestionTable @"questionTablename"
#define favouriteTabel @"favouriteTable"
#define newFavouriteListTable @"newFavouriteListTable"

@interface AccountSettingVC ()<UITableViewDataSource,UITableViewDelegate,AccountSettingCellDelegate,UITextFieldDelegate,SubcourseManagerDelegate,SubcourseManagerDelegate>{
    
    IBOutlet UIView *_headView;
    
    IBOutlet UIImageView *_avatarImageView;
    
    IBOutlet UITableView *_tableView;
    
    NSString * _nicknameSet;
    
    AppDelegate * _appDelegate;
    
    CacheManager * _cManager;
    /*
     * type:@“0”为手机号码 type:@“1” 为学号 type:@“2”为昵称 type:@"3"为邮箱
     */
    AccountSettingCell * _phoneSettingCell;
    
    AccountSettingCell * _studentNumberCell;
    
    AccountSettingCell * _nicknameCell;
    
    AccountSettingCell * _emailSettingCell;
    
    SubcourseManager * _scManager;
    
    NSString * _phoneNumber;
}

@end

@implementation AccountSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _phoneNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"signupPhone"];
    [self initSubcourseManager];
    [self setTableView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(registerError) name:@"registerError" object:nil];

    // Do any additional setup after loading the view from its nib.
}

- (void)registerError {
    [MBProgressHUD hideHUD];
    [MBProgressHUD showError:@"服务器崩溃"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setup subcourserManager 

- (void)initSubcourseManager {
    _scManager = [SubcourseManager sharedInstance];
    _scManager.delegate = self;
    _cManager = [CacheManager sharedInstance];
}

#pragma mark - tableView delegate && datasource  

- (void)setTableView {
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setTableViewHeadView];
}

- (void)setTableViewHeadView {
    CGRect winSize = [[UIScreen mainScreen]bounds];
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    UIImageView * iconView = [[UIImageView alloc]initWithFrame:CGRectMake(winSize.size.width/2 - 90, 10 , 180, 180)];
    iconView.image = [UIImage imageNamed:@"SubcourseIC"];
    UIImageView * iconBGView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    [headView addSubview:iconView];
    _tableView.tableHeaderView = headView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    int type = indexPath.row ;
    static NSString * certif = @"AccountSettingCell";
    UINib * nib = [UINib nibWithNibName:certif bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:certif];
    
    switch (indexPath.row) {
        case 0:
            _phoneSettingCell = [tableView dequeueReusableCellWithIdentifier:certif];
            if (_phoneSettingCell == nil) {
                _phoneSettingCell = [[AccountSettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:certif];
            }
//            NSString * phoneNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"PhoneNumber"];
            _phoneSettingCell.type = 0;
            _phoneSettingCell.delegate = self;
            _phoneSettingCell.nicknameField.text = _phoneNumber;
            _phoneSettingCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return _phoneSettingCell;
            break;
        case 1:
            _studentNumberCell = [tableView dequeueReusableCellWithIdentifier:certif];
            if (_studentNumberCell == nil) {
                _studentNumberCell = [[AccountSettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:certif];
            }
            _studentNumberCell.delegate = self;
            _studentNumberCell.type = 1;
            _studentNumberCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return _studentNumberCell;
            break;
        case 2:
            _nicknameCell = [tableView dequeueReusableCellWithIdentifier:certif];
            if (_nicknameCell == nil) {
                _nicknameCell = [[AccountSettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:certif];
            }
            _nicknameCell.delegate = self;
            _nicknameCell.type = 2;
            _nicknameCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return _nicknameCell;
            break;
        case 3:
            _emailSettingCell = [tableView dequeueReusableCellWithIdentifier:certif];
            if (_emailSettingCell == nil) {
                _emailSettingCell = [[AccountSettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:certif];
            }
            _emailSettingCell.delegate = self;
            _emailSettingCell.type = 3;
            _emailSettingCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return _emailSettingCell;
            break;

        default:
            break;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (IBAction)doneAction:(id)sender {
    NSString * password = [[NSUserDefaults standardUserDefaults]objectForKey:@"password"];
    if (_studentNumberCell.nicknameField.text == nil) {
        [MBProgressHUD showError:@"学号不能为空"];
    }else {
        if(_studentNumberCell.nicknameField.text == nil){
            [MBProgressHUD showError:@"昵称不能为空"];
        }else {
            [MBProgressHUD showMessage:@"正在注册"];
            NSString * code = [[NSUserDefaults standardUserDefaults]objectForKey:@"validateCode"];
            [_scManager registerAccount:_nicknameCell.nicknameField.text Password:password Code:code Phone:_phoneNumber StudentNo:_studentNumberCell.nicknameField.text];
        }
    }
}

- (void)registerAccountCallBack:(NSDictionary *)responseData {
    NSLog(@"%@",responseData);
    NSNumber * number = [responseData objectForKey:@"code"];
    if (number.intValue == 200) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:@"注册成功"];
        NSString * password = [[NSUserDefaults standardUserDefaults]objectForKey:@"password"];
        [self initSubcourseManager];
        [_scManager userLogin:_phoneNumber Password:password];
    }else {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"该号码已经注册"];
    }
}

- (void)userLoginCallBack:(NSDictionary *)responseData {
    NSNumber * code = [responseData objectForKey:@"code"];
    if (code.longValue == 200) {
        [_cManager.kvs clearTable:newFavouriteListTable];
        [_cManager.kvs clearTable:newPaperTablename];
        [_cManager.kvs clearTable:newQuestionTable];
        [_cManager.kvs clearTable:favouriteTabel];
        NSNumber * callBackCode = (NSNumber *)[responseData objectForKey:@"code"];
        if (callBackCode.intValue == 405) {
            [MBProgressHUD showError:@"手机号码或者密码出错"];
        }else {
            NSDictionary * userDictionary = [responseData objectForKey:@"user"];
//            NSString * phoneNumber = _studentField.text;
            [[NSUserDefaults standardUserDefaults] setObject:_phoneNumber forKey:@"loginPhoneNumber"];
            [[NSUserDefaults standardUserDefaults] setObject:responseData forKey:@"loginUserData"];
            [[NSUserDefaults standardUserDefaults] setObject:[userDictionary objectForKey:@"token"] forKey:@"token"];
            [[NSUserDefaults standardUserDefaults] setObject:[userDictionary objectForKey:@"id"] forKey:@"userId"];
            [[NSUserDefaults standardUserDefaults] setObject:[userDictionary objectForKey:@"studentNo"] forKey:@"studentNo"];
//            [[NSUserDefaults standardUserDefaults] setObject:_passwordField.text forKey:@"password"];
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
            _appDelegate = [[UIApplication sharedApplication]delegate];
            [_appDelegate startEntry];
        }
    }else {
        [MBProgressHUD showError:@"登陆失败"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)selectTextField:(int)textFieldType {
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


@end
