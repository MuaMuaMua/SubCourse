//
//  MyQuestionController.m
//  SubCourse
//
//  Created by wuhaibin on 15/11/27.
//  Copyright © 2015年 wuhaibin. All rights reserved.
//

#import "MyQuestionController.h"
#import "QuestionModel.h"
#import "SubcourseManager.h"
@interface MyQuestionController ()<SubcourseManagerDelegate> {

    SubcourseManager * _scManager;
}

@end

@implementation MyQuestionController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor redColor];
//    self.view.backgroundColor = [UIColor grayColor];
    // Do any additional setup after loading the view from its nib.
    [self initscManager];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - subcourse Delegate 

- (void)initscManager {
    _scManager = [SubcourseManager sharedInstance];
    _scManager.delegate = self;
    [_scManager getAllQuiz];
}

- (void)getallQuizCallBack:(NSDictionary *)responseData {
    
}

#pragma mark - initContentDictionary

//- (void)

#pragma mark - initQuestionModelView

- (void)initQuestionModelView {
    
}


@end
