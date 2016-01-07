//
//  SubcourseManager.h
//  SubCourse
//
//  Created by wuhaibin on 15/12/18.
//  Copyright © 2015年 wuhaibin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFHTTPRequestOperationManager.h>
#import "User.h"
#import "CacheManager.h"

@protocol SubcourseManagerDelegate <NSObject>

@optional

- (void)managerReture:(NSDictionary *)responseData;

- (void)getUserInfoCallBack:(NSDictionary *)responseData;

- (void)registerAccountCallBack:(NSDictionary *)responseData;

- (void)isNicknameExistCallBack:(NSDictionary *)responseData;

- (void)getAllPaperCallBack:(NSDictionary *)responseData;

- (void)getUpdatePaperCallBack:(NSDictionary *)responseData;

- (void)userLoginCallBack:(NSDictionary *)responseData;

- (void)changePassowrdCallBack:(NSDictionary *)responseData;

- (void)userLogoutCallBack:(NSDictionary *)responseData;

- (void)uploadAvatarSuccessCallBack:(NSDictionary *)responseData;

- (void)uploadAvatarFailCallBack:(NSDictionary *)responseData;

- (void)getQiNiuCallBack :(NSDictionary *)responseData;

- (void)updateUserInfoCallBack:(NSDictionary *)responseData;

- (void)addFavouriteCallBack:(NSDictionary *)responseData;

- (void)removeFavouriteCallBack:(NSDictionary *)responseData;

- (void)addQuizCallBack:(NSDictionary *)responseData;

- (void)removeQuizCallBack:(NSDictionary *)responseData;

- (void)getallFavouriteCallBack:(NSDictionary *)responseData;

- (void)getallQuizCallBack:(NSDictionary *)responseData;

@end

@interface SubcourseManager : NSObject

@property (strong, nonatomic) AFHTTPRequestOperationManager * networkingManager;

@property (strong, nonatomic) id<SubcourseManagerDelegate> delegate;

@property (strong, nonatomic) CacheManager * cManager;

+ (SubcourseManager *) sharedInstance;

- (id) init;

/*
 *判断学号是否存在
 */
- (void)registerAccount:(NSString *)nickName Password:(NSString *)password Code:(NSString *)code Phone:(NSString *)phone StudentNo:(NSString *)studentNo;

/*
 *判断学生学号是否存在
 */
- (void)isStudentNumExist:(NSString *)studentNum;

/*
 *获取个人信息 (params带上token，userId)
 */
- (User *)getUserInfo;

/*
 *判断昵称是否存在
 */
- (void)isNickNameExist;

/*
 *用户登出（需要带上token，userId）
 */
- (void)userLogout;

/*
 *更新个人信息
 */
- (void)updateUserInfo:(NSMutableDictionary *)userDictionary;

/*
 *改变用户的密码 需要的参数为新旧密码
 */
- (void)changePassword:(NSString *)oldPassword NewPassword:(NSString *)newPassword;

/*
 *用户登陆 参数为nickname和password
 */
- (void)userLogin:(NSString *)phoneNumber Password:(NSString *)password;

/*
 *获取七牛的token字段 上传图片使用
 */
//- (void)getQiNiuToken;

/*
 *获取全部试卷
 */
- (void)getAllPaper;

/*
 *获取指定标签页面，时间点后的更新的试卷的标签页面
 */
- (void)getUpdatePaper:(NSDictionary *)params;


/*
 *上传头像的avatarUrl
 */
- (void)uploadAvatarUrl:(NSString *)avatarUrl;

//GET /question/collections
/*
 *增加提问
 */
- (void)addquiz:(long)questionId;

/*
 *取消提问
 */
- (void)removequiz:(long)questionId;

/*
 *收藏题目
 */
- (void)addFavourite:(long)questionId;

/*
 *取消收藏
 */
- (void)removeFavourite:(long)questionId;

/*
 *获取所有收藏
 */
- (void)getAllFavourite;

/*
 *获取所有提问
 */
- (void)getAllQuiz;

/*
 *获取七牛的token字段 上传图片使用
 */
- (void)getQiNiuToken:(NSData *)imageData;

@end
