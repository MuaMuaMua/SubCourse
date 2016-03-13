//
//  SubcourseManager.m
//  SubCourse
//
//  Created by wuhaibin on 15/12/18.
//  Copyright © 2015年 wuhaibin. All rights reserved.
//

#import "SubcourseManager.h"
#import <AFNetworking/AFHTTPRequestOperation.h>
#import "User.h"
#import <Qiniu/QiniuSDK.h>
#import "CacheManager.h"
#import "MBProgressHUD+MJ.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"

#define url @"http://121.42.205.101:9000"
#define QiNiuDomain @"http://7xp8cz.com1.z0.glb.clouddn.com"
#define newPaperTablename @"newPaperTablename"
#define newQuestionTable @"questionTablename"
#define favouriteTabel @"favouriteTable"
#define newFavouriteListTable @"newFavouriteListTable"

@implementation SubcourseManager{
    AppDelegate * _appDelegate;
}

+ (SubcourseManager *)sharedInstance {
    static SubcourseManager * _instance = nil;
    @synchronized(self) {
        if (!_instance) {
            _instance = [[SubcourseManager alloc]init];
            _instance.cManager = [CacheManager sharedInstance];
            _instance.cManager.kvs = [[YTKKeyValueStore alloc]initDBWithName:@"SUBCOURSEDB"];
            _instance.networkingManager = [[AFHTTPRequestOperationManager alloc]init];
            _instance.networkingManager.responseSerializer = [[AFHTTPResponseSerializer alloc]init];
            _instance.networkingManager.requestSerializer.timeoutInterval = 20;
            return _instance;
        }
    }
    return _instance;
}

- (id)init {
    if (self = [super init]) {
    }
    return self;
}

//发送验证码
//
//request :   POST    /user/sendVerificationCode
//
//params  :   {phone : 手机号码}
//
//success :   {code : 200 , msg : 发送成功}
//
//error   :   {code : 413 , msg : 手机验证码发送失败}
- (void)sendVerificationCode:(NSString *)phone {
    NSString * urlString = @"/user/sendVerificationCode";
    urlString = [url stringByAppendingString:urlString];
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setObject:phone forKey:@"phone"];
    [self.networkingManager POST:urlString parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * responseData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",responseData);
        [[NSNotificationCenter defaultCenter]postNotificationName:@"sendVeritificationCode" object:nil];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"error !%@",error);
        NSDictionary * responseData = [NSJSONSerialization JSONObjectWithData:error options:NSJSONReadingMutableContainers error:nil];
    }];
}

//判断验证码
//
//request :   POST    /user/checkVerificationCode
//
//params  :   {phone : 手机号码 , code : 验证码}
//
//success :   {code : 200 , msg : 验证码正确}
//
//error   :   {code : 414 , msg : 验证码过期或无效}
- (void)checkVerificationCode:(NSString *)phone verifictionCode:(NSString *)code {
    NSString * urlString = @"/user/checkVerificationCode";
    urlString = [url stringByAppendingString:urlString];
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setObject:phone forKey:@"phone"];
    [params setObject:code forKey:@"code"];
    [self.networkingManager POST:urlString parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * responseData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",responseData);
        NSNumber * code = [responseData objectForKey:@"code"];
        if (code.longValue == 200) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"validateSuccess" object:nil];
        }else {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"validateFail" object:nil];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"error !%@",error);
        NSDictionary * responseData = [NSJSONSerialization JSONObjectWithData:error options:NSJSONReadingMutableContainers error:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"validateFail" object:nil];
    }];
}

//判断手机是否存在
//
//request :   GET     /user/isPhoneExist
//
//params  :   {phone : 手机号}
//
//success :   {code : 200 , msg : 电话存在}
//
//error   :   {code : 404 , msg : 电话不存在}
- (void)isPhoneExist :(NSString *)phone{
    NSString * urlString = @"/user/isPhoneExist";
    urlString = [url stringByAppendingString:urlString];
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setObject:phone forKey:@"phone"];
    [self.networkingManager POST:urlString parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * responseData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"rightPhone" object:nil];
        NSLog(@"%@",responseData);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"error !%@",error);
        [[NSNotificationCenter defaultCenter]postNotificationName:@"wrongPhone" object:nil];
    }];
}

/*
 *判断学生学号是否存在
 */
