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
#import "MJRefresh.h"
#import "CLLASSFavouriteCell.h"
#import "CacheManager.h"
#import "SubcourseManager.h"
#import "PrefixHeader.pch"

@interface MyFavouriteController ()<UITableViewDataSource,UITableViewDelegate,SubcourseManagerDelegate,UISearchBarDelegate,UISearchDisplayDelegate,UISearchResultsUpdating,UISearchControllerDelegate> {
    IBOutlet UIView *_bgView;
    IBOutlet UITableView * _tableView;
    SubcourseManager * _scManager;
    CacheManager * _cManager;
    NSMutableArray * _favouriteArray;
    PaperModel * _paperModel;
    MJRefreshNormalHeader * _mjRefreshHeader;
    int _isEditing;
    PaperModel * _paperNewModel;
    MJRefreshHeader * _mjHeader;
    BOOL _isSelecting;
    BOOL flag ;
}

@end

@implementation MyFavouriteController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isEditing = 0;
    _tableView.dataSource = self;
    _tableView.delegate   = self;
    _mjRefreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(favouriteRefresh)];
    _mjRefreshHeader.backgroundColor = [UIColor whiteColor];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.header = _mjRefreshHeader;
//    _mjHeader.p
    [self initscManager];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadFavouriteTableView) name:@"reloadFavouriteTableView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadFavourite) name:@"reloadFavourite" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resignSearchBar) name:@"resignSearchBar" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(firstSearchBar) name:@"firstSearchBar" object:nil];
    _paperModel = [_cManager getFavouriteInFavouriteTable];
    if (_paperModel.qmList.count == 0 || _paperModel == nil) {
        [_mjRefreshHeader beginRefreshing];
        [_scManager getAllFavourite];
    }else {
        _paperModel = [_cManager getFavouriteInFavouriteTable];
        [self initSearchController];
    }
    _favouriteArray = [[NSMutableArray alloc]init];
    [self.rightBtn.customView setHidden:YES];
    [self.rightBtn setEnabled:NO];
    self.view.backgroundColor = [UIColor whiteColor];
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

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    
    if (flag) {
        [self firstSearchBar];
        flag = NO;
    }else {
        
    }
}

- (void)firstSearchBar {
    if (self.isSearchbarFirstResponder == YES) {
        if (self.isCancelClick) {
            //不在搜索状态中
//            [_searchController.searchBar becomeFirstResponder];
        }else {
            [_searchController.searchBar becomeFirstResponder];
        }
    }
}

- (void)resignSearchBar {
    [_searchController.searchBar resignFirstResponder];
    [_searchController dismissViewControllerAnimated:YES completion:nil];
    [self firstSearchBar];
}

#pragma mark - 初始化参数 具体科目具体的单元数组。

- (void)initSearchArray {
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    self.searchController.searchBar.delegate = self;
    self.searchController.delegate = self;
    _tableView.tableHeaderView = self.searchController.searchBar;
    _tableView.tableHeaderView.backgroundColor = [UIColor whiteColor];
    _tableView.tableFooterView.backgroundColor = [UIColor clearColor];
    self.chapterArray = [[NSMutableArray alloc]init];
    self.chapterNewList = [[NSMutableArray alloc]init];
    for (int i = 0; _paperModel.qmList.count;  i ++) {
        QuestionModel * qm = [_paperModel.qmList objectAtIndex:i];
        NSString * paperText = qm.paperTitle;
        paperText = [paperText stringByAppendingString:qm.partTitle];
        paperText = [paperText stringByAppendingString:[NSString stringWithFormat:@"第%d小题",qm.questionNumber.intValue]];
        [self.chapterNewList addObject:paperText];
        [self.chapterArray addObject:paperText];
    }
}


