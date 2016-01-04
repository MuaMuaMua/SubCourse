//
//  SCRootViewController.m
//  SubCourse
//
//  Created by wuhaibin on 15/11/27.
//  Copyright © 2015年 wuhaibin. All rights reserved.
//

#import "SCRootViewController.h"
#import "AppDelegate.h"

@interface SCRootViewController (){
    AppDelegate * _appDelegate;
}

@end

@implementation SCRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _appDelegate = [[UIApplication sharedApplication]delegate];
    [self initNavigator];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initNavigator {
    UIButton * navigationLeftBtn = [[UIButton  alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [navigationLeftBtn setImage:[UIImage imageNamed:@"LeftBtn"] forState:UIControlStateNormal];
    [navigationLeftBtn addTarget:_appDelegate.slideNavigator action:@selector(slideButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithCustomView:navigationLeftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)clickLeftBtn {
    
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
