//
//  PersonalInfo.m
//  SubCourse
//
//  Created by wuhaibin on 15/11/29.
//  Copyright © 2015年 wuhaibin. All rights reserved.
//

#import "PersonalInfo.h"
#import "PersonalCell.h"

@interface PersonalInfo ()

@end

@implementation PersonalInfo

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initArray{
    NSString * originalPassword = @"原密码";
    NSString * newPassword = @"新密码";
    NSString * confirmNewPassword = @"确认新密码";
    self.titleArray = [[NSMutableArray alloc]initWithObjects:originalPassword,newPassword,confirmNewPassword, nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView registerNib:[UINib nibWithNibName:@"PersonalCell" bundle:nil] forCellReuseIdentifier:@"PasswordCell"];
    PersonalCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PasswordCell"];
    if (cell == nil) {
        cell = [[PersonalCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PasswordCell"];
    }
    return cell;
}

@end
