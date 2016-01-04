//
//  SafetySettingController.m
//  SubCourse
//
//  Created by wuhaibin on 15/11/27.
//  Copyright © 2015年 wuhaibin. All rights reserved.
//

#import "SafetySettingController.h"
#import "UpdatePersonalInfo.h"
#import "PersonalAvatarCell.h"
#import "PersonalCell.h"
#import "InfoCell.h"
#import "MBProgressHUD+MJ.h"
#import "MBProgressHUD.h"

@interface SafetySettingController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate> {
    UIImagePickerController * _picker;
    UIImage * _pickImage;
    
//    InfoCell * _nicknameCell; //1
//    InfoCell * _studentNoCell;
//    InfoCell * _schoolCell;
//    InfoCell * _clazzCell;
//    InfoCell * _realNameCell;
//    InfoCell * _idCardCell;
//    InfoCell * _phoneCell;
//    InfoCell * _emailCell;
//    InfoCell * _addressCell;
    
    NSString * _nickname;
    NSString * _studentNo;
    NSString * _school;
    NSString * _clazz;
    NSString * _realName;
    NSString * _idCard;
    NSString * _phone;
    NSString * _email;
    NSString * _address;
    
    
}

@end

@implementation SafetySettingController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self initTitleArray];
    self.view.backgroundColor = [UIColor greenColor];
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.title = @"我的资料";
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshIcon) name:@"RefreshIcon" object:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self initCellInfo];
    [self initTableView];
}

- (void)initTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.title = @"我的资料";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshIcon) name:@"RefreshIcon" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshInfo) name:@"RefreshInfo" object:nil];
}

- (void)refreshInfo {
    [self initCellInfo];
    [self.tableView reloadData];
}

