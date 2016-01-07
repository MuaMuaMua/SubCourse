//
//  SCPageViewController.m
//  SubCourse
//
//  Created by wuhaibin on 15/12/22.
//  Copyright © 2015年 wuhaibin. All rights reserved.
//

#import "SCPageViewController.h"
#import "SCDetailViewcontroller.h"
#import "PaperModel.h"
#import "PartModel.h"
#import "QuestionModel.h"6
#import "YTKKeyValueStore.h"
#import "CacheManager.h"
#import "PaperChooseViewController.h"
#import "SubcourseManager.h"
#import "CacheManager.h"

#define tablename @"paperListTable"

@interface SCPageViewController ()<SCDetailViewDelegate,PaperChooseDelegate,SubcourseManagerDelegate>{
    YTKKeyValueStore * _kvs;
    NSUInteger _currentPage;
    NSMutableArray * _pageMutableArray;
    NSMutableArray * _paperList;
    CacheManager * _cManaeger;
}

@end

@implementation SCPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTestArray];
//    _kvs = [[YTKKeyValueStore alloc]initDBWithName:@"SUBCOURSEDB"];
}

/*
 *ViewWillAppear 的时候就该加载 开始加载数据.
 */

- (void)viewWillAppear:(BOOL)animated {
    //
    _cManaeger = [CacheManager sharedInstance];
    [self initTestArray];
    [self initPageViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - download Task
//检查更新的时间和本地时间是否不同，不同则再次下载。
-  (void)downloadPaperList {
    
}

#pragma mark - store Data 

- (void)storeData:(PaperModel * )pm{

}

#pragma mark - initTestData

- (void)initIntroductionArray {
    self.pageIntroductionArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < 20; i ++) {
        
    }
}

- (void)initTestArray {
    _pageMutableArray = [[NSMutableArray alloc]init];
//    for (int i = 0; i < self.paperModel.pmList.count; i ++) {
//        PartModel * partModel = [self.paperModel.pmList objectAtIndex:i];
//        for (int j = 0; j < partModel.qmList.count; j ++) {
//            [_pageMutableArray addObject:[partModel.qmList objectAtIndex:j]];
//        }
//    }
    
    for (int i = 0; i < self.paperModel.qmList.count; i ++) {
        QuestionModel * questionModel = [self.paperModel.qmList objectAtIndex:i];
        [_pageMutableArray addObject:questionModel];
    }
}

#pragma mark - pageviewcontroller delegate && datasource

- (void)initPageViewController {
//    if ([self.type isEqualToString:@"1"]) {
        NSDictionary * options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin] forKey:UIPageViewControllerOptionSpineLocationKey];
        self.pageController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
        //定义 pageviewcontroller 的view 的frame
        [[self.pageController view]setFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        //get the first viewController
        SCDetailViewcontroller * initialViewController = [self viewcontrollerAtIndex:self.currentSelect];
        initialViewController.firstPaperIndex = self.firstPaperIndex;
        initialViewController.paperModel = self.paperModel;
        initialViewController.questionModel.paperTitle = self.paperModel.title;
        if (self.isFavouriteListPaper) {
            initialViewController.isFavouriteListPaper = YES;
        }
        self.pageController.dataSource = self;
        self.pageController.delegate = self;
        NSArray * viewControllers = [NSArray arrayWithObject:initialViewController];
        [_pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        [self addChildViewController:self.pageController];
        [[self view] addSubview:[self.pageController view]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPaper) name:@"refreshPaperList" object:nil];
//    }
   
}

