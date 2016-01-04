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
    _navigationItem.title = self.titleText;
    
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

//- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 20;
//}

- (IBAction)sendAction:(id)sender {
//    UpdatePersonalInfo * updatePersonalInfo = [[UpdatePersonalInfo alloc]init];
//    if (indexPath.row == 1 && indexPath.section == 0) {
//        //修改个人昵称.
//        updatePersonalInfo.type = @"0";
//    }else if(indexPath.row == 2 && indexPath.section == 0) {
//        //修改学号
//        updatePersonalInfo.type = @"1";
//    }else if(indexPath.section == 1){
//        if(indexPath.row == 0) {
//            //修改学校信息
//            updatePersonalInfo.type = @"2";
//        }else if(indexPath.row == 1) {
//            //修改班级信息
//            updatePersonalInfo.type = @"3";
//        }
//    }else if(indexPath.section == 2){
//        if(indexPath.row == 0) {
//            //修改真实姓名
//            updatePersonalInfo.type = @"4";
//        }else if(indexPath.row == 1) {
//            //修改证件号码
//            updatePersonalInfo.type = @"5";
//        }else if(indexPath.row == 2) {
//            //修改联系电话
//            updatePersonalInfo.type = @"6";
//        }else if(indexPath.row == 3) {
//            //修改邮箱地址
//            updatePersonalInfo.type = @"7";
//        }else if(indexPath.row == 4) {
//            //修改家庭住址
//            updatePersonalInfo.type = @"8";
//        }
//    }
//    {avatar,school,major,clazz,realName,idCard,phone,email,address} TOKEN , userId
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
//    else if([self.type isEqualToString:@"6"]) {
//        //修改联系方式
//        [userDictionary setObject:_cell.updateTextField.text forKey:@"nickName"];
//    }
    
    else if(self.type == 7) {
        //修改邮箱地址
        [userDictionary setObject:_cell.updateTextField.text forKey:@"email"];
    }else if(self.type == 8) {
        //修改家庭住址
        [userDictionary setObject:_cell.updateTextField.text forKey:@"nickName"];
    }
    
    [_scManager updateUserInfo:userDictionary];
    
//    _scManager updateUserInfo:
    
    
}

- (void)updateUserInfoCallBack:(NSDictionary *)responseData {
    NSLog(@"%@",responseData);
    //先封装好 个人信息 再上传 上传成功回调  再dismiss
    
    NSNumber * code = [responseData objectForKey:@"code"];
    if (code.intValue == 200) {
        switch (self.type) {
            case 0:
                [[NSUserDefaults standardUserDefaults] setObject:_cell.updateTextField.text forKey:@"nickname"];
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
    
    
//    if(self.type == 0) {
//        //修改个人昵称
//        [[NSUserDefaults standardUserDefaults] setObject:_cell.updateTextField.text forKey:@"nickname"];
//    }else if(self.type == 1) {
//        //修改个人学号
//        [[NSUserDefaults standardUserDefaults] setObject:_cell.updateTextField.text forKey:@"studentNo"];
//    }else if(self.type == 2) {
//        //修改个人学校
//        [[NSUserDefaults standardUserDefaults] setObject:_cell.updateTextField.text forKey:@"school"];
//    }else if(self.type == 3) {
//        //修改个人班级
//        [[NSUserDefaults standardUserDefaults] setObject:_cell.updateTextField.text forKey:@"clazz"];
//    }else if(self.type == 4) {
//        //修改个人真实姓名
//        [[NSUserDefaults standardUserDefaults] setObject:_cell.updateTextField.text forKey:@"realName"];
//    }else if(self.type == 5) {
//        //修改个人idcard
//        [[NSUserDefaults standardUserDefaults] setObject:_cell.updateTextField.text forKey:@"idCard"];
//    }else if(self.type == 7) {
//        //修改邮箱地址
//        [[NSUserDefaults standardUserDefaults] setObject:_cell.updateTextField.text forKey:@"email"];
//    }else if(self.type == 8) {
//        //修改家庭住址
//        [[NSUserDefaults standardUserDefaults] setObject:_cell.updateTextField.text forKey:@"address"];
//    }

}

- (void)enableSendBtn:(BOOL)enable {
    if (enable) {
        _rightBtn.enabled = YES;
    }else {
        _rightBtn.enabled = NO;
    }
}
@end
