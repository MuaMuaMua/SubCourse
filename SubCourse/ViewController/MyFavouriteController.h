//
//  MyFavouriteController.h
//  SubCourse
//
//  Created by wuhaibin on 15/11/27.
//  Copyright © 2015年 wuhaibin. All rights reserved.
//

#import "SCRootViewController.h"

@interface MyFavouriteController : SCRootViewController

@property (strong, nonatomic) NSMutableArray *  favouriteArray;
@property (strong, nonatomic) NSMutableArray * chapterArray;
@property (strong, nonatomic) UISearchController * searchController;
@property (strong, nonatomic) NSMutableArray * dataList;
@property (strong, nonatomic) NSMutableArray * searchList;
@property (strong, nonatomic) NSMutableArray * chapterNewList;
@property (strong, nonatomic) NSMutableArray * paperNewList;
@property BOOL isSearchbarFirstResponder;
@property BOOL isCancelClick;

@end
