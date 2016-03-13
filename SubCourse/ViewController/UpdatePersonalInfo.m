//
//  UpdatePersonalInfo.m
//  SubCourse
//
//  Created by wuhaibin on 15/12/31.
//  Copyright © 2015年 wuhaibin. All rights reserved.
//

#import "UpdatePersonalInfo.h"
#import "UpdateInfoCell.h"
#import "MBProgressHUD+MJ.h"
#import "MBProgressHUD.h"
#import "SubcourseManager.h"

@interface UpdatePersonalInfo ()<UITableViewDataSource,UITableViewDelegate,SubcourseManagerDelegate,UpdateInfoCellDelegate>{
    
    IBOutlet UINavigationBar *_navigationBar;
    
    IBOutlet UINavigationItem *_navigationItem;
    
    IBOutlet UIBarButtonItem *_leftBtn;
    
    IBOutlet UITableView *_tableView;
    
    IBOutlet UIBarButtonItem *_rightBtn;
    
    UpdateInfoCell * _cell;
    
    SubcourseManager * _scManager;
    
}

@end

@implementation UpdatePersonalInfo

- (void)viewDidLoad {
    [super viewDidLoad];
    [self scManagerSetting];
    [self setTableView];
    _rightBtn.enabled = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
//    _navigationItem.title = self.titleText;
    switch (self.type) {
        case 0:
            _navigationItem.title = @"昵称";
            break;
        case 1:
            _navigationItem.title = @"学号";
            break;
        case 2:
            _navigationItem.title = @"学校";
            break;
        case 3:
            _navigationItem.title = @"班级";
            break;
        case 4:
            _navigationItem.title = @"真实姓名";
            break;
        case 5:
            _navigationItem.title = @"证件号码";
            break;
        case 7:
            _navigationItem.title = @"e-mail";
            break;
        case 8:
            _navigationItem.title = @"地址";
            break;
        default:
            break;
    }
}

- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - subcourse Delegate && setting 

- (void)scManagerSetting {
    _scManager = [SubcourseManager sharedInstance];
    _scManager.delegate = self;
}

#pragma mark - tableView delegate && datasource 

