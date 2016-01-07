//
//  AppDelegate.m
//  SubCourse
//
//  Created by wuhaibin on 15/11/26.
//  Copyright © 2015年 wuhaibin. All rights reserved.
//

#import "AppDelegate.h"
#import "MyFavouriteController.h"
#import "MyQuestionController.h"
#import "SourceController.h"
#import "SafetySettingController.h"
#import "PasswordSettingControllerViewController.h"
#import "LoginViewcontroller.h"
#import "SubcourseManager.h"
#import "CacheManager.h"

#define newPaperTablename @"newPaperTablename"
#define newQuestionTable @"questionTablename"
#define favouriteTabel @"favouriteTable"
#define newFavouriteListTable @"newFavouriteListTable"


@interface AppDelegate () <SubcourseManagerDelegate>{
    SubcourseManager * _scManager;
    CacheManager * _cManager;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];//注册本地推送
//    [self getQiNiuToken];
//    _cManager = [CacheManager sharedInstance];
//    
//    [_cManager.kvs clearTable:newFavouriteListTable];
//    [_cManager.kvs clearTable:newPaperTablename];
//    [_cManager.kvs clearTable:newQuestionTable];
//    [_cManager.kvs clearTable:favouriteTabel];
    
    NSString * phoneNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"];
    if (phoneNumber != nil && ![phoneNumber isEqualToString:@""]) {
        //判定之前是否登录了，登录过，在nsuserDefaults中保存登陆信息、token、phoneNumber、学号、昵称、信息
        [self startEntry];
    }else {
//         进入未登陆状态。
        [self showLoginView];
    }
    // Override point for customization after application launch.
    return YES;
}
//
//- (void)getQiNiuToken {
//    _scManager = [SubcourseManager sharedInstance];
//    _scManager.delegate = self;
//    [_scManager getQiNiuToken];
//}

//- (void)getQiNiuCallBack:(NSDictionary *)responseData {
//
//}

- (void)showLoginView {
    LoginViewcontroller * loginVC = [[LoginViewcontroller alloc]init];
    UINavigationController * navigator = [[UINavigationController alloc]initWithRootViewController:loginVC];
    self.window.rootViewController = navigator;
}

- (void) startEntry {
    [self initURLMapping];
    [self initSafeController];
    [self initSourceController];
//    [self initMyFavouriteController];
    [self initMyQuestionController];
//    [self initPasswordSettingController];
    [self initAccountSettingController];

    [self initSlideNavigator];
    self.window.rootViewController = self.slideNavigator;
}

- (void) reStartEntry {
    [self initURLMapping];
    [self initSafeController];
    [self initSourceController];
//    [self initMyFavouriteController];
    [self initMyQuestionController];
    [self initAccountSettingController];
    [self initSlideNavigator];
    self.window.rootViewController = self.slideNavigator;
}

- (void) initURLMapping {
    [[UMNavigationController config] setValuesForKeysWithDictionary:[[NSDictionary alloc] initWithObjectsAndKeys:
                                                                     @"SourceController", @"SC://Source",
                                                                     @"MyFavouriteController", @"SC://MyFavourite",
//                                                                     @"MyQuestionController",@"SC://MyQuestion",
                                                                     @"SafetySettingController", @"SC://Safe",
                                                                     @"PasswordSettingControllerViewController",@"SC://PasswordSetting",
                                                                     //还有一行是  注销的不同的section
                                                                    nil]];
}

- (void) initSlideNavigator {
    self.slideNavigator = nil;
    self.slideNavigator = [[SCSlideNavigationController alloc] initWithItems:@[@[self.sourceNavigator,self.myFavouriteNavigator,self.myAccountSettingNavigator,self.safetyNavigator]]];
}

- (void) initSafeController {
    self.safetyNavigator = [[UMNavigationController alloc] initWithRootViewControllerURL:[[NSURL URLWithString:@"SC://Safe"]
                                                                                        addParams:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                                   @"安全设置", @"title",
                                                                                                   @"sss", @"list",
                                                                                                   nil]]];
    self.safetyNavigator.title = @"安全设置";
}

- (void) initMyQuestionController {
    self.myFavouriteNavigator = [[UMNavigationController alloc] initWithRootViewControllerURL:[[NSURL URLWithString:@"SC://MyFavourite"]
                                                                                          addParams:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                                     @"我的收藏", @"title",
                                                                                                     @"sss", @"list",
                                                                                                     nil]]];
    self.myFavouriteNavigator.title = @"我的收藏";
}

//- (void) initMyFavouriteController{
//    self.myQuestionNavigator = [[UMNavigationController alloc] initWithRootViewControllerURL:[[NSURL URLWithString:@"SC://MyQuestion"]
//                                                                                               addParams:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                                                                          @"我的提问", @"title",
//                                                                                                          @"sss", @"list",
//                                                                                                          nil]]];
//    self.myQuestionNavigator.title = @"我的提问";
//}

- (void) initSourceController {
    self.sourceNavigator = [[UMNavigationController alloc] initWithRootViewControllerURL:[[NSURL URLWithString:@"SC://Source"]
                                                                                               addParams:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                                          @"资料库", @"title",
                                                                                                          @"sss", @"list",
                                                                                                          nil]]];
    self.myFavouriteNavigator.title = @"资料库";
}

- (void)initPasswordSettingController{
    self.myPasswordNavigator = [[UMNavigationController alloc] initWithRootViewControllerURL:[[NSURL URLWithString:@"SC://PasswordSetting"]
                                                                                              addParams:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                                         @"安全设置", @"title",
                                                                                                         @"sss", @"list",
                                                                                                         nil]]];
    self.myPasswordNavigator.title = @"安全设置";
}

- (void)initAccountSettingController {
    self.myAccountSettingNavigator = [[UMNavigationController alloc] initWithRootViewControllerURL:[[NSURL URLWithString:@"SC://PasswordSetting"]
                                                                                                  addParams:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                                             @"设  置", @"title",
                                                                                                             @"sss", @"list",
                                                                                                             nil]]];
    self.myAccountSettingNavigator.title = @"设 置";
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