- (void)initCellInfo {
    _nickname = [[NSUserDefaults standardUserDefaults] objectForKey:@"nickName"];
    _studentNo = [[NSUserDefaults standardUserDefaults] objectForKey:@"studentNo"];
    _school = [[NSUserDefaults standardUserDefaults] objectForKey:@"school"];
    _clazz = [[NSUserDefaults standardUserDefaults] objectForKey:@"clazz"];
    _realName = [[NSUserDefaults standardUserDefaults] objectForKey:@"realName"];
    _idCard = [[NSUserDefaults standardUserDefaults] objectForKey:@"idCard"];
    _phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"];
    _email = [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
    _address = [[NSUserDefaults standardUserDefaults] objectForKey:@"address"];
//    _realName = [NSUserDefaults st]
}

- (void)initTitleArray {
    
    NSString * title1 = @"头像";
    NSString * title2 = @"昵称";
    NSString * title3 = @"学号";
    NSMutableArray * array1 = [[NSMutableArray alloc]initWithObjects:title1,title2,title3, nil];
    
    NSString * title4 = @"学校";
    NSString * title5 = @"班级";
    
    NSMutableArray * array2 = [[NSMutableArray alloc]initWithObjects:title4,title5, nil];
    
    NSString * title6 = @"真实姓名";
    NSString * title7 = @"证件号码";
    NSMutableArray * array3 = [[NSMutableArray alloc]initWithObjects:title6,title7, nil];

    self.titleArray = [[NSMutableArray alloc]initWithObjects:array1,array2,array3, nil];
    
    
//    NSString * nicknameString = [[NSUserDefaults standardUserDefaults] objectForKey:@"nickname"];
//    NSString * studentNo = [[NSUserDefaults standardUserDefaults] objectForKey:@"studentNo"];
//    NSString * school = [[NSUserDefaults standardUserDefaults] objectForKey:@"school"];
//    NSString * clazz = [[NSUserDefaults standardUserDefaults] objectForKey:@"clazz"];
//    NSString *
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 && indexPath.section == 0) {
        UIActionSheet *myActionSheet;
        myActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册", @"拍照", nil];
        [myActionSheet showInView:self.view];
    }else {
        UpdatePersonalInfo * updatePersonalInfo = [[UpdatePersonalInfo alloc]init];
        if (indexPath.row == 1 && indexPath.section == 0) {
            //修改个人昵称.
            updatePersonalInfo.type = 0;
            NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"nickName"]);
            if ([[NSUserDefaults standardUserDefaults]objectForKey:@"nickName"]!=nil) {
                updatePersonalInfo.titleText = [[NSUserDefaults standardUserDefaults]objectForKey:@"nickName"];
            }else {
            }
            [self presentViewController:updatePersonalInfo animated:YES completion:nil];
        }else if(indexPath.row == 2 && indexPath.section == 0) {
            //修改学号
            updatePersonalInfo.type = 1;
            if ([[NSUserDefaults standardUserDefaults]objectForKey:@"studentNo"]!= nil) {
                updatePersonalInfo.titleText = [[NSUserDefaults standardUserDefaults]objectForKey:@"studentNo"];
            }
            [self presentViewController:updatePersonalInfo animated:YES completion:nil];
        }else if(indexPath.section == 1){
            if(indexPath.row == 0) {
                //修改学校信息
                updatePersonalInfo.type = 2;
                if ([[NSUserDefaults standardUserDefaults]objectForKey:@"school"]!= nil) {
                    updatePersonalInfo.titleText = [[NSUserDefaults standardUserDefaults]objectForKey:@"school"];
                }
                [self presentViewController:updatePersonalInfo animated:YES completion:nil];
            }else if(indexPath.row == 1) {
                //修改班级信息
                updatePersonalInfo.type = 3;
                if ([[NSUserDefaults standardUserDefaults]objectForKey:@"clazz"]!=nil) {
                    updatePersonalInfo.titleText = [[NSUserDefaults standardUserDefaults]objectForKey:@"clazz"];
                }
                [self presentViewController:updatePersonalInfo animated:YES completion:nil];
            }
        }else if(indexPath.section == 2){
            if(indexPath.row == 0) {
                //修改真实姓名
                updatePersonalInfo.type = 4;
                if ([[NSUserDefaults standardUserDefaults]objectForKey:@"realName"]!=nil) {
                    updatePersonalInfo.titleText = [[NSUserDefaults standardUserDefaults]objectForKey:@"realName"];
                }
                [self presentViewController:updatePersonalInfo animated:YES completion:nil];
            }else if(indexPath.row == 1) {
                //修改证件号码
                updatePersonalInfo.type = 5;
                if ([[NSUserDefaults standardUserDefaults]objectForKey:@"idCard"]!= nil) {
                    updatePersonalInfo.titleText = [[NSUserDefaults standardUserDefaults]objectForKey:@"idCard"];
                }
                [self presentViewController:updatePersonalInfo animated:YES completion:nil];
            }else if(indexPath.row == 2) {
                //修改联系电话
                [MBProgressHUD showError:@"手机号码不可修改!"];
                return;
            }else if(indexPath.row == 3) {
                //修改邮箱地址
                updatePersonalInfo.type = 7;
                if ([[NSUserDefaults standardUserDefaults]objectForKey:@"email"]!=nil) {
                    updatePersonalInfo.titleText = [[NSUserDefaults standardUserDefaults]objectForKey:@"email"];
                }
                [self presentViewController:updatePersonalInfo animated:YES completion:nil];
            }else if(indexPath.row == 4) {
                //修改家庭住址
                updatePersonalInfo.type = 8;
                if ([[NSUserDefaults standardUserDefaults]objectForKey:@"address"]!=nil) {
                    updatePersonalInfo.titleText = [[NSUserDefaults standardUserDefaults]objectForKey:@"address"];
                }
                [self presentViewController:updatePersonalInfo animated:YES completion:nil];
            }
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            _picker = [[UIImagePickerController alloc]init];
            _picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            _picker.delegate = self;
            _picker.allowsEditing = YES;
            [self presentViewController:_picker animated:YES completion:nil];
            break;
        case 1:
            _picker = [[UIImagePickerController alloc]init];
            _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            _picker.delegate = self;
            _picker.allowsEditing = YES;
            [self presentViewController:_picker animated:YES completion:nil];
            break;
        default:
            break;
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [_picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)refreshIcon {
    
    NSIndexPath *tmpIndexpath=[NSIndexPath indexPathForRow:0 inSection:0];
    
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:tmpIndexpath, nil] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    _pickImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshIcon" object:nil];
    [_picker dismissViewControllerAnimated:YES completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UINib * nib = [UINib nibWithNibName:@"PersonalAvatarCell" bundle:nil];
    static NSString * certifAvatar = @"PersonalAvatarCell";
    [tableView registerNib:nib forCellReuseIdentifier:certifAvatar];
    
    UINib * nib2 = [UINib nibWithNibName:@"InfoCell" bundle:nil];
    static NSString * certif = @"MyProfileSettingCell";
    certif = [certif stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    [tableView registerNib:nib2 forCellReuseIdentifier:certif];
    
    //第一行第一列返回 avatarCell
    if (indexPath.row == 0 && indexPath.section == 0) {
        PersonalAvatarCell * personalAvatarCell = [tableView dequeueReusableCellWithIdentifier:certifAvatar];
        if (personalAvatarCell == nil) {
            personalAvatarCell = [[PersonalAvatarCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:certifAvatar];
        }
        if (_pickImage == nil) {
            personalAvatarCell.avatarImageView.image = [UIImage imageNamed:@"Oval"];
        }else {
            personalAvatarCell.avatarImageView.image = _pickImage;
        }
        UIView * separatorLine = [[UIView alloc]initWithFrame:CGRectMake(20, 139, self.view.frame.size.width, 1)];
        separatorLine.backgroundColor = [UIColor colorWithRed:211.0/255 green:211.0/255 blue:211.0/255 alpha:1];
        [personalAvatarCell.contentView addSubview:separatorLine];
        return personalAvatarCell;
    }else {
        // 返回各种持有对象的cell
        if (indexPath.row == 1 && indexPath.section == 0) {
            InfoCell * _nicknameCell = [tableView dequeueReusableCellWithIdentifier:certif];
            if (_nicknameCell == nil) {
                _nicknameCell = [[InfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:certif];
            }
            UIView * separatorLine = [[UIView alloc]initWithFrame:CGRectMake(20, 43, self.view.frame.size.width, 1)];
            separatorLine.backgroundColor = [UIColor colorWithRed:211.0/255 green:211.0/255 blue:211.0/255 alpha:1];
            _nicknameCell.titleLabel.text = @"昵称";
            _nicknameCell.contentLabel.text = _nickname;
            _nicknameCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [_nicknameCell.contentView addSubview:separatorLine];
            return _nicknameCell;
        }else if (indexPath.row == 2 && indexPath.section == 0) {
            InfoCell * _studentNoCell = [tableView dequeueReusableCellWithIdentifier:certif];
            if (_studentNoCell == nil) {
                _studentNoCell = [[InfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:certif];
            }
            _studentNoCell.titleLabel.text = @"学号";
            _studentNoCell.contentLabel.text = _studentNo;
            return _studentNoCell;
        }else if (indexPath.row == 0 && indexPath.section == 1) {
            InfoCell * _schoolCell = [tableView dequeueReusableCellWithIdentifier:certif];
            if (_schoolCell == nil) {
                _schoolCell = [[InfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:certif];
            }
            UIView * separatorLine = [[UIView alloc]initWithFrame:CGRectMake(20, 43, self.view.frame.size.width, 1)];
            separatorLine.backgroundColor = [UIColor colorWithRed:211.0/255 green:211.0/255 blue:211.0/255 alpha:1];
            _schoolCell.titleLabel.text = @"学校";
            _schoolCell.contentLabel.text = _school;
            [_schoolCell.contentView addSubview:separatorLine];
            return _schoolCell;
        }else if (indexPath.row == 1 && indexPath.section == 1) {
            InfoCell * _clazzCell = [tableView dequeueReusableCellWithIdentifier:certif];
            if (_clazzCell == nil) {
                _clazzCell = [[InfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:certif];
            }
            _clazzCell.titleLabel.text = @"班级";
            _clazzCell.contentLabel.text = _clazz;
            return _clazzCell;
        }else if (indexPath.row == 0 && indexPath.section == 2) {
            InfoCell * _realNameCell = [tableView dequeueReusableCellWithIdentifier:certif];
            if (_realNameCell == nil) {
                _realNameCell = [[InfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:certif];
            }
            UIView * separatorLine = [[UIView alloc]initWithFrame:CGRectMake(20, 43, self.view.frame.size.width, 1)];
            separatorLine.backgroundColor = [UIColor colorWithRed:211.0/255 green:211.0/255 blue:211.0/255 alpha:1];
            _realNameCell.titleLabel.text = @"真实姓名";
            _realNameCell.contentLabel.text = _realName;
            [_realNameCell.contentView addSubview:separatorLine];
            return _realNameCell;
        }else if(indexPath.row == 1 && indexPath.section == 2) {
            InfoCell * _idCardCell = [tableView dequeueReusableCellWithIdentifier:certif];
            if (_idCardCell == nil) {
                _idCardCell = [[InfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:certif];
            }
            UIView * separatorLine = [[UIView alloc]initWithFrame:CGRectMake(20, 43, self.view.frame.size.width, 1)];
            separatorLine.backgroundColor = [UIColor colorWithRed:211.0/255 green:211.0/255 blue:211.0/255 alpha:1];
            _idCardCell.titleLabel.text = @"证件号码";
            _idCardCell.contentLabel.text = _idCard;
            [_idCardCell.contentView addSubview:separatorLine];
            return _idCardCell;
        }else if(indexPath.row == 2 && indexPath.section == 2) {
            InfoCell * _phoneCell = [tableView dequeueReusableCellWithIdentifier:certif];
            if (_phoneCell == nil) {
                _phoneCell = [[InfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:certif];
            }
            UIView * separatorLine = [[UIView alloc]initWithFrame:CGRectMake(20, 43, self.view.frame.size.width, 1)];
            separatorLine.backgroundColor = [UIColor colorWithRed:211.0/255 green:211.0/255 blue:211.0/255 alpha:1];
            _phoneCell.titleLabel.text = @"手机";
            _phoneCell.contentLabel.text = _phone;
            [_phoneCell.contentView addSubview:separatorLine];
            return _phoneCell;
        }else if(indexPath.row == 3 && indexPath.section == 2) {
            InfoCell * _emailCell = [tableView dequeueReusableCellWithIdentifier:certif];
            if (_emailCell == nil) {
                _emailCell = [[InfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:certif];
            }
            UIView * separatorLine = [[UIView alloc]initWithFrame:CGRectMake(20, 43, self.view.frame.size.width, 1)];
            separatorLine.backgroundColor = [UIColor colorWithRed:211.0/255 green:211.0/255 blue:211.0/255 alpha:1];
            _emailCell.titleLabel.text = @"邮箱地址";
            _emailCell.contentLabel.text = _email;
            [_emailCell.contentView addSubview:separatorLine];
            return _emailCell;
        }else if(indexPath.row == 4 && indexPath.section == 2) {
            InfoCell * _addressCell = [tableView dequeueReusableCellWithIdentifier:certif];
            if (_addressCell == nil) {
                _addressCell = [[InfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:certif];
            }
            _addressCell.titleLabel.text = @"地址";
            _addressCell.contentLabel.text = _address;
            return _addressCell;
        }
    }
    
//    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:certif];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:certif];
//    }
//    NSString * labelText = [[self.titleArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
//    cell.textLabel.text = labelText;
//    if ((indexPath.section == 0 && indexPath.row == 2 )|| (indexPath.section == 1 && indexPath.row == 1)) {
//        //不加上separatorLine
//    }else {
//        UIView * separatorLine = [[UIView alloc]initWithFrame:CGRectMake(20, 43, self.view.frame.size.width, 1)];
//        separatorLine.backgroundColor = [UIColor colorWithRed:211.0/255 green:211.0/255 blue:211.0/255 alpha:1];
//        if (indexPath.section == 0 && indexPath.row == 0) {
//            separatorLine.frame = CGRectMake(20, 139, self.view.frame.size.width, 1);
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//            if (_pickImage == nil) {
//                UIImageView * imageview = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 150, 20, 100, 100)];
//                imageview.image = [UIImage imageNamed:@"Oval"];
//                [cell.contentView addSubview:imageview];
//            }else {
//                UIImageView * imageview = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 150, 20, 100, 100)];
//                imageview.image = _pickImage;
//                imageview.layer.masksToBounds = YES;
//                imageview.layer.cornerRadius = 50;
//                [cell.contentView addSubview:imageview];
//            }
//            }else if(indexPath.section == 2 && indexPath.row == 4) {
//                separatorLine.frame = CGRectMake(0, 43, self.view.frame.size.width, 1);
//        }
//        [cell.contentView addSubview:separatorLine];
//    }
//    return cell;
    return  nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }else if(section == 1){
        return 2;
    }else if(section == 2){
        return 5;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 140;
        }else {
            return 44;
        }
    }else {
        return 44;
    }
    //根据设计图的  分为两种cell的高度
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    //根据设计图  分为三个 section 每个section的view的高度都不同
    if (section == 0) {
        return 0;
    }else if (section == 1){
        return 30;
    }else {
        return 30;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    //设置分割线
    UIView * separatorLine1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    separatorLine1.backgroundColor = [UIColor grayColor];
    
    UIView * separatorLine2 = [[UIView alloc]initWithFrame:CGRectMake(0, 29, self.view.frame.size.width, 1)];
    separatorLine2.backgroundColor = [UIColor blackColor];
    [headView addSubview:separatorLine2];
    [headView addSubview:separatorLine1];
    return headView;
}


@end
