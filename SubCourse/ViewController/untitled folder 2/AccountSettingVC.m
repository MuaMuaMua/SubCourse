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


@interface AccountSettingVC ()<UITableViewDataSource,UITableViewDelegate,AccountSettingCellDelegate,UITextFieldDelegate,SubcourseManagerDelegate,SubcourseManagerDelegate>{
    
    IBOutlet UIView *_headView;
    
    IBOutlet UIImageView *_avatarImageView;
    
    IBOutlet UITableView *_tableView;
    
    NSString * _nicknameSet;
    
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
    _phoneNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"PhoneNumber"];
    [self initSubcourseManager];
    [self setTableView];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setup subcourserManager 

- (void)initSubcourseManager {
    _scManager = [SubcourseManager sharedInstance];
    _scManager.delegate = self;
}


#pragma mark - tableView delegate && datasource  

- (void)setTableView {
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setTableViewHeadView];
}

- (void)setTableViewHeadView {
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    UIImageView * iconView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 90, 10 , 180, 180)];
    iconView.image = [UIImage imageNamed:@"SubCourseIcon"];
    UIImageView * iconBGView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
//    iconView.image = [UIImage addBlur:8.0f Image:[UIImage imageNamed:@"SubCourseIcon"]];
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
            [_scManager registerAccount:_nicknameCell.nicknameField.text Password:password Code:@"666666" Phone:_phoneNumber StudentNo:_studentNumberCell.nicknameField.text];
        }
    }
}

- (void)registerAccountCallBack:(NSDictionary *)responseData {
    NSLog(@"%@",responseData);
    NSNumber * number = [responseData objectForKey:@"code"];
    if (number.intValue == 200) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:@"注册成功"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"注册失败"];
    }
}

- (void)selectTextField:(int)textFieldType {
    
}


@end