- (void)setTableView {
//    _cell = [[UpdateInfoCell alloc]init];
//    _cell.originalContent = self.titleText;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithRed:240.0/255 green:239.0/255 blue:245.0/255 alpha:1];
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 20)];
    headView.backgroundColor = [UIColor colorWithRed:240.0/255 green:239.0/255 blue:245.0/255 alpha:1];
    _tableView.tableHeaderView = headView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * certif = @"updateInfoCell";
    UINib * nib = [UINib nibWithNibName:@"UpdateInfoCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:certif];
    _cell = [tableView dequeueReusableCellWithIdentifier:certif];
    if (_cell == nil) {
        _cell = [[UpdateInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:certif];
    }
    _cell.delegate = self;
    _cell.updateTextField.text = self.titleText;
    _cell.originalContent = self.titleText;
    return _cell;
}

- (IBAction)sendAction:(id)sender {

    NSMutableDictionary * userDictionary = [[NSMutableDictionary alloc]init];
    NSString * token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSString * userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSString * nickName = [[NSUserDefaults standardUserDefaults] objectForKey:@"nickName"];
    NSString * studentNo = [[NSUserDefaults standardUserDefaults] objectForKey:@"studentNo"];
    NSString * avatar = [[NSUserDefaults standardUserDefaults] objectForKey:@"avatar"];
    NSString * school = [[NSUserDefaults standardUserDefaults] objectForKey:@"school"];
    NSString * major = [[NSUserDefaults standardUserDefaults] objectForKey:@"major"];
    NSString * clazz = [[NSUserDefaults standardUserDefaults] objectForKey:@"clazz"];
    NSString * realName = [[NSUserDefaults standardUserDefaults] objectForKey:@"realName"];
    NSString * idCard = [[NSUserDefaults standardUserDefaults] objectForKey:@"idCard"];
    NSString * phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"];
    NSString * email = [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
    NSString * address = [[NSUserDefaults standardUserDefaults] objectForKey:@"address"];
    
    [userDictionary setObject:token forKey:@"token"];
    [userDictionary setObject:userId forKey:@"userId"];
    
    if (nickName == nil) {
        [userDictionary setObject:@"" forKey:@"nickName"];
    }else {
        [userDictionary setObject:nickName forKey:@"nickName"];
    }
    
    if (studentNo == nil) {
        [userDictionary setObject:@"" forKey:@"studentNo"];
    }else {
        [userDictionary setObject:studentNo forKey:@"studentNo"];

    }
    
    if (avatar == nil) {
        [userDictionary setObject:@"" forKey:@"avatar"];
    }else {
        [userDictionary setObject:avatar forKey:@"avatar"];
    }
    
    if (school == nil) {
        [userDictionary setObject:@"" forKey:@"school"];
    }else {
        [userDictionary setObject:school forKey:@"school"];
    }
    
    if (major == nil) {
        [userDictionary setObject:@"" forKey:@"major"];
    }else {
        [userDictionary setObject:major forKey:@"major"];
    }
    
    if (clazz == nil) {
        [userDictionary setObject:@"" forKey:@"clazz"];
    }else {
        [userDictionary setObject:clazz forKey:@"clazz"];
    }
    
    if (realName == nil) {
        [userDictionary setObject:@"" forKey:@"realName"];
    }else {
        [userDictionary setObject:realName forKey:@"realName"];
    }
    
    if (idCard == nil) {
        [userDictionary setObject:@"" forKey:@"idCard"];
    }else {
        [userDictionary setObject:idCard forKey:@"idCard"];
    }
    
    if (email == nil) {
        [userDictionary setObject:@"" forKey:@"email"];
    }else {
        [userDictionary setObject:email forKey:@"email"];
    }
    
    if (address == nil) {
        [userDictionary setObject:@"" forKey:@"address"];
    }else {
        [userDictionary setObject:address forKey:@"address"];
    }
    
    //先封装好 个人信息 再上传 上传成功回调  再dismiss
    if(self.type == 0) {
        //修改个人昵称
        [userDictionary setObject:_cell.updateTextField.text forKey:@"nickName"];
    }else if(self.type == 1) {
        //修改个人学号
        [userDictionary setObject:_cell.updateTextField.text forKey:@"studentNo"];
    }else if(self.type == 2) {
        //修改个人学校
        [userDictionary setObject:_cell.updateTextField.text forKey:@"school"];
    }else if(self.type == 3) {
        //修改个人班级
        [userDictionary setObject:_cell.updateTextField.text forKey:@"clazz"];
    }else if(self.type == 4) {
        //修改个人真实姓名
        [userDictionary setObject:_cell.updateTextField.text forKey:@"realName"];
    }else if(self.type == 5) {
        //修改个人idcard
        [userDictionary setObject:_cell.updateTextField.text forKey:@"idCard"];
    }
    
    else if(self.type == 7) {
        //修改邮箱地址
        [userDictionary setObject:_cell.updateTextField.text forKey:@"email"];
    }else if(self.type == 8) {
        //修改家庭住址
        [userDictionary setObject:_cell.updateTextField.text forKey:@"nickName"];
    }
    
    [_scManager updateUserInfo:userDictionary];
    
}

- (void)updateUserInfoCallBack:(NSDictionary *)responseData {
    NSLog(@"%@",responseData);
    //先封装好 个人信息 再上传 上传成功回调  再dismiss
    
    NSNumber * code = [responseData objectForKey:@"code"];
    if (code.intValue == 200) {
        switch (self.type) {
            case 0:
                [[NSUserDefaults standardUserDefaults] setObject:_cell.updateTextField.text forKey:@"nickName"];
                break;
            case 1:
                [[NSUserDefaults standardUserDefaults] setObject:_cell.updateTextField.text forKey:@"studentNo"];
                break;
            case 2:
                [[NSUserDefaults standardUserDefaults] setObject:_cell.updateTextField.text forKey:@"school"];
                break;
            case 3:
                [[NSUserDefaults standardUserDefaults] setObject:_cell.updateTextField.text forKey:@"clazz"];
                break;
            case 4:
                [[NSUserDefaults standardUserDefaults] setObject:_cell.updateTextField.text forKey:@"realName"];
                break;
            case 5:
                [[NSUserDefaults standardUserDefaults] setObject:_cell.updateTextField.text forKey:@"idCard"];
                break;
            case 7:
                [[NSUserDefaults standardUserDefaults] setObject:_cell.updateTextField.text forKey:@"email"];
                break;
            case 8:
                [[NSUserDefaults standardUserDefaults] setObject:_cell.updateTextField.text forKey:@"address"];
                break;
            default:
                break;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshInfo" object:nil];
        
        [MBProgressHUD showSuccess:@"修改成功"];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }else {
        [MBProgressHUD showError:@"网络故障，请求失败"];
    }
    
}

- (void)enableSendBtn:(BOOL)enable {
    if (enable) {
        _rightBtn.enabled = YES;
    }else {
        _rightBtn.enabled = NO;
    }
}

@end
