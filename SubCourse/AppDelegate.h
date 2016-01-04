//
//  AppDelegate.h
//  SubCourse
//
//  Created by wuhaibin on 15/11/26.
//  Copyright © 2015年 wuhaibin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMNavigationController.h"
#import "SCSlideNavigationController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong,nonatomic) SCSlideNavigationController * slideNavigator;
@property (strong, nonatomic) UMNavigationController * safetyNavigator;
@property (strong, nonatomic) UMNavigationController * sourceNavigator;
@property (strong, nonatomic) UMNavigationController * myFavouriteNavigator;
@property (strong, nonatomic) UMNavigationController * myQuestionNavigator;
@property (strong, nonatomic) UMNavigationController * myPasswordNavigator;
@property (strong, nonatomic) UMNavigationController * myAccountSettingNavigator;

- (void)startEntry ;

- (void) reStartEntry ;

- (void)showLoginView ;

@end

