//
//  MyQuestionController.h
//  SubCourse
//
//  Created by wuhaibin on 15/11/27.
//  Copyright © 2015年 wuhaibin. All rights reserved.
//

#import "SCRootViewController.h"

@interface MyQuestionController : SCRootViewController

@property BOOL isQuestion;
@property (strong, nonatomic) UINavigationBar * navigationBar;
@property (strong, nonatomic) NSMutableDictionary * contentDic;

@end
