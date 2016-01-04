//
//  SCPageViewController.h
//  SubCourse
//
//  Created by wuhaibin on 15/12/22.
//  Copyright © 2015年 wuhaibin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCDetailViewcontroller.h"
#import "PaperModel.h"

@interface SCPageViewController : UIViewController<UIPageViewControllerDataSource,UIPageViewControllerDelegate>

@property (strong, nonatomic) NSArray * pageContent;
@property (strong, nonatomic) UIPageViewController * pageController;
@property (strong, nonatomic) NSMutableArray * pageIntroductionArray;
@property (strong, nonatomic) PaperModel * paperModel;

@property NSInteger firstPaperIndex;

@end
