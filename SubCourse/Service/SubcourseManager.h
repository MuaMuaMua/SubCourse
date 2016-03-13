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

typedef void (^ DTZSuccessBlock)(NSDictionary * successBlock);

typedef void (^ DTZFailBlock)(NSDictionary * failBlock);

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
- (void)getAllPaper:(DTZSuccessBlock)dtzSuccessBlock DTZFailBlock:(DTZFailBlock)dtzFailBlock;

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
- (void)addFavourite:(long)questionId DTZSuccessBlock:(DTZSuccessBlock)dtzSuccessBlock DTZFailBlock:(DTZFailBlock)dtzFailBlock;

/*
 *取消收藏
 */
- (void)removeFavourite:(long)questionId DTZSuccessBlock:(DTZSuccessBlock)dtzSuccessBlock DTZFailBlock:(DTZFailBlock)dtzFailBlock;

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

/*
 *获取新的Paper
 */
- (void)getNewPaper;

//发送验证码
//
//request :   POST    /user/sendVerificationCode
//
//params  :   {phone : 手机号码}
//
//success :   {code : 200 , msg : 发送成功}
//
//error   :   {code : 413 , msg : 手机验证码发送失败}
- (void)sendVerificationCode:(NSString *)phone;

//判断验证码
//
//request :   POST    /user/checkVerificationCode
//
//params  :   {phone : 手机号码 , code : 验证码}
//
//success :   {code : 200 , msg : 验证码正确}
//
//error   :   {code : 414 , msg : 验证码过期或无效}
- (void)checkVerificationCode:(NSString *)phone verifictionCode:(NSString *)code;

//判断手机是否存在
//
//request :   GET     /user/isPhoneExist
//
//params  :   {phone : 手机号}
//
//success :   {code : 200 , msg : 电话存在}
//
//error   :   {code : 404 , msg : 电话不存在}
- (void)isPhoneExist :(NSString *)phone;

//request :   POST    /paper/scan
//
//params  :   {url : [url]}
//
//success :   {
//    code : 200
//    msg  : {paper : [paperModel]}
//}
//
//error   :
- (void)paperScan:(NSString *)qrUrl;

@end
