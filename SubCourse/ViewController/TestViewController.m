//
//  TestViewController.m
//  SubCourse
//
//  Created by wuhaibin on 15/12/3.
//  Copyright © 2015年 wuhaibin. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    self.testBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.testBtn.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.testBtn];
    [self.testBtn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [UIView animateWithDuration:1.0 delay:0.0 options:nil animations:^{
        self.testBtn.frame = CGRectMake(30, 200, 40, 40);
    } completion:nil];
    
}

- (void)clickBtn{
    [UIView animateWithDuration:1.0 delay:0.0 options:nil animations:^{
        self.testBtn.frame = CGRectMake(0, 0, 0, 0);
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}



- (void)viewWillDisappear:(BOOL)animated {
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
