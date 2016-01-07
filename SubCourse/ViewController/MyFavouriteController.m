//
//  MyFavouriteController.m
//  SubCourse
//
//  Created by wuhaibin on 15/11/27.
//  Copyright © 2015年 wuhaibin. All rights reserved.
//

#import "MyFavouriteController.h"
#import "FandQCell.h"
#import "SubcourseManager.h"
#import "QuestionModel.h"
#import "CacheManager.h"
#import "MBProgressHUD+MJ.h"
#import "MBProgressHUD.h"
#import "SourceCell.h"
#import "QuestionModel.h"
#import "SCPageViewController.h"
#import "FavouriteCell.h"

@interface MyFavouriteController ()<UITableViewDataSource,UITableViewDelegate,SubcourseManagerDelegate> {
    IBOutlet UITableView * _tableView;
    SubcourseManager * _scManager;
    CacheManager * _cManager;
    NSMutableArray * _favouriteArray;
    PaperModel * _paperModel;
}

@end

@implementation MyFavouriteController

- (void)viewDidLoad {
    [super viewDidLoad];
    _favouriteArray = [[NSMutableArray alloc]init];
    
    //初始化 titleBtn
    UIButton * titleBtn = [[UIButton alloc] init];
    [titleBtn setTitle:@"我的收藏" forState:UIControlStateNormal];
    titleBtn.backgroundColor = [UIColor blueColor];
    [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [titleBtn setImage:[UIImage imageNamed:@"dd"] forState:UIControlStateNormal];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.titleView = titleBtn;

}

- (void)viewWillAppear:(BOOL)animated {
    [self initTableView];
    [self initscManager];
    [self initSubcourseManager];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadFavouriteTableView) name:@"reloadFavouriteTableView" object:nil];
    _paperModel = [_cManager getFavouriteInFavouriteTable];
    if (_paperModel.qmList.count == 0 || _paperModel == nil) {
        [_scManager getAllFavourite];
    }else {
        _paperModel = [_cManager getFavouriteInFavouriteTable];
    }
    
}
- (void)reloadFavouriteTableView {
    
    _paperModel = [_cManager getFavouriteInFavouriteTable];

    [_tableView reloadData];
    [MBProgressHUD showSuccess:@"加载成功"];
}

- (void)initCManager {
    _cManager = [CacheManager sharedInstance];
//    _cManager.d
}

- (void)initSubcourseManager {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initTableView {
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView reloadData];
}

- (void)initscManager {
    _scManager = [SubcourseManager sharedInstance];
    _scManager.delegate = self;
    _cManager = [CacheManager sharedInstance];
}

//- (void)getallFavouriteCallBack:(NSDictionary *)responseData {
//    NSLog(@"%@",responseData);
//    [MBProgressHUD showSuccess:@"加载成功"];
//    //缓存到数据库中
//    NSArray * collections = [responseData objectForKey:@"collections"];
////    for (int i = 0; i < collections.count; i ++) {
////        NSDictionary * collection = [collections objectAtIndex:i];
////    }
//    
//    [_cManager saveFavourite:responseData];
//    _favouriteArray = [_cManager getFavouriteFromDB];
//
//    _paperModel = [_cManager getFavouriteInFavouriteTable];
////    [self initTableView];
//
//    
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UINib * nib = [UINib nibWithNibName:@"FavouriteCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:@"FavouriteCell"];
    FavouriteCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FavouriteCell"];
    if (cell == nil) {
        cell = [[FavouriteCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FavouriteCell"];
    }
    QuestionModel * questionModel = [_paperModel.qmList objectAtIndex:indexPath.row];
//    cell.countLabel.hidden = YES;
    cell.paperTitleLabel.text = questionModel.paperTitle;
    cell.questionTitleLabel.text = [NSString stringWithFormat:@"第%ld小题",questionModel.questionModelId];
//    cell.chapterLabel.text = [NSString stringWithFormat:@"第%ld小题",questionModel.questionModelId];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _paperModel.qmList.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SCPageViewController * scpvc = [[SCPageViewController alloc]init];
    scpvc.type = @"1";

    scpvc.firstPaperIndex = indexPath.row;
    
    scpvc.paperModel = _paperModel;
    scpvc.currentSelect = indexPath.row;
    [self presentViewController:scpvc animated:YES completion:nil];
    ;
    
}

@end