#pragma mark - searchControllerDelegate

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    // 设置两个标志位
    if (self.isCancelClick) {
        // 如果不进来这里 就让
        NSMutableDictionary * dictionary = [[NSMutableDictionary alloc]init];
        [dictionary setObject:@"1" forKey:@"key"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"searchingDTZ" object:dictionary];
        self.isCancelClick = NO;
    }else{
        // 进入此判断则 标志位改为YES
        NSMutableDictionary * dictionary = [[NSMutableDictionary alloc]init];
        [dictionary setObject:@"2" forKey:@"key"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"searchingDTZ" object:dictionary];
    }
    if (_isSelecting) {
        _isSelecting = NO;
    }else {
        self.isSearchbarFirstResponder = YES;
        NSString * searchString = [self.searchController.searchBar text];
        NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
        if (self.searchList!= nil) {
            [self.searchList removeAllObjects];
        }
        //过滤数据
        self.chapterNewList = [[NSMutableArray alloc]init];
        self.chapterArray = [[NSMutableArray alloc]init];
        self.paperNewList = [[NSMutableArray alloc]init];
        for (int i = 0; i < _paperModel.qmList.count; i ++) {
            QuestionModel * qm = [_paperModel.qmList objectAtIndex:i];
            NSString * paperText = qm.paperTitle;
            paperText = [paperText stringByAppendingString:qm.partTitle];
            paperText = [paperText stringByAppendingString:[NSString stringWithFormat:@"第%d小题",qm.questionNumber.intValue+1]];
            [self.chapterNewList addObject:paperText];
            [self.chapterArray addObject:paperText];
        }
        
        self.searchList = [[NSMutableArray alloc]init];
        for (int k = 0; k < self.chapterNewList.count; k ++) {
            NSString * string = [self.chapterNewList objectAtIndex:k];
            NSRange range=[string rangeOfString:searchString];
            if(range.location!=NSNotFound){
                [self.searchList addObject:[self.chapterNewList objectAtIndex:k]];
            }else{
            }
        }
        _paperNewModel = [[PaperModel alloc]init];
        _paperNewModel.qmList = [[NSMutableArray alloc]init];
        for(int i = 0; i < self.searchList.count; i ++) {
            NSString * searchString = [self.searchList objectAtIndex:i];
            for (int j = 0; j < self.chapterNewList.count; j++) {
                NSString * newString = [self.chapterNewList objectAtIndex:j];
                if ([searchString isEqualToString:newString]) {
                    QuestionModel * questionModel = [_paperModel.qmList objectAtIndex:j];
                    [_paperNewModel.qmList addObject:questionModel];
                }
            }
        }
        //刷新表格
        [_tableView reloadData];
        _isSelecting = NO;
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.isCancelClick = YES;
}

#pragma mark - 初始化搜索控制器

- (void)initSearchController {
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.searchResultsUpdater = self;
    _searchController.dimsBackgroundDuringPresentation = NO;
    _searchController.hidesNavigationBarDuringPresentation = NO;
    _searchController.delegate = self;
    _searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    self.searchController.searchBar.delegate = self;
//    self.searchController.delegate = self;
    UIView * blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 44)];
    _tableView.tableHeaderView = blackView;
    _tableView.tableHeaderView.backgroundColor = [UIColor clearColor];
    [_tableView.tableHeaderView addSubview:_searchController.searchBar];

}

//重新刷新FavouriteTableView

- (void)reloadFavouriteTableView {
    [_mjRefreshHeader endRefreshing];
    _cManager = [CacheManager sharedInstance];
    _paperModel = [_cManager getFavouriteInFavouriteTable];
    [_tableView reloadData];
    [self initSearchController];
}

#pragma mark - reload AllFavourite MJFresh Action

- (void)reloadFavourite {
    [_mjRefreshHeader endRefreshing];
//    [_mjHeader endRefreshing];
    _cManager = [CacheManager sharedInstance];
    _paperModel = [_cManager getFavouriteInFavouriteTable];
    [_tableView reloadData];
}

#pragma getAllFavourite From Server

- (void)favouriteRefresh {
    if (_searchController.isActive) {
        [_mjRefreshHeader endRefreshing];
    }else {
        [_scManager getAllFavourite];
    }
}

#pragma mark - 初始化tableview

- (void)initTableView {
    _mjRefreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(favouriteRefresh)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.editing = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.header = _mjRefreshHeader;
}

#pragma mark - 初始化封装的接口 和 本地缓存

- (void)initscManager {
    _scManager = [SubcourseManager sharedInstance];
    _scManager.delegate = self;
    _cManager = [CacheManager sharedInstance];

}

