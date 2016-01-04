//
//  SourceController.h
//  SubCourse
//
//  Created by wuhaibin on 15/11/27.
//  Copyright © 2015年 wuhaibin. All rights reserved.
//

#import "SCRootViewController.h"

@interface SourceController : SCRootViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchControllerDelegate,UISearchDisplayDelegate,UISearchResultsUpdating>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
// subject : 1  (语文)  subject : 2 (数学)  subject : 3 (英语)
@property NSInteger subject;
@property (strong, nonatomic) NSMutableArray * chapterArray;

@property (strong, nonatomic) UISearchController * searchController;

@property (strong, nonatomic) NSMutableArray * dataList;
@property (strong, nonatomic) NSMutableArray * searchList;

@end