- (void)refreshPaper {
    NSDictionary * paperDictionary = [[CacheManager sharedInstance]getPaperDictionarys];
//    _paperDictionarys = [_cManaeger getPaperDictionarys];

    _paperList = [[CacheManager sharedInstance]transformPaperDictionary:paperDictionary];
    self.paperModel = [_paperList objectAtIndex:self.firstPaperIndex];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[PaperChooseViewController class]]) {
        return nil;
    }
    NSUInteger index = [self indexOfViewController:(SCDetailViewcontroller *)viewController];
    if (index == 0 || (index == NSNotFound)) {
        return nil;
    }
    index--;
    return [self viewcontrollerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[PaperChooseViewController class]]) {
        return nil;
    }
    NSUInteger index = [self indexOfViewController:(SCDetailViewcontroller *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index ++;
    if (index == _pageMutableArray.count) {
        return nil;
    }
    // return the viewController after currentViewController
    return [self viewcontrollerAtIndex:index];
}

#pragma mark - init pageview datasource

- (void)createPageViewontrollerDatasource {
    self.pageContent = [[NSArray alloc]init];
}

#pragma mark - initDetailViewcontroller 

- (SCDetailViewcontroller *)viewcontrollerAtIndex:(CGFloat)index {
//    if ([self.type isEqualToString:@"1"]) {
        if (index < _pageMutableArray.count) {
            SCDetailViewcontroller * scdvc = [[SCDetailViewcontroller alloc]init];
            scdvc.delegate = self;
            scdvc.value = index;
            scdvc.maxValue = _pageMutableArray.count-1;
            scdvc.minValue = 0;
            scdvc.paperModel = self.paperModel;
            scdvc.paperModel = self.paperModel;
            scdvc.firstPaperIndex = self.firstPaperIndex;
            _currentPage = index;
            if (self.isFavouriteListPaper) {
                scdvc.isFavouriteListPaper = YES;
            }
            int indexf = (int)index;
            scdvc.questionModel = [_pageMutableArray objectAtIndex:indexf];
            scdvc.questionModel.paperTitle = self.paperModel.title;
            //        scdvc.questionModel.isFavourite = YES;
            return  scdvc;
        }
//    }
    return nil;
}

- (NSUInteger)indexOfViewController:(SCDetailViewcontroller *)viewController {
    return [_pageMutableArray indexOfObject:viewController.questionModel];
}

#pragma mark - SCDetailViewDelegate 

- (void)slideValueChanged:(CGFloat)index{
    // bug 1 : 当index 一样的时候还是会跳转 bug2 index 大小判断和翻页的方向不一致
//    if ([self.type isEqualToString:@"1"]) {
        SCDetailViewcontroller * initialViewController = [self viewcontrollerAtIndex:index];
        initialViewController.value = index;
        initialViewController.maxValue = _pageMutableArray.count-1;
        initialViewController.minValue = 0;
        initialViewController.paperModel = self.paperModel;
        initialViewController.paperModel = self.paperModel;
        initialViewController.questionModel.paperTitle = self.paperModel.title;
        if (self.isFavouriteListPaper) {
            initialViewController.isFavouriteListPaper = YES;
        }
        NSArray * viewControllers = [NSArray arrayWithObject:initialViewController];
        [_pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
//    }
}

- (void)presentToTableVC:(NSUInteger)currentPage {
        PaperChooseViewController * pcvc = [[PaperChooseViewController alloc]init];
        pcvc.paperModel = self.paperModel;
        NSArray * viewControllers = [NSArray arrayWithObject:pcvc];
        pcvc.delegate = self;
        [_pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
}

#pragma mark - paperChooseViewController Delegate

- (void)backToPageView:(NSUInteger)pageCount {
        SCDetailViewcontroller * scdvc = [self viewcontrollerAtIndex:_currentPage];
        scdvc.delegate = self;
        scdvc.value = _currentPage;
        scdvc.maxValue = _pageMutableArray.count-1;
        scdvc.minValue = 0;
        scdvc.paperModel = self.paperModel;
//        scdvc.paperModel = 
        scdvc.firstPaperIndex = self.firstPaperIndex;
        scdvc.questionModel = [_pageMutableArray objectAtIndex:_currentPage];
        scdvc.questionModel.paperTitle = self.paperModel.title;
        NSArray * viewControllers = [NSArray arrayWithObject:scdvc];
        [_pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationOrientationHorizontal animated:YES completion:nil];
}

- (void)clickCategoryPage:(NSIndexPath *)indexPath {
    
//    if([self.type isEqualToString:@"1"]) {
    int row = indexPath.row;
    int section = indexPath.section;
//        QuestionModel * questionModel = 
    PartModel * partModel = [self.paperModel.pmList objectAtIndex:indexPath.section];
    QuestionModel * questionModel = [partModel.qmList objectAtIndex:indexPath.row-1];
    int count = 0;
    for ( int i = 0 ; i < _pageMutableArray .count; i ++ ){
        QuestionModel * questionModelCompared = [_pageMutableArray objectAtIndex:i];
        if (questionModel.questionModelId == questionModelCompared.questionModelId) {
            count = i;
        }
    }
    SCDetailViewcontroller * scdvc = [self viewcontrollerAtIndex:count];
    scdvc.delegate = self;
    scdvc.questionModel = questionModel;
    scdvc.maxValue = _pageMutableArray.count-1;
    scdvc.minValue = 0;
    scdvc.paperModel = self.paperModel;
    scdvc.firstPaperIndex = self.firstPaperIndex;
    if (self.isFavouriteListPaper) {
        scdvc.isFavouriteListPaper = YES;
    }
    scdvc.questionModel.paperTitle = self.paperModel.title;
    scdvc.value = count;
    _currentPage = scdvc.value;
    NSArray * viewControllers = [NSArray arrayWithObject:scdvc];
    [_pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationOrientationHorizontal animated:YES completion:nil];
//    }else {
    //待续
//    }

}

@end

