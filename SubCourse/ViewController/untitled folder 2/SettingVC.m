//
//  SettingVC.m
//  SubCourse
//
//  Created by wuhaibin on 16/1/20.
//  Copyright © 2016年 wuhaibin. All rights reserved.
//

#import "SettingVC.h"
#import "SettingsCell.h"

@interface SettingVC ()<UITableViewDataSource,UITableViewDelegate> {
    
    IBOutlet UITableView *_tableView;
    
}

@end

@implementation SettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化 titleBtn
    UIButton * titleBtn = [[UIButton alloc] init];
    [titleBtn setTitle:@"设  置" forState:UIControlStateNormal];
    titleBtn.backgroundColor = [UIColor blueColor];
    [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [titleBtn setImage:[UIImage imageNamed:@"dd"] forState:UIControlStateNormal];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.titleView = titleBtn;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self setTableView];
}

#pragma mark - tableview Delegate && datasource

- (void)setTableView {
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.backgroundColor = [UIColor colorWithRed:236.0/255 green:235.0/255 blue:243.0/255 alpha:1];
    _tableView.backgroundColor = [UIColor whiteColor];
    //    240 239 245
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * certif = @"SettingsCell";
    UINib * nib = [UINib nibWithNibName:@"SettingsCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:certif];
    SettingsCell * cell = [tableView dequeueReusableCellWithIdentifier:certif];
    if (cell == nil) {
        cell = [[SettingsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:certif];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.titleLabel.textColor = [UIColor blackColor];
    cell.titleLabel.text = @"我的资料wow";
//    switch (indexPath.section) {
//        case 0:
//            cell.titleLabel.text = @"我的资料";
//            break;
//        case 1:
//            cell.titleLabel.text = @"一般";
//            break;
//        case 2:
//            cell.titleLabel.text = @"关于CLLASS";
//            break;
//        default:
//            break;
//    }
    return cell;
}

@end
