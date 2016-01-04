//
//  ExerciseViewController.m
//  SubCourse
//
//  Created by wuhaibin on 15/11/30.
//  Copyright © 2015年 wuhaibin. All rights reserved.
//

#import "ExerciseViewController.h"
#import "SubcourseManager.h"
#import "CacheManager.h"

@interface ExerciseViewController ()<SubcourseManagerDelegate>

@end

@implementation ExerciseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    UIButton * navigationLeftBtn = [[UIButton  alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [navigationLeftBtn setImage:[UIImage imageNamed:@"LeftBtn"] forState:UIControlStateNormal];
    [navigationLeftBtn addTarget:self action:@selector(clickLeftBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithCustomView:navigationLeftBtn];
    self.navigationItem.rightBarButtonItem = leftItem;
    self.title = @"第一单元";
    self.sliderControl.minimumValue = 1;
    self.sliderControl.maximumValue = 30;
    [self.sliderControl addTarget:self action:@selector(changeValue) forControlEvents:UIControlEventValueChanged];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changeValue {
//    self.sliderControl.value
    NSLog(@"%f",self.sliderControl.value);
    int count = self.sliderControl.value;
    NSLog(@"%d",count);
    [self reloadTextView];
}

- (void)reloadTextView {
    
}

//- (void) 

#pragma mark - 初始化界面的元素和数据

- (void)initData {

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
