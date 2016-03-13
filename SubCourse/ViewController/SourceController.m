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
#import "MJRefresh.h"
#import "CLLASSDetailViewcontroller.h"
#import "SCSlideNavigationController.h"
#import "QRCodeViewController.h"


#define WX_APP_ID @"wx2fdedcbd7e0d4624"
#define WX_APP_SECRET @"2219926324b576653cf3386ffeea046c"

@interface SourceController ()<SCTitleMenuDelegate,SubcourseManagerDelegate,MBProgressHUDDelegate,UISearchBarDelegate,UISearchDisplayDelegate,UISearchResultsUpdating,UISearchControllerDelegate,CLLASSDetailViewcontroller,SCPageViewControllerDelegate,QRCodeVCDelegate>{
    YTKKeyValueStore * _kvs;
    NSDictionary * _paperDictionarys;
    CacheManager * _cm;
    SubcourseManager * _scManager;
    NSMutableArray * _paperArray;
    AppDelegate * _appDelegate;
    MBProgressHUD * _hud;
    NSMutableArray * _searchArray;
    MJRefreshNormalHeader * _mjRefreshHeader;
    PaperModel * _paperNewModel;
    NSMutableArray * _paperNewList;
    BOOL _isSelecting;
    BOOL flag ;
    
//    BOOL _isSearchBarFirstResponder;
}

@property (strong ,nonatomic) SCTitleMenu * titleMenu;

@end

@implementation SourceController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始胡 TABLEVIEW
    self.tableView.dataSource = self;
    self.tableView.delegate   = self;
    _mjRefreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(sourceRefresh)];
    _mjRefreshHeader.backgroundColor = [UIColor whiteColor];
    _tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.header = _mjRefreshHeader;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNewPaper) name:@"refreshNewPaper" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resignSearchBar) name:@"resignSearchBar" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(firstSearchBar) name:@"firstSearchBar" object:nil];
    [self initSearchController];
    [self setupViews];
}

- (void)firstSearchBar {
    if (self.isSearchbarFirstResponder == YES) {
        if (flag) {
            //不在搜索状态中
            [_searchController.searchBar becomeFirstResponder];
        }else {
        }
    }
}

- (void)resignSearchBar {
    [_searchController.searchBar resignFirstResponder];
    [_searchController dismissViewControllerAnimated:YES completion:nil];
    [self firstSearchBar];
}

- (void)pageBackAction {
    
}

- (void)setupViews {
    //初始化 titleBtn
    UIButton * titleBtn = [[UIButton alloc] init];
    [titleBtn setTitle:@"资料库" forState:UIControlStateNormal];
    titleBtn.backgroundColor = [UIColor blueColor];
    [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [titleBtn setImage:[UIImage imageNamed:@"dd"] forState:UIControlStateNormal];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.titleView = titleBtn;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPaperList) name:@"refreshPaperList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNewPaper) name:@"refreshNewPaper" object:nil];
    [self initSearchController];
}

- (void)sourceRefresh {
    if (self.searchController.isActive) {
        [_mjRefreshHeader endRefreshing];
    }else {
        [_scManager getNewPaper];
    }
}