#pragma mark - initialize tableview TableView Delegate and DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0f;
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    _isEditing = 1;
    if (_searchController.isActive) {
        return UITableViewCellEditingStyleNone;
    }else {
        return UITableViewCellEditingStyleDelete;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UINib * nib = [UINib nibWithNibName:@"CLLASSFavouriteCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:@"CLLASSFavouriteCell"];
    CLLASSFavouriteCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CLLASSFavouriteCell"];
    if (cell == nil) {
        cell = [[CLLASSFavouriteCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CLLASSFavouriteCell"];
    }
    if (self.searchController.active) {
        QuestionModel * questionModel = [_paperNewModel.qmList objectAtIndex:indexPath.row];
        cell.paperLabel.text = questionModel.paperTitle;
        cell.partLabel.text = questionModel.partTitle;
        cell.questionLabel.text = [NSString stringWithFormat:@"第%d小题",questionModel.partNumber.intValue+1];
    }else {
        QuestionModel * questionModel = [_paperModel.qmList objectAtIndex:indexPath.row];
        cell.editing = YES;
        cell.paperLabel.text = questionModel.paperTitle;
        cell.partLabel.text = questionModel.partTitle;
        cell.questionLabel.text = [NSString stringWithFormat:@"第%d小题",questionModel.partNumber.intValue+1];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchController.active) {
        return [self.searchList count];
    }else{
        return _paperModel.qmList.count;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
//        if (_searchController.isActive) {
//            QuestionModel * questionModel = [_paperNewModel.qmList objectAtIndex:indexPath.row];
//            [_scManager removeFavourite:questionModel.questionModelId DTZSuccessBlock:^(NSDictionary *successBlock) {
//                [_cManager addfavouriteData:questionModel IsFavourite:NO];
//            } DTZFailBlock:^(NSDictionary *failBlock) {
//                [MBProgressHUD showError:@"删除失败"];
//            }];
//            //先修改数据源 否则崩溃
////            [_paperModel.qmList removeObjectAtIndex:indexPath.row];
//            [_paperNewModel.qmList removeObjectAtIndex:indexPath.row];
//            [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
//        }else {
            QuestionModel * questionModel = [_paperModel.qmList objectAtIndex:indexPath.row];
            [_scManager removeFavourite:questionModel.questionModelId DTZSuccessBlock:^(NSDictionary *successBlock) {
                [_cManager addfavouriteData:questionModel IsFavourite:NO];
            } DTZFailBlock:^(NSDictionary *failBlock) {
                [MBProgressHUD showError:@"删除失败"];
            }];
            //先修改数据源 否则崩溃
            [_paperModel.qmList removeObjectAtIndex:indexPath.row];
            [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
//        }
    } else {
        
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)notToReloadTable {
    [_searchController.searchBar resignFirstResponder];
    [_searchController dismissViewControllerAnimated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _isSelecting = YES;
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    SCPageViewController * scpvc = [[SCPageViewController alloc]init];
    scpvc.type = @"1";
    NSLog(@"%ld",indexPath.row);
    scpvc.firstPaperIndex = indexPath.row;
    scpvc.isFavouriteListPaper = YES;
    if (_searchController.isActive) {
        _cManager = [CacheManager sharedInstance];
        QuestionModel * questionModel = [_paperNewModel.qmList objectAtIndex:indexPath.row];
        PaperModel * paperModel = [_cManager getPaperById:questionModel.paperId];
        scpvc.paperModel = paperModel;
        flag = YES;

        [scpvc initPageViewController:(questionModel.questionNumber.integerValue)];
    }else {
        _cManager = [CacheManager sharedInstance];
        QuestionModel * questionModel = [_paperModel.qmList objectAtIndex:indexPath.row];
        PaperModel * paperModel = [_cManager getPaperById:questionModel.paperId];
        scpvc.paperModel = paperModel;
        flag = NO;

        [scpvc initPageViewController:(questionModel.questionNumber.integerValue)];
    }
    // 根据 question的 paperId 来获取原来那张paper的id
    [self notToReloadTable];
    _isSelecting = NO;

    [self presentViewController:scpvc animated:YES completion:nil];
}

@end