- (void)isStudentNumExist:(NSString *)studentNum {
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setObject:studentNum forKey:@"studentNo"];
    NSString * urlString = @"http://121.42.205.101:9000/user/isStudentNoExist";
    [self.networkingManager POST:urlString parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * responseData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",responseData);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"error !%@",error);
        NSDictionary * responseData = [NSJSONSerialization JSONObjectWithData:error options:NSJSONReadingMutableContainers error:nil];
    }];
}


/*
 *用户注册账号 需要的参数为nickname 和password
 */
- (void)registerAccount:(NSString *)nickName Password:(NSString *)password Code:(NSString *)code Phone:(NSString *)phone StudentNo:(NSString *)studentNo{
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setObject:nickName forKey:@"nickName"];
    [params setObject:password forKey:@"password"];
    [params setObject:code forKey:@"code"];
    [params setObject:phone forKey:@"phone"];
    [params setObject:studentNo forKey:@"studentNo"];
    NSString * urlString = [url stringByAppendingString:@"/user/register"];
    [self.networkingManager POST:urlString parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"成功回调 设置delegate");
        NSDictionary * responseData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",responseData);
        [self.delegate registerAccountCallBack:responseData];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"error 大兄弟");
        NSDictionary * responseData = [NSJSONSerialization JSONObjectWithData:error options:NSJSONReadingMutableContainers error:nil];
        
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"registerError" object:nil];
    }];
}

/*
 *判断昵称是否存在 参数为nickname
 */
- (void)isNickNameExist:(NSString *)nickName {
    NSString * urlString = @"/user/isNickNameExist";
    urlString = [url stringByAppendingString:urlString];
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setObject:nickName forKey:@"nickName"];
    [self.networkingManager GET:urlString parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * responseData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

/*
 *获取个人信息 (params带上token，userId)
 */
- (User *)getUserInfo{
    //初始化返回值 User 在回调中 再赋值
    User * user = [[User alloc]init];
    
    //组合url
    NSString * urlString = @"/user/updateUserInfo";
    urlString = [url stringByAppendingString:urlString];
    //获取系统存下的token 判断是否为空在做传输 一半在登录过后 直接保存在userdefault中.
    NSString * token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSString * userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setObject:token forKey:@"token"];
    [params setObject:userId forKey:@"userId"];
    [self.networkingManager GET:urlString parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * responseData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    return user;
}

/*
 *获取七牛的token字段 上传图片使用
 */
- (void)getQiNiuToken:(NSData *)imageData {
    NSString * urlString =  @"/qiniu/uptoken";
    urlString = [url stringByAppendingString:urlString];
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    NSString * token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSString * userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    [params setObject:token forKey:@"token"];
    [params setObject:userId forKey:@"userId"];
    [self.networkingManager GET:urlString parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * responseData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",responseData);
        [self saveQiNiuInfo:responseData ImageData:imageData];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)saveQiNiuInfo:(NSDictionary *)responseData ImageData:(NSData *)imageData{
    NSLog(@"%@",responseData);
    [[NSUserDefaults standardUserDefaults] setObject:[responseData objectForKey:@"upToken"] forKey:@"QiNiuToken"];
    
    NSString * key = [responseData objectForKey:@"key"];
    NSString * qiniuToken = [responseData objectForKey:@"upToken"];

    NSString * avatarUrl = [QiNiuDomain stringByAppendingString:[NSString stringWithFormat:@"//%@",key]];
    [[NSUserDefaults standardUserDefaults] setObject:avatarUrl forKey:@"avatar"];
    
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    [upManager putData:imageData key:key token:qiniuToken
              complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                  NSLog(@"%@", info);
                  if (info.statusCode == 200) {
                      [[NSNotificationCenter defaultCenter]postNotificationName:@"UploadAvatarUrl" object:nil];
                  }
                  NSLog(@"%@", resp);
              } option:nil];
}


/*
 *用户登陆 参数为nickname和password
 */
- (void)userLogin:(NSString *)phoneNumber Password:(NSString *)password {
    NSString * urlString = @"/user/login";
    urlString = [url stringByAppendingString:urlString];
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setObject:phoneNumber forKey:@"phone"];
    [params setObject:password forKey:@"password"];
    NSLog(@"%@",params);
    [self.networkingManager POST:urlString parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * responseData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",responseData);
        [self.delegate userLoginCallBack:responseData];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

//- (void)loginSuccess {
//    
//}

/*
 *用户登出（需要带上token，userId）
 */
- (void)userLogout {
    //获取系统的token 和userId
    NSString * urlString = @"/user/logout";
    urlString = [url stringByAppendingString:urlString];
    NSString * token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSString * userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setObject:token forKey:@"token"];
    [params setObject:userId forKey:@"userId"];
    [self.networkingManager GET:urlString parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * responseData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        [self.delegate userLogoutCallBack:responseData];
        
        [self logoutSetting];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
    }];
}

