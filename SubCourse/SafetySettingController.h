//
//  SafetySettingController.h
//  SubCourse
//
//  Created by wuhaibin on 15/11/27.
//  Copyright © 2015年 wuhaibin. All rights reserved.
//

#import "SCRootViewController.h"

@interface SafetySettingController : SCRootViewController <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) UIImage * iconImage;

@property (strong, nonatomic) NSMutableArray * titleArray;

@end
