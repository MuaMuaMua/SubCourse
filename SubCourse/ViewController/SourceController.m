//
//  SourceController.m
//  SubCourse
//
//  Created by wuhaibin on 15/11/27.
//  Copyright © 2015年 wuhaibin. All rights reserved.
//

#import "SourceController.h"
#import "SourceCell.h"
#import "SCTitleMenu.h"
#import "ExerciseViewController.h"
#import "TestViewController.h"
#import "SCPageViewController.h"
#import "YTKKeyValueStore.h"
#import "SubcourseManager.h"
#import "CacheManager.h"
#import "LoginViewcontroller.h"
#import "AppDelegate.h"
#import "MBProgressHUD+MJ.h"
#import "MBProgressHUD.h"

@interface SourceController ()<SCTitleMenuDelegate,SubcourseManagerDelegate,MBProgressHUDDelegate>{
    YTKKeyValueStore * _kvs;
    NSDictionary * _paperDictionarys;
    CacheManager * _cm;
    SubcourseManager * _scManager;
    NSMutableArray * _paperArray;
    AppDelegate * _appDelegate;
    MBProgressHUD * _hud;
    NSMutableArray * _searchArray;
}

@property (strong ,nonatomic) SCTitleMenu * titleMenu;

@end

@implementation SourceController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate   = self;
    
    
    //初始化 titleBtn
    UIButton * titleBtn = [[UIButton alloc] init];
    [titleBtn setTitle:@"资料库" forState:UIControlStateNormal];
    titleBtn.backgroundColor = [UIColor blueColor];
    [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [titleBtn setImage:[UIImage imageNamed:@"dd"] forState:UIControlStateNormal];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.titleView = titleBtn;
    
    //初始化searchBar
    UISearchBar * searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    searchBar.placeholder = @"搜索";
    
    
    
    //    [titleBtn addTarget:self action:@selector(showList) forControlEvents:UIControlEventTouchUpInside];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPaperList) name:@"refreshPaperList" object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getPaperListFromDB) name:@"getAllPaperNotification" object:nil];
    _scManager = [SubcourseManager sharedInstance];
    _scManager.delegate = self;
    [self getPaperListFromDB];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshPaperList {
    [self getPaperListFromDB];
//    [self sss];
    [_tableView reloadData];
}

#pragma mark - 加载本地缓存数据 后台获取

- (void)SCTitleMenu:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //具体选了 哪个科目的cell 再做决定
}

#pragma mark - titleView 下拉的uiview

- (void)showList{
    __weak typeof(self) weakSelf = self;
    if (!self.titleMenu) {
        self.titleMenu = [[SCTitleMenu alloc]initWithDataArr:@[@"语文",@"数学",@"英语",@"物理",@"化学",@"生物",@"政治",@"历史",@"地理"] origin:CGPointMake(0, 0) width:125 rowHeight:44];
        self.titleMenu.delegate = self;
        self.titleMenu.dismiss = ^() {
            weakSelf.titleMenu = nil;
        };
        [self.view addSubview:self.titleMenu];
    }else {
        [self.titleMenu dismissWithCompletion:^(SCTitleMenu *object) {
            weakSelf.titleMenu = nil;
        }];
    }
}

#pragma mark - 初始化参数 具体科目具体的单元数组。

