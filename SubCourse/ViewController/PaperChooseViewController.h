//
//  PaperChooseViewController.h
//  SubCourse
//
//  Created by wuhaibin on 15/12/24.
//  Copyright © 2015年 wuhaibin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaperModel.h"
#import "PartModel.h"

@protocol PaperChooseDelegate <NSObject>

- (void)backToPageView:(NSUInteger )pageCount;

- (void)clickCategoryPage:(NSIndexPath *)indexPath;

@end

@interface PaperChooseViewController : UIViewController

@property (strong, nonatomic) IBOutlet UINavigationBar *navaigationBar;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *continueBtn;

@property (strong, nonatomic) IBOutlet UINavigationBar *titleLabel;

@property NSUInteger pageCount;

@property (strong, nonatomic) id<PaperChooseDelegate> delegate;

@property (strong, nonatomic) PaperModel * paperModel;

@end
