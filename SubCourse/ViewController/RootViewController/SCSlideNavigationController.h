//
//  SCSlideNavigationController.h
//  SubCourse
//
//  Created by wuhaibin on 15/11/27.
//  Copyright © 2015年 wuhaibin. All rights reserved.
//

#import "UMSlideNavigationController.h"

//@protocol slideNaivgationControllerDelegate <NSObject>
//
//@optional
//- (void)searchControllerRF;
//
//@end

@interface SCSlideNavigationController : UMSlideNavigationController

@property (strong, nonatomic) NSMutableArray * titleArray;

//@property (strong, nonatomic) id<slideNaivgationControllerDelegate> slideDelegate;

@end
