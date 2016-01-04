//
//  PaperChooseViewController.m
//  SubCourse
//
//  Created by wuhaibin on 15/12/24.
//  Copyright © 2015年 wuhaibin. All rights reserved.
//

#import "PaperChooseViewController.h"
#import "PageDetailCell.h"
#import "PartTitleCell.h"
#import "SubcourseManager.h"
#import "CacheManager.h"
#import "PaperModel.h"
#import "PartModel.h"
#import "QuestionModel.h"

@interface PaperChooseViewController ()<UITableViewDataSource,UITableViewDelegate,SubcourseManagerDelegate>{
    IBOutlet UITableView *_tableView;
    NSDictionary * _paperDictionary;
    NSArray * paperList;
    int _pageNum;
    IBOutlet UINavigationItem *_navigationItem;
}

@end

@implementation PaperChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];


}

- (void)viewWillAppear:(BOOL)animated {
    [self setTableView];
    self.view.backgroundColor = [UIColor colorWithRed:18.0/255 green:18.0/255 blue:18.0/255 alpha:1];
    self.title = _paperModel.title;
    UILabel * label = [[UILabel alloc]init];
    label.text = _paperModel.title;
    [label sizeToFit];
    label.textColor = [UIColor whiteColor];
    _navigationItem.titleView = label;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)clickBack:(id)sender {
    [self.delegate backToPageView:self.pageCount];
}

#pragma mark - tableView Delegate DataSource && settings

- (void)setTableView {
    _pageNum = 1;
    _tableView.backgroundColor = [UIColor colorWithRed:18.0/255 green:18.0/255 blue:18.0/255 alpha:1];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _navaigationBar.barTintColor = [UIColor colorWithRed:18.0/255 green:18.0/255 blue:18.0/255 alpha:1];
//    _navaigationBar.backgroundColor = [UIColor colorWithRed:18.0/255 green:18.0/255 blue:18.0/255 alpha:1];
    _navaigationBar.tintColor = [UIColor colorWithRed:18.0/255 green:18.0/255 blue:18.0/255 alpha:1];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.paperModel == nil) {
        return 0;
    }
    return self.paperModel.pmList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * certif = @"PageTitleCell";
    UINib * nib = [UINib nibWithNibName:@"PartTitleCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:@"PageTitleCell"];
    static NSString * certifPageCell = @"PageDetailCell";
    UINib * nib2 = [UINib nibWithNibName:@"PageDetailCell" bundle:nil];
    [tableView registerNib:nib2 forCellReuseIdentifier:@"PageDetailCell"];
    if (indexPath.row == 0) {
        PartTitleCell * partCell = [tableView dequeueReusableCellWithIdentifier:certif];
        if (indexPath.section == 0 && indexPath.row == 0) {
            _pageNum = 1;
        }
        if (partCell == nil) {
            partCell = [[PartTitleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:certif];
        }
        if (self.paperModel != nil) {
            PartModel * partModel = [self.paperModel.pmList objectAtIndex:indexPath.section];
            QuestionModel * questionModel = [partModel.qmList objectAtIndex:indexPath.row];
            partCell.partLabel.text = partModel.title;
        }
        [partCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return partCell;
    }else {
        if (indexPath.row != 0) {
            PageDetailCell * pageCell = [tableView dequeueReusableCellWithIdentifier:certifPageCell];
            if (pageCell == nil) {
                pageCell = [[PageDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:certifPageCell];
                pageCell.countLabel.text = [NSString stringWithFormat:@"第%d页",_pageNum];
            }
            PartModel * partModel = [self.paperModel.pmList objectAtIndex:indexPath.section];
            QuestionModel * questionModel = [partModel.qmList objectAtIndex:indexPath.row - 1];
            NSString * string = [NSString stringWithFormat:@"第%ld小题",(long)indexPath.row];
            pageCell.pageTitleLabel.text = string;
            _pageNum ++;
            return pageCell;
            }
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.paperModel == nil) {
        return 0;
    }
    PartModel * partModel = [self.paperModel.pmList objectAtIndex:section];
    return partModel.qmList.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return;
    }else {
        [self.delegate clickCategoryPage:indexPath];
    }
}


@end
