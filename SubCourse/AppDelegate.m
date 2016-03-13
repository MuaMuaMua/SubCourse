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
//#import "WechatAuthSDK.h"
//#import "WXApi.h"
#define newPaperTablename @"newPaperTablename"
#define newQuestionTable @"questionTablename"
#define favouriteTabel @"favouriteTable"
#define newFavouriteListTable @"newFavouriteListTable"
#define WX_APP_ID @"wx2fdedcbd7e0d4624"
#define WX_APP_SECRET @"2219926324b576653cf3386ffeea046c"
#import "SettingVC.h"
#import "AboutCllassVC.h"


@interface AppDelegate () <SubcourseManagerDelegate>{
    SubcourseManager * _scManager;
    CacheManager * _cManager;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];//注册本地推送
//    [self getQiNiuToken];
//    [WXApi registerApp:WX_APP_ID];

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
                                                                     @"AboutCllassVC",@"SC://PasswordSetting",
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

//- (BOOL) application : (UIApplication *)application handleOpenURL:(nonnull NSURL *)url {
////    return [WXApi handleOpenURL:url delegate:self];
//    
////    SourceController *ccontroller =[[SourceController alloc] init];
////    return  [WXApi handleOpenURL:url delegate:ccontroller];
//}

//- (BOOL) application:(UIApplication *)application Url:(NSURL *)url String:(NSString *)string AnyObject:(id)annotation{
//    return [WXApi handleOpenURL:url delegate:self];
//}

//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
////    return [WXApi handleOpenURL:url delegate:self];
//}

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

//- (void) onReq:(BaseReq *)req{
//    
//}
//
//- (void) onResp:(BaseResp *)resp{
//    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
//    }else if(resp.errCode == 0){
//        NSString * code = [resp valueForKey:@"code"];
//        if (code != nil) {
//            NSString * s1 = @"https://api.weixin.qq.com/sns/oauth2/access_token?appid=";
//            s1 = [s1 stringByAppendingString:WX_APP_ID];
//            s1 = [s1 stringByAppendingString:@"&secret="];
//            s1 = [s1 stringByAppendingString:WX_APP_SECRET];
//            s1 = [s1 stringByAppendingString:@"&code="];
//            s1 = [s1 stringByAppendingString:code];
//            s1 = [s1 stringByAppendingString:@"&grant_type=authorization_code"];
//            NSURL * url = [NSURL URLWithString:s1];
//            
//            NSURLSessionTask * task = [[NSURLSession sharedSession]dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//                NSDictionary* value = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//                if (![value objectForKey:@"errcode"]) {
//                    NSString * access_token = [[value objectForKey:@"access_token"]string] ;;
//                    NSNumber  *expires_in = [NSNumber numberWithInteger:[[value objectForKey:@"expires_in"]integerValue]];
//                    NSString * openid = [[value objectForKey:@"openid"]string];
//                    NSDictionary * dictionary = [[NSDictionary alloc]init];
//                    [dictionary setValue:openid forKey:@"openid"];
//                    [dictionary setValue:access_token forKey:@"access_token"];
//                    [dictionary setValue:expires_in forKey:@"expires_in"];
//                    [[NSNotificationCenter defaultCenter]postNotificationName:@"Oauth2Back" object:nil userInfo:dictionary];
//                }
//            }];
//            [task resume];
//        }
//    }
//    
//}

@end
