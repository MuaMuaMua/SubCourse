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

@interface MyFavouriteController ()<UITableViewDataSource,UITableViewDelegate,SubcourseManagerDelegate> {
    IBOutlet UITableView * _tableView;
    SubcourseManager * _scManager;
    CacheManager * _cManager;
    NSMutableArray * _favouriteArray;
}

@end

@implementation MyFavouriteController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubcourseManager];

    [self initscManager];
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
    _favouriteArray = [[NSMutableArray alloc]init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
}

- (void)initscManager {
    _scManager = [SubcourseManager sharedInstance];
    _scManager.delegate = self;
    [_scManager getAllFavourite];
}

- (void)getallFavouriteCallBack:(NSDictionary *)responseData {
    NSLog(@"%@",responseData);
    //缓存到数据库中
    NSArray * collections = [responseData objectForKey:@"collections"];
    for (int i = 0; i < collections.count; i ++) {
        NSDictionary * collection = [collections objectAtIndex:i];
    }
    [_cManager saveFavourite:responseData];
    _favouriteArray = [_cManager getFavouriteFromDB];
    [_tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UINib * nib = [UINib nibWithNibName:@"FandQCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:@"FandQCell"];
    FandQCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FandQCell"];
    if (cell == nil) {
        cell = [[FandQCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FandQCell"];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _favouriteArray.count;
}

@end
