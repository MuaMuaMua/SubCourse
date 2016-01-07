//
//  CacheManager.h
//  SubCourse
//
//  Created by wuhaibin on 15/12/19.
//  Copyright © 2015年 wuhaibin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTKKeyValueStore.h"
#import "User.h"
#import "PaperModel.h"
#import "QuestionModel.h"


@interface CacheManager : NSObject

@property (strong, nonatomic) YTKKeyValueStore * kvs;

+ (CacheManager *) sharedInstance;

- (id) init;

/*
 *改变用户的密码 需要的参数为新旧密码
 */
- (void)changePassword:(NSString *)oldPassword NewPassword:(NSString *)newPassword;

/*
 *更新个人信息
 */
- (void)updateUserInfo:(User *)user;

/*
 *用户登陆 参数为nickname和password
 */
- (void)userLogin:(NSString *)nickName Password:(NSString *)password;

/*
 *将paperDictionarys获取index 解析成paper类型。
 */
//- (PaperModel *)transformPaperDictionary:(NSDictionary *)paperDictionarys Index:(NSInteger )index;

/*
 *从数据库中获取试卷dictionarys
 */
- (NSDictionary *)getPaperDictionarys;

/*
 *保存试卷信息
 */
- (void)savePaper:(NSDictionary *)paperDictionary;

/*
 *将paperDictionary 的内容转化为paper数组形式 返回
 */
- (NSMutableArray *)transformPaperDictionary:(NSDictionary *)paperDictionarys;

/*
 *保存所有的收藏
 */
- (void)saveFavourite:(NSDictionary *)favouriteList;

/*
 *获取所有收藏
 */
- (NSMutableArray *)getFavouriteFromDB;

/*
 *
 *将paperModel list 转化为基本数据对象保存到数据库中
 */
- (void)savePaperModelList:(NSMutableArray *)paperModelList;

/*
 *添加收藏
 */
- (void)addFavouriteInDB:(int )firstIndex SecondIndex:(int)secondIndex IsFavourite:(BOOL)isFavourite ;

/*
 *将paperDictionary 的内容转化为paper数组形式 返回 (目录用这个)
 */
- (NSMutableArray *)transformPaperDictionary2:(NSDictionary *)paperDictionarys;

/*
 *
 */
- (void)savePaperIntoDB:(NSDictionary *)paperDictionary;

- (NSArray *)getAllpaperFromDB ;

- (NSDictionary *)accemblePaperFromDB:(NSDictionary *)paperDictionary; 

- (void)addfavouriteData:(QuestionModel * )questionModel IsFavourite:(BOOL)isFavourite;

- (PaperModel *)getAllFavouriteListFromDB:(NSArray * )paperList;

- (PaperModel *)getFavouriteInFavouriteTable ;

@end
