//
//  SCDetailViewcontroller.h
//  SubCourse
//
//  Created by wuhaibin on 15/12/22.
//  Copyright © 2015年 wuhaibin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionModel.h"
#import "PaperModel.h"

@protocol SCDetailViewDelegate <NSObject>

- (void)slideValueChanged:(CGFloat)index;

- (void)presentToTableVC:(NSUInteger)currentPage;

@end

@interface SCDetailViewcontroller : UIViewController

@property BOOL isGreen;
@property CGFloat value;
@property CGFloat maxValue;
@property CGFloat minValue;
@property (strong, nonatomic) QuestionModel * questionModel;
@property (strong, nonatomic) id<SCDetailViewDelegate> delegate;
@property (strong, nonatomic) PaperModel * paperModel;
@property NSInteger firstPaperIndex;

@end
