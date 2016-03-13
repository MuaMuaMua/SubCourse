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

@protocol SCPageViewControllerDelegate <NSObject>

@optional
- (void)pageBackAction ;

@end

@interface SCPageViewController : UIViewController<UIPageViewControllerDataSource,UIPageViewControllerDelegate>

@property (strong, nonatomic) NSArray * pageContent;
@property (strong, nonatomic) UIPageViewController * pageController;
@property (strong, nonatomic) NSMutableArray * pageIntroductionArray;
@property (strong, nonatomic) PaperModel * paperModel;
@property (strong, nonatomic) id<SCPageViewControllerDelegate> pageDelegate;

/*
 *type 是@“1”的时候 是所有试卷的内容， type 是@“2”的时候 为收藏m
 */
@property (strong, nonatomic) NSString * type;

@property NSInteger firstPaperIndex;

@property int currentSelect;

@property BOOL isFavouriteListPaper;

- (void)initPageViewController;

- (void)initPageViewController:(NSInteger)index;


@end