- (void)logoutSetting {
    [_cManager.kvs clearTable:newFavouriteListTable];
    [_cManager.kvs clearTable:newPaperTablename];
    [_cManager.kvs clearTable:newQuestionTable];
    [_cManager.kvs clearTable:favouriteTabel];
//    NSLog(@"%@",responseData);
    [MBProgressHUD showSuccess:@"注销成功"];
    NSString*appDomain = [[NSBundle mainBundle]bundleIdentifier];
    [[NSUserDefaults standardUserDefaults]removePersistentDomainForName:appDomain];
    _appDelegate = [[UIApplication sharedApplication]delegate];
    [_appDelegate showLoginView];
}

/*
 *改变用户的密码 需要的参数为新旧密码
 */
- (void)changePassword:(NSString *)oldPassword NewPassword:(NSString *)newPassword {
    NSString * urlString = @"/user/passwd";
   
    urlString = [url stringByAppendingString:urlString];
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    NSString * token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    NSString * userId = [[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
    
    [params setObject:oldPassword forKey:@"oldPass"];
    [params setObject:newPassword forKey:@"newPass"];
    [params setObject:token forKey:@"token"];
    [params setObject:userId forKey:@"userId"];
    [self.networkingManager POST:urlString parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * responseData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        [self.delegate changePassowrdCallBack:responseData];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

/*
 *更新用户信息 需要的参数为token，userId,avatar,school,major,clazz,realName,idCard,phone,email,address,nickname
 */
- (void)updateUserInfo:(NSMutableDictionary *)userDictionary {
    NSString * urlString = @"/user/updateUserInfo";
    urlString = [url stringByAppendingString:urlString];
    //封装好 字典内的参数 （user 类型）
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setObject:[userDictionary objectForKey:@"token"] forKey:@"token"];
    [params setObject:[userDictionary objectForKey:@"userId"] forKey:@"userId"];
    
    [params setObject:[userDictionary objectForKey:@"avatar"] forKey:@"avatar"];
    [params setObject:[userDictionary objectForKey:@"address"] forKey:@"address"];
    [params setObject:[userDictionary objectForKey:@"clazz"] forKey:@"clazz"];
    [params setObject:[userDictionary objectForKey:@"nickName"] forKey:@"nickName"];
    [params setObject:[userDictionary objectForKey:@"major"] forKey:@"major"];
    [params setObject:[userDictionary objectForKey:@"email"] forKey:@"email"];
    [params setObject:[userDictionary objectForKey:@"studentNo"] forKey:@"studentNo"];
    [params setObject:[userDictionary objectForKey:@"school"] forKey:@"school"];
    [params setObject:[userDictionary objectForKey:@"idCard"] forKey:@"idCard"];
    [params setObject:[userDictionary objectForKey:@"realName"] forKey:@"realName"];
    
    //更新用户信息
    [self.networkingManager POST:urlString parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * responseData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",responseData);
//        [self.delegate managerReture:responseData];
        [self.delegate updateUserInfoCallBack:responseData];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

/*
 *获取全部试卷
     request :   GET     /paper/list
     params  :   {}
     success :   {
     code : 200
     msg  : OK
     paperList : [paperModel 数组。  paper包含多个part,part包含多个quesion]
 }
 */
- (void)getAllPaper:(DTZSuccessBlock)dtzSuccessBlock DTZFailBlock:(DTZFailBlock)dtzFailBlock {
    NSString * urlString = @"/paper/list";
    urlString = [url stringByAppendingString:urlString];
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    NSString * token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    NSString * userId = [[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
    [params setObject:token forKey:@"token"];
    [params setObject:userId forKey:@"userId"];
    [self.networkingManager GET:urlString parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * responseData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        [[NSUserDefaults standardUserDefaults]setObject:[responseData objectForKey:@"synTime"] forKey:@"createTime"];
//        [self getAllFavourite];
        dtzSuccessBlock(responseData);
        _cManager = [CacheManager sharedInstance];
        [_cManager savePaperIntoDB:responseData];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [MBProgressHUD showError:@"加载失败，服务器崩溃"];
        NSLog(@"%@",error);
        NSLog(@"获取所有试卷失败");
    }];
}

/*
 *
 request :   GET     /paper/list
 params  :   { createTime : [Long] ， tag : [String，多个tag可用（,）号隔开] }
 success :   {
 code : 200
 msg  : OK
 paperList : [paperModel 数组。  paper包含多个part,part包含多个quesiong]
 }
 */
- (void)getUpdatePaper:(NSDictionary *)params {
    NSString * urlString = @"/paper/list";
//    NSDictionary * params = [[NSDictionary alloc]init];
    urlString = [url stringByAppendingString:urlString];
    
    [self.networkingManager GET:urlString parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}

/*
 *上传头像的avatarUrl
 */
- (void)uploadAvatarUrl:(NSString *)avatarUrl {
    NSString * urlString = @"/user/updateAvatar";
    urlString = [url stringByAppendingString:urlString];
    NSMutableDictionary * userInfo = [[NSMutableDictionary alloc]init];
    [userInfo setObject:avatarUrl forKey:@"avatar"];
    NSString * token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSString * userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    [userInfo setObject:token forKey:@"token"];
    [userInfo setObject:userId forKey:@"userId"];
    
    [self.networkingManager POST:urlString parameters:userInfo success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}

/*
request :   POST    /question/collect

params  :   {questionId : question的id}

success :   {
    code : 200
    msg  : OK
}

error   :
*/
- (void)addFavourite:(long)questionId DTZSuccessBlock:(DTZSuccessBlock)dtzSuccessBlock DTZFailBlock:(DTZFailBlock)dtzFailBlock {
    NSString * urlString = @"/question/collect";
    urlString = [url stringByAppendingString:urlString];
    NSString * token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    NSString * userId = [[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
//    questionId : question的id
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setObject:token forKey:@"token"];
    [params setObject:userId forKey:@"userId"];
    NSNumber * questionIdNumber = [NSNumber numberWithLong:questionId];
    [params setObject:questionIdNumber forKey:@"questionId"];
    [self.networkingManager POST:urlString parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * responseData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
//        NSNotificationCenter
//        [self.delegate addFavouriteCallBack:responseData];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadFavourite" object:nil];

    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

/*
 request :   POST    /question/removeCollect
 
 params  :   {questionId : question的id}
 
 success :   {
 code : 200
 msg  : OK
 }
 
 error   :- (void)addFavourite:(long)questionId DTZSuccessBlock:(DTZSuccessBlock)dtzSuccessBlock DTZFailBlock:(DTZFailBlock)dtzFailBlock; */
- (void)removeFavourite:(long)questionId DTZSuccessBlock:(DTZSuccessBlock)dtzSuccessBlock DTZFailBlock:(DTZFailBlock)dtzFailBlock{
    NSString * urlString = @"/question/removeCollect";
    urlString = [url stringByAppendingString:urlString];
    NSString * token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    NSString * userId = [[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
    NSMutableDictionary * userDictionary = [[NSMutableDictionary alloc]init];
    [userDictionary setObject:token forKey:@"token"];
    [userDictionary setObject:userId forKey:@"userId"];
    NSNumber * questionIdNumber = [NSNumber numberWithLong:questionId];
    [userDictionary setObject:questionIdNumber forKey:@"questionId"];
    [self.networkingManager POST:urlString parameters:userDictionary success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * responseData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        dtzSuccessBlock(responseData);
        [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadFavourite" object:nil];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//        dtzFailBlock(error);
    }];
}

/*
 request :   GET /question/collections
 
 params  :   {}
 
 success :   {
 code : 200
 msg  : OK
 {
 collections : list<CollectQuestionBean> : 在app/beans/CollectQuestionBean 可查看详情
 }
 }
 
 error   :
 */
- (void)getAllFavourite {
    NSString * urlString = @"/question/collections";
    urlString = [url stringByAppendingString:urlString];
    NSString * token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    NSString * userId = [[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
    NSMutableDictionary * userDictionary = [[NSMutableDictionary alloc]init];
    [userDictionary setObject:token forKey:@"token"];
    [userDictionary setObject:userId forKey:@"userId"];
    [self.networkingManager GET:urlString parameters:userDictionary success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * responseData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",responseData);
        
        [_cManager saveFavourite:responseData];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [MBProgressHUD showError:@"服务器故障"];
    }];
}

/*
request :   POST    /question/addquiz

params  :   {questionId : question的id}

success :   {
    code : 200
    msg  : OK
}

error   :
*/
- (void)addquiz:(int)questionId {
    NSString * urlString = @"/question/addquiz";
    urlString = [url stringByAppendingString:urlString];
    NSString * token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    NSString * userId = [[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
    NSMutableDictionary * userDictionary = [[NSMutableDictionary alloc]init];
    [userDictionary setObject:token forKey:@"token"];
    [userDictionary setObject:userId forKey:@"userId"];
    NSNumber * questionIdNumber = [NSNumber numberWithInt:questionId];
    [userDictionary setObject:questionIdNumber forKey:@"questionId"];
    
    [self.networkingManager POST:urlString parameters:userDictionary success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * responseData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"..");
        [self.delegate addQuizCallBack:responseData];
        
//        NSNotification
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}

/*
request :   POST    /question/removequiz

params  :   {questionId : question的id}

success :   {
    code : 200
}
 
error   :
*/
- (void)removequiz:(int)questionId {
    NSString * urlString = @"/question/removequiz";
    urlString = [url stringByAppendingString:urlString];
    NSString * token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    NSString * userId = [[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
    NSMutableDictionary * userDictionary = [[NSMutableDictionary alloc]init];
    [userDictionary setObject:token forKey:@"token"];
    [userDictionary setObject:userId forKey:@"userId"];
    NSNumber * questionIdNumber = [NSNumber numberWithInt:questionId];
    [userDictionary setObject:questionIdNumber forKey:@"questionId"];
    [self.networkingManager POST:urlString parameters:userDictionary success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * responseData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        [self.delegate removeQuizCallBack:responseData];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}

/*
request :   GET /question/quizs

params  :   {}

success :   {
    code : 200
    msg  : OK
    {
        quizs : list<CollectQuestionBean> : 在app/beans/CollectQuestionBean 可查看详情
    }
}

error   :
*/
- (void)getAllQuiz {
    NSString * urlString = @"/question/quizs";
    urlString = [url stringByAppendingString:urlString];
    NSString * token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    NSString * userId = [[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
    NSMutableDictionary * userDictionary = [[NSMutableDictionary alloc]init];
    [userDictionary setObject:token forKey:@"token"];
    [userDictionary setObject:userId forKey:@"userId"];
//    [userDictionary setObject:questionId forKey:@"questionId"];
    [self.networkingManager GET:urlString parameters:userDictionary success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * responseData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        [self.delegate getallQuizCallBack:responseData];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}

//获取指定标签，时间试卷
//
//request :   GET     /paper/getPaperAfter
//
//params  :   { createTime : [Long] ， tag : [String，多个tag可用（,）号隔开] }
//
//success :   {
//    code    : 200
//    msg     : OK
//    synTime : [Long]
//    paperList : [paperModel 数组。  paper包含多个part,part包含多个quesiong]
//}
//
//error   :
- (void)getNewPaper {
    NSString * urlString = @"/paper/getPaperAfter";
    urlString = [url stringByAppendingString:urlString];
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forKey:@"token"];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] forKey:@"userId"];
    NSNumber * createTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"createTime"];
    if (createTime != nil) {
        [params setObject:createTime forKey:@"createTime"];
    }

    [self.networkingManager GET:urlString parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * responseData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",responseData);
        [[NSUserDefaults standardUserDefaults]setObject:[responseData objectForKey:@"synTime"] forKey:@"createTime"];
        _cManager = [CacheManager sharedInstance];
        if ([responseData objectForKey:@""] != nil) {
            [_cManager savePaperIntoDB:responseData];
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshNewPaper" object:nil];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

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
- (void)paperScan:(NSString *)qrUrl {
    NSString * urlString = @"/paper/scan";
    urlString = [url stringByAppendingString:urlString];
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setObject:qrUrl forKey:@"url"];
    [self.networkingManager POST:urlString parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary * responseData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSNumber * code = [responseData objectForKey:@"code"];
        if (code.longValue == 200) {
        _cManager = [CacheManager sharedInstance];
        NSMutableDictionary * paperDictionary = [responseData objectForKey:@"paper"];
        [_cManager saveQRPaperIntoDB:paperDictionary];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

@end