- (void)initSearchArray {
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.chapterArray = [[NSMutableArray alloc]init];
    for (int i = 0; _paperArray.count;  i ++) {
        PaperModel * pm = [_paperArray objectAtIndex:i];
        NSString * paperText = pm.title;
        [self.chapterArray addObject:paperText];
    }
}
//- (void)initData {
//    NSString * string1 = @"12";
//    NSString * string2 = @"123";
//    NSString * string3 = @"45";
//    NSString * string4 = @"456";
//    self.chapterArray = [[NSMutableArray alloc]initWithObjects:string1,string2,string3,string4, nil];
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _paperArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UINib * nib = [UINib nibWithNibName:@"SourceCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:@"SourceCell"];
    SourceCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SourceCell"];
    
    if (cell == nil) {
        
        cell = [[SourceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SourceCell"];
    }
    cell.countLabel.hidden = YES;
    cell.paperTitleLabel.hidden = YES;
    //搜索searchController reload cell
//    if (self.searchController.active) {
//        cell.chapterLabel.text = [self.searchList objectAtIndex:indexPath.row];
//    }
//    else{
//        cell.chapterLabel.text = [self.chapterArray objectAtIndex:indexPath.row];
//    }
//    cell.chapterLabel.text = [self.chapterArray objectAtIndex:indexPath.row];
    PaperModel * paperModel = [_paperArray objectAtIndex:indexPath.row];
    if (paperModel != nil) {
        cell.chapterLabel.text = paperModel.title;
    }
//    cell.contentView.backgroundColor = [UIColor colorWithRed:18.0/255 green:18.0/255 blue:18.0/255 alpha:1];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

#pragma mark - searchControllerDelegate 

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString * searchString = [self.searchController.searchBar text];
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
    if (self.searchList!= nil) {
        [self.searchList removeAllObjects];
    }
    //过滤数据
    self.searchList= [NSMutableArray arrayWithArray:[self.chapterArray filteredArrayUsingPredicate:preicate]];
    //刷新表格
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _appDelegate = [[UIApplication sharedApplication]delegate];
    LoginViewcontroller * loginVC = [[LoginViewcontroller alloc]init];
    SCPageViewController * scpvc = [[SCPageViewController alloc]init];
    scpvc.type = @"1";
    scpvc.currentSelect = 1;
    scpvc.firstPaperIndex = indexPath.row;
    scpvc.paperModel = [_paperArray objectAtIndex:indexPath.row];
    [self presentViewController:scpvc animated:YES completion:nil];
}


/*
 *先从数据库中 获取数据.  若为空 再到后台获取paperDictionary
 */
- (void)getPaperListFromDB {
    _cm = [CacheManager sharedInstance];
    NSArray * paperList = [_cm getAllpaperFromDB];
    if (paperList != nil && paperList.count != 0) {
        _paperArray = [[NSMutableArray alloc]init];
        NSMutableArray * newPaperList = [[NSMutableArray alloc]init];
        for (int i = 0; i < paperList.count; i ++) {
            YTKKeyValueItem * paperItem = [paperList objectAtIndex:i];
            NSDictionary * paperDiction = paperItem.itemObject;
            NSDictionary * paperDictionary = [_cm accemblePaperFromDB:paperDiction];
            [newPaperList addObject:paperDictionary];
        }
        NSMutableDictionary * newPaperDictionarys = [[NSMutableDictionary alloc]init];
        [newPaperDictionarys setObject:newPaperList forKey:@"paperList"];
        _paperArray = [[CacheManager sharedInstance]transformPaperDictionary:newPaperDictionarys];
//        [self initSearchArray];
        [self.tableView reloadData];
    }else {
//        [MBProgressHUD showMessage:@"正在加载"];
        [_scManager getAllPaper];
    }

}

#pragma mark - NotificationCallback

- (void)getAllPaperNotification {
    NSArray * paperList = [_cm getAllpaperFromDB];
    _paperArray = [[NSMutableArray alloc]init];
    NSMutableArray * newPaperList = [[NSMutableArray alloc]init];
    for (int i = 0; i < paperList.count; i ++) {
        YTKKeyValueItem * paperItem = [paperList objectAtIndex:i];
        NSDictionary * paperDiction = paperItem.itemObject;
        NSDictionary * paperDictionary = [_cm accemblePaperFromDB:paperDiction];
        [newPaperList addObject:paperDictionary];
    }
    NSMutableDictionary * newPaperDictionarys = [[NSMutableDictionary alloc]init];
    [newPaperDictionarys setObject:newPaperList forKey:@"paperList"];
    _paperArray = [[CacheManager sharedInstance]transformPaperDictionary:newPaperDictionarys];
    [self.tableView reloadData];
    
}

//- (void) getAllPaperCallBack:(NSDictionary *)responseData {
//    NSArray * paperList = [_cm getAllpaperFromDB];
//    _paperArray = [[NSMutableArray alloc]init];
//    NSMutableArray * newPaperList = [[NSMutableArray alloc]init];
//    for (int i = 0; i < paperList.count; i ++) {
//        YTKKeyValueItem * paperItem = [paperList objectAtIndex:0];
//        NSDictionary * paperDiction = paperItem.itemObject;
//        NSDictionary * paperDictionary = [_cm accemblePaperFromDB:paperDiction];
//        [newPaperList addObject:paperDictionary];
//    }
//    NSMutableDictionary * newPaperDictionarys = [[NSMutableDictionary alloc]init];
//    [newPaperDictionarys setObject:newPaperList forKey:@"paperList"];
//    _paperArray = [[CacheManager sharedInstance]transformPaperDictionary:newPaperDictionarys];
//    [self.tableView reloadData];
//    _paperDictionarys = responseData;
//    if (_paperDictionarys != nil) {
//        [_cm savePaper:_paperDictionarys];
//        _paperArray = [[CacheManager sharedInstance]transformPaperDictionary:_paperDictionarys];
//        
////        [[CacheManager sharedInstance]savePaperModelList:_paperArray];
//    }
//        [MBProgressHUD showSuccess:@"加载成功"];
//
//    [MBProgressHUD hideHUDForView:self.view];
//    [self.tableView reloadData];
//}

@end
