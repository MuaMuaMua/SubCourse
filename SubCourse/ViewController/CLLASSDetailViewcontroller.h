//
//  CLLASSDetailViewcontroller.h
//  SubCourse
//
//  Created by wuhaibin on 16/1/16.
//  Copyright © 2016年 wuhaibin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionModel.h"
#import "PaperModel.h"

@protocol CLLASSDetailViewcontroller <NSObject>


@optional

- (void)slideValueChanged:(CGFloat)index;

- (void)presentToTableVC:(NSUInteger)currentPage;

- (void)backToListVC;

@end

@interface CLLASSDetailViewcontroller : UIViewController

@property BOOL isGreen;
@property CGFloat value;
@property CGFloat maxValue;
@property CGFloat minValue;
@property (strong, nonatomic) QuestionModel * questionModel;
@property (strong, nonatomic) id<CLLASSDetailViewcontroller> delegate;
@property (strong, nonatomic) PaperModel * paperModel;
@property NSInteger firstPaperIndex;
@property BOOL isFavouriteListPaper;

@end