- (void)refreshNewPaper {
    [MBProgressHUD showSuccess:@"加载成功"];
    [_mjRefreshHeader endRefreshing];
    [self getPaperListFromDB];
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getAllPaperNotification) name:@"getAllPaperNotification" object:nil];
    _scManager = [SubcourseManager sharedInstance];
    _scManager.delegate = self;
    if (_paperArray == nil) {
        [self getPaperListFromDB];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    if (flag) {
        [self firstSearchBar];
        flag = NO;
    }else {
        
    }
    NSString * isAddFavourite = [[NSUserDefaults standardUserDefaults] objectForKey:@"isAddFavourit"];
    if ([isAddFavourite isEqualToString:@"YES"]) {
        [self loadFavouriteAction];
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isAddFavourit"];
        
        if (_searchController.isActive) {
        NSString * searchString = [self.searchController.searchBar text];
        NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
        if (self.searchList!= nil) {
            [self.searchList removeAllObjects];
        }
        //过滤数据
        self.chapterArray = [[NSMutableArray alloc]init];
        self.chapterNewArray = [[NSMutableArray alloc]init];
        for (int i = 0; i < _paperArray.count; i ++) {
            PaperModel * pm = [_paperArray objectAtIndex:i];
            [self.chapterArray addObject:pm.title];
            [self.chapterNewArray addObject:pm.title];
        }
        self.searchList = [[NSMutableArray alloc]init];
        for (int k = 0; k < self.chapterNewArray.count; k ++) {
            NSString * string = [self.chapterNewArray objectAtIndex:k];
            NSRange range=[string rangeOfString:searchString];
            if(range.location!=NSNotFound){
                [self.searchList addObject:[self.chapterNewArray objectAtIndex:k]];
            }else{
            }
        }
        
        _paperNewList = [[NSMutableArray alloc]init];
        for(int i = 0; i < self.searchList.count; i ++) {
            NSString * searchString = [self.searchList objectAtIndex:i];
            for (int j = 0; j < self.chapterNewArray.count; j++) {
                NSString * newString = [self.chapterNewArray objectAtIndex:j];
                if ([searchString isEqualToString:newString]) {
                    [_paperNewList addObject:[_paperArray objectAtIndex:j]];
                }
            }
        }
        }
        [_tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CLLASSDetail Delegate

- (void)backToListVC {

//    [_searchController.searchBar becomeFirstResponder];
}

#pragma mark - QRControllerDelegate

- (void)qrBackToList {
    self.isCancelClick = NO;
    flag = NO;
//    _isSelecting = NO;
    _isSearchbarFirstResponder = NO;
//    [self initSearchController];
}

- (void)refreshPaperList {

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
    _searchController.delegate = self;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.chapterArray = [[NSMutableArray alloc]init];
    for (int i = 0; _paperArray.count;  i ++) {
        PaperModel * pm = [_paperArray objectAtIndex:i];
        NSString * paperText = pm.title;
        [self.chapterArray addObject:paperText];
    }
}

#pragma mark - searchControllerDelegate

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    // 设置两个标志位
    if (self.isCancelClick) {
        // 如果不进来这里 就让
        self.qrCodeBtn.hidden = NO;
        NSMutableDictionary * dictionary = [[NSMutableDictionary alloc]init];
        [dictionary setObject:@"1" forKey:@"key"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"searchingDTZ" object:dictionary];
        self.isCancelClick = NO;
    }else{
        // 进入此判断则 标志位改为YES
        self.qrCodeBtn.hidden = YES;
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
        self.chapterArray = [[NSMutableArray alloc]init];
        self.chapterNewArray = [[NSMutableArray alloc]init];
        for (int i = 0; i < _paperArray.count; i ++) {
            PaperModel * pm = [_paperArray objectAtIndex:i];
            [self.chapterArray addObject:pm.title];
            [self.chapterNewArray addObject:pm.title];
        }
        self.searchList = [[NSMutableArray alloc]init];
        for (int k = 0; k < self.chapterNewArray.count; k ++) {
            NSString * string = [self.chapterNewArray objectAtIndex:k];
            NSRange range=[string rangeOfString:searchString];
            if(range.location!=NSNotFound){
                [self.searchList addObject:[self.chapterNewArray objectAtIndex:k]];
            }else{
            }
        }

        _paperNewList = [[NSMutableArray alloc]init];
        for(int i = 0; i < self.searchList.count; i ++) {
            NSString * searchString = [self.searchList objectAtIndex:i];
            for (int j = 0; j < self.chapterNewArray.count; j++) {
                NSString * newString = [self.chapterNewArray objectAtIndex:j];
                if ([searchString isEqualToString:newString]) {
                    [_paperNewList addObject:[_paperArray objectAtIndex:j]];
                }
            }
        }
        //刷新表格
        [self.tableView reloadData];
        _isSelecting = NO;
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"searchingDTZ" object:nil];
    self.isCancelClick = YES;
    _isSelecting = NO;
//    self.isSearchbarFirstResponder = NO;
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
    
//    self.tableView.tableHeaderView = self.searchController.searchBar;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchController.active) {
        return [self.searchList count];
    }else{
        return _paperArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UINib * nib = [UINib nibWithNibName:@"SourceCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:@"SourceCell"];
    SourceCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SourceCell"];
    if (cell == nil) {
        cell = [[SourceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SourceCell"];
    }
    if (self.searchController.active) {
        cell.countLabel.hidden = YES;
        cell.paperTitleLabel.hidden = YES;
        PaperModel * paperModel = [_paperNewList objectAtIndex:indexPath.row];
        if (paperModel != nil) {
            cell.chapterLabel.text = paperModel.title;
        }
    }else {
        cell.countLabel.hidden = YES;
        cell.paperTitleLabel.hidden = YES;
        PaperModel * paperModel = [_paperArray objectAtIndex:indexPath.row];
        if (paperModel != nil) {
            cell.chapterLabel.text = paperModel.title;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (void)notToReloadTable {
    [_searchController.searchBar resignFirstResponder];
    [_searchController dismissViewControllerAnimated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _isSelecting = YES;
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ([_searchController isActive]) {
        SCPageViewController * scpvc = [[SCPageViewController alloc]init];
        scpvc.type = @"1";
        scpvc.currentSelect = 1;
        scpvc.pageDelegate = self;
        NSLog(@"%ld",(long)indexPath.row);
        scpvc.firstPaperIndex = indexPath.row;
        scpvc.paperModel = [_paperNewList objectAtIndex:indexPath.row];
        [scpvc initPageViewController];
        [_searchController dismissViewControllerAnimated:NO completion:nil];
        flag = YES;
//        flag = NO;
        // 根据 question的 paperId 来获取原来那张paper的id
        [self notToReloadTable];
        _isSelecting = NO;
        [self presentViewController:scpvc animated:YES completion:nil];
    }else {
        SCPageViewController * scpvc = [[SCPageViewController alloc]init];
        scpvc.type = @"1";
        scpvc.currentSelect = 1;
        NSLog(@"%ld",(long)indexPath.row);
        scpvc.firstPaperIndex = indexPath.row;
        scpvc.paperModel = [_paperArray objectAtIndex:indexPath.row];
        [scpvc initPageViewController];
        flag = NO;
        // 根据 question的 paperId 来获取原来那张paper的id
        [self notToReloadTable];
        _isSelecting = NO;
//        [_searchController dismissViewControllerAnimated:YES completion:nil];
        [self presentViewController:scpvc animated:YES completion:nil];
    }
//    SCPageViewController * scpvc = [[SCPageViewController alloc]init];
//    scpvc.type = @"1";
//    scpvc.currentSelect = 1;
//    
//    NSLog(@"%ld",(long)indexPath.row);
//    scpvc.firstPaperIndex = indexPath.row;
//    scpvc.paperModel = [_paperArray objectAtIndex:indexPath.row];
//    [scpvc initPageViewController];
//    [self presentViewController:scpvc animated:YES completion:nil];
}

- (void)clickQRCodeBtn {

    [self notToReloadTable];
    NSString * mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (authorizationStatus == AVAuthorizationStatusRestricted|| authorizationStatus == AVAuthorizationStatusDenied) {
        UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"摄像头访问受限" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertC animated:YES completion:nil];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertC addAction:action];
    }else{
        QRCodeViewController * qrcvc = [[QRCodeViewController alloc]init];
        qrcvc.qrDelegate = self;
        //    [self presentViewController:qrcvc animated:YES completion:nil];
        [self.navigationController pushViewController:qrcvc animated:YES];
    }
}

- (void)loadFavouriteAction {
    _cm = [CacheManager sharedInstance];
    NSArray * paperList = [_cm getAllpaperFromDB];
    if (paperList != nil && paperList.count != 0) {
        _paperArray = [[NSMutableArray alloc]init];
        NSMutableArray * newPaperList = [[NSMutableArray alloc]init];
        for (int i = 0; i < paperList.count; i ++) {
            YTKKeyValueItem * paperItem = [paperList objectAtIndex:i];
            NSDictionary * paperDiction = paperItem.itemObject;
            NSDictionary * paperDictionary2 = [_cm accemblePaperFromDB:paperDiction];
            [newPaperList addObject:paperDictionary2];
        }
        NSMutableDictionary * newPaperDictionarys = [[NSMutableDictionary alloc]init];
        [newPaperDictionarys setObject:newPaperList forKey:@"paperList"];
        _paperArray = [[CacheManager sharedInstance]transformPaperDictionary:newPaperDictionarys];
//        [self initSearchController];
//        [self.tableView reloadData];
    }
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
                NSDictionary * paperDictionary2 = [_cm accemblePaperFromDB:paperDiction];
                [newPaperList addObject:paperDictionary2];
            }
        NSMutableDictionary * newPaperDictionarys = [[NSMutableDictionary alloc]init];
        [newPaperDictionarys setObject:newPaperList forKey:@"paperList"];
        _paperArray = [[CacheManager sharedInstance]transformPaperDictionary:newPaperDictionarys];
        [self initSearchController];
        [self.tableView reloadData];
    }else {
        [_mjRefreshHeader beginRefreshing];
        DTZSuccessBlock dtzSuccessBlock = ^ (NSDictionary * responseData) {
            NSLog(@"%@",responseData);
        };
        [_scManager getAllPaper:dtzSuccessBlock DTZFailBlock:nil];
    }
}

// 已经弃用
- (void)getAllPaperCallBack:(NSDictionary *)responseData {
    
}

#pragma mark - NotificationCallback

- (void)getAllPaperNotification {
    [_mjRefreshHeader endRefreshing];
    NSArray * paperList = [_cm getAllpaperFromDB];
    _paperArray = [[NSMutableArray alloc]init];
    NSMutableArray * newPaperList = [[NSMutableArray alloc]init];
    for (int i = 0; i < paperList.count; i ++) {
        YTKKeyValueItem * paperItem = [paperList objectAtIndex:i];
        NSDictionary * paperDiction = paperItem.itemObject;
        NSDictionary * paperDictionary2 = [_cm accemblePaperFromDB:paperDiction];
        [newPaperList addObject:paperDictionary2];
    }
    NSMutableDictionary * newPaperDictionarys = [[NSMutableDictionary alloc]init];
    [newPaperDictionarys setObject:newPaperList forKey:@"paperList"];
    _paperArray = [[CacheManager sharedInstance]transformPaperDictionary:newPaperDictionarys];
    [self initSearchController];
    [self.tableView reloadData];
}

@end
