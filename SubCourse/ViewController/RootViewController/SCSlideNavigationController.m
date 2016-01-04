//
//  SCSlideNavigationController.m
//  SubCourse
//
//  Created by wuhaibin on 15/11/27.
//  Copyright © 2015年 wuhaibin. All rights reserved.
//

#import "SCSlideNavigationController.h"
#import "SlideViewCell.h"
#import "StyleConstant.h"

@interface SCSlideNavigationController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation SCSlideNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initArray];
    self.slideView.dataSource = self;
    self.slideView.delegate = self;
    self.slideView.scrollEnabled = NO;
    UIView * separatorLine = [[UIView alloc]initWithFrame:CGRectMake(self.slideView.frame.size.width * SLIDE_VIEW_WIDTH - 2, 0, 2, self.view.frame.size.height)];
    separatorLine.backgroundColor = [UIColor blackColor];
    [self.slideView addSubview:separatorLine];
//    self.slideView.backgroundColor = [UIColor colorWithRed:16.0/255 green:16.0/255 blue:16.0/255 alpha:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initCellTitleArray 

- (void)initArray {
    self.titleArray = [[NSMutableArray alloc]init];
    NSString * title1 = @"资 料 库";
    NSString * title2 = @"我的收藏";
    NSString * title3 = @"我的提问";
    NSString * title4 = @"设  置";
//    NSString * title5 = @"发现";
    NSString * title6 = @"注销";
    
    self.titleArray = [[NSMutableArray alloc]initWithObjects:title1,title2,title3,title4,title6, nil];
}

#pragma mark - tableview datasource && delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    }else {
        return 1;
    }
    return 4;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * certif = @"SlideViewCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:certif];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:certif];
    }
    if (indexPath.section == 0) {
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, self.slideView.frame.size.width * SLIDE_VIEW_WIDTH, 20)];
        titleLabel.text = [self.titleArray objectAtIndex:indexPath.row];
        titleLabel.textAlignment = UITextAlignmentCenter;
        UIView * separatorLine = [[UIView alloc]initWithFrame:CGRectMake(0, 42, self.slideView.frame.size.width * SLIDE_VIEW_WIDTH, 2)];
        separatorLine.backgroundColor = [UIColor blackColor];
        [cell.contentView addSubview:titleLabel];
        [cell.contentView addSubview:separatorLine];
    }else {
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, self.slideView.frame.size.width * SLIDE_VIEW_WIDTH, 20)];
        titleLabel.text = @"注  销";
        titleLabel.textAlignment = UITextAlignmentCenter;
        UIView * separatorLine = [[UIView alloc]initWithFrame:CGRectMake(0, 42, self.slideView.frame.size.width * SLIDE_VIEW_WIDTH, 2)];
        separatorLine.backgroundColor = [UIColor blackColor];
        [cell.contentView addSubview:titleLabel];
        [cell.contentView addSubview:separatorLine];
    }
    return cell;
}
  
- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return self.slideView.frame.size.height / 3 ;
    }else {
        return 60;
    }
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 260, 180)];
        //设置icon
        UIButton * iconBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.slideView.frame.size.width * SLIDE_VIEW_WIDTH / 2 - 40, 70, 80, 80)];
        [iconBtn setImage:[UIImage imageNamed:@"Oval"] forState:UIControlStateNormal];
        //设置icon 下面的label
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake( 0,  160, self.slideView.frame.size.width * SLIDE_VIEW_WIDTH, 40)];
        label.font = [UIFont systemFontOfSize:20];
        label.textColor = [UIColor blackColor];
        label.text = @"用户学号";
        label.textAlignment = UITextAlignmentCenter;
        //设置分割线
        UIView * separatorView = [[UIView alloc]initWithFrame:CGRectMake(0,self.slideView.frame.size.height/3 - 2, self.slideView.frame.size.width, 2)];
        separatorView.backgroundColor = [UIColor blackColor];
        [iconBtn addTarget:self action:@selector(clickIcon) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:iconBtn];
        [headView addSubview:label];
        [headView addSubview:separatorView];
        return headView;
    }else {
        UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 60)];
        UIView * separatorLine = [[UIView alloc]initWithFrame:CGRectMake(0, 58, self.slideView.frame.size.width*SLIDE_VIEW_WIDTH -2 , 2)];
        separatorLine.backgroundColor = [UIColor blackColor];
        [headView addSubview:separatorLine];
        return headView;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self showItemAtIndex:indexPath withAnimation:YES];
}

- (void)clickIcon {
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
    [self showItemAtIndex:indexPath withAnimation:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
