//
//  CacheManager.m
//  SubCourse
//
//  Created by wuhaibin on 15/12/19.
//  Copyright © 2015年 wuhaibin. All rights reserved.
//

#import "CacheManager.h"
#import "YTKKeyValueStore.h"
#import "User.h"
#import "PaperModel.h"
#import "PartModel.h"
#import "QuestionModel.h"

#define tablename @"SCBasicInfo"
#define paperTablename @"paperTable"

@implementation CacheManager{
    
}

+ (CacheManager *)sharedInstance {
    static CacheManager * _instance = nil;
    @synchronized(self) {
        _instance = [[CacheManager alloc]init];
        _instance.kvs = [[YTKKeyValueStore alloc]initDBWithName:@"SubCourse"];
        return _instance;
    }
    return _instance;
}

- (id)init {
    if (self = [super init]) {
    }
    return self;
}

- (NSString *)getStudentNo {
//    NSString * tableName = @"SCBasicInfo";
    [_kvs createTableWithName:tablename];
    NSString * studentNo = [_kvs getStringById:@"StudentNo" fromTable:tablename];
    return studentNo;
}

- (void)setStudent:(NSString *)studentNo {
    [_kvs createTableWithName:tablename];
    [_kvs putString:@"studentNo" withId:@"studentNo" intoTable:tablename];
}

/*
 *更新个人信息
 */
- (void)updateUserInfo:(User *)user {
    [_kvs createTableWithName:tablename];
    NSMutableDictionary * userDictionary = [[NSMutableDictionary alloc]init];
    [userDictionary setObject:user.avatar forKey:@"avatar"];
    [userDictionary setObject:user.clazz forKey:@"class"];
    [userDictionary setObject:user.email forKey:@"email"];
    [userDictionary setObject:user.major forKey:@"major"];
    [userDictionary setObject:user.token forKey:@"token"];
    [userDictionary setObject:user.studentNo forKey:@"studentNo"];
    [userDictionary setObject:user.password forKey:@"password"];
    [userDictionary setObject:user.realName forKey:@""];
    [userDictionary setObject:user.phone forKey:@"phone"];
    [userDictionary setObject:user.salt forKey:@"salt"];
    [userDictionary setObject:user.school forKey:@"school"];
    [userDictionary setObject:user.address forKey:@"address"];
    [_kvs putObject:userDictionary withId:@"userDictionary" intoTable:tablename];
}

/*
 *更改新旧密码
 */
- (void)changePassword:(NSString *)oldPassword NewPassword:(NSString *)newPassword {
    [_kvs createTableWithName:tablename];
    [_kvs putString:newPassword withId:@"password" intoTable:tablename];
}

/*
 *本地缓存登陆状态
 */
- (void)userLogin:(NSString *)nickName Password:(NSString *)password {
    //本地缓存登陆状态 。
    [[NSUserDefaults standardUserDefaults] setObject:nickName  forKey:@"nickname"];
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"password"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

/*
 *保存试卷信息
 */
- (void)savePaper:(NSDictionary *)paperDictionary {
    [_kvs createTableWithName:@"PaperTable"];
    [_kvs putObject:paperDictionary withId:@"paperDictionary" intoTable:@"PaperTable"];
}


/*
 *从数据库中获取试卷dictionarys
 */
- (NSDictionary *)getPaperDictionarys {
    [_kvs createTableWithName:paperTablename];
    NSDictionary *paperDictionarys = [_kvs getObjectById:@"paperDictionary" fromTable:paperTablename];
    if(paperDictionarys == nil){
        return nil;
    }
    return paperDictionarys;
}

/*
 *获取到的数据信息
 */
- (PaperModel *)transformPaperDictionary:(NSDictionary *)paperDictionarys Index:(NSInteger )index {
    PaperModel * paperModel = [[PaperModel alloc]init];
    NSArray * paperList  = [paperDictionarys objectForKey:@"paperList"];
    NSDictionary * paperDictionary = [paperList objectAtIndex:index];
    if (paperDictionary != nil) {
        NSArray * partModelList = [paperDictionary objectForKey:@"partModels"];
        paperModel.descri = [paperDictionary objectForKey:@"desc"];
        paperModel.isPublished = [paperDictionary objectForKey:@"isPublished"];
        paperModel.title = [paperDictionary objectForKey:@"title"];
        for (int j = 0; j < partModelList.count; j ++) {
            PartModel * partModel = [[PartModel alloc]init];
            partModel.qmList = [[NSMutableArray alloc]init];
            NSDictionary * partModelDictionary = [partModelList objectAtIndex:j];
            NSString * title = [partModelDictionary objectForKey:@"title"];
            NSString * desc = [partModelDictionary objectForKey:@"desc"];
            partModel.title = title;
            partModel.desc = desc;
            NSArray * partList = [partModelDictionary objectForKey:@"questionModels"];
            for (int k = 0; k < partList.count ; k++) {
                NSDictionary * questionDictionary = [partList objectAtIndex:k];
                QuestionModel * questionModel = [[QuestionModel alloc]init];
                questionModel.answer = [questionDictionary objectForKey:@"answer"];
                questionModel.questionModelId = [[questionDictionary objectForKey:@"id"] intValue];
                questionModel.question = [questionDictionary objectForKey:@"question"];
                questionModel.createTime = [questionDictionary objectForKey:@"createdTime"];
                questionModel.updatedTime = [questionDictionary objectForKey:@"updatedTime"];
                [partModel.qmList addObject:questionModel];
            }
            [paperModel.pmList addObject:partModel];
        }
    }
    return paperModel;
}

/*
 *将paperDictionary 的内容转化为paper数组形式 返回 (目录用这个)
 */
- (NSMutableArray *)transformPaperDictionary:(NSDictionary *)paperDictionarys {
    NSMutableArray * paperArray = [[NSMutableArray alloc]init];
    NSArray * paperList = [paperDictionarys objectForKey:@"paperList"];
    for(int i = 0; i< paperList.count; i ++) {
        PaperModel * paperModel = [[PaperModel alloc]init];
        paperModel.pmList = [[NSMutableArray alloc]init];
        NSDictionary * paperDictionary = [paperList objectAtIndex:i];
        if (paperDictionary != nil) {
            NSArray * partModelList = [paperDictionary objectForKey:@"partModels"];
            paperModel.descri = [paperDictionary objectForKey:@"desc"];
            paperModel.isPublished = [paperDictionary objectForKey:@"isPublished"];
            paperModel.title = [paperDictionary objectForKey:@"title"];
            for (int j = 0; j < partModelList.count; j ++) {
                PartModel * partModel = [[PartModel alloc]init];
                partModel.qmList = [[NSMutableArray alloc]init];
                NSDictionary * partModelDictionary = [partModelList objectAtIndex:j];
                NSString * title = [partModelDictionary objectForKey:@"title"];
                NSString * desc = [partModelDictionary objectForKey:@"desc"];
                partModel.title = title;
                partModel.desc = desc;
                NSArray * partList = [partModelDictionary objectForKey:@"questionModels"];
                for (int k = 0; k < partList.count ; k++) {
                    NSDictionary * questionDictionary = [partList objectAtIndex:k];
                    QuestionModel * questionModel = [[QuestionModel alloc]init];
                    questionModel.answer = [questionDictionary objectForKey:@"answer"];
                    NSNumber * qId = [questionDictionary objectForKey:@"id"];
                    questionModel.questionModelId = qId.longValue;
                    questionModel.question = [questionDictionary objectForKey:@"question"];
                    questionModel.createTime = [questionDictionary objectForKey:@"createdTime"];
                    questionModel.updatedTime = [questionDictionary objectForKey:@"updatedTime"];
                    [partModel.qmList addObject:questionModel];
                }
                [paperModel.pmList addObject:partModel];
            }
        }
        paperModel.qmList = [[NSMutableArray alloc]init];
        NSDictionary * paperDictionary2 = [paperList objectAtIndex:i];
        if (paperDictionary2 != nil) {
            NSArray * partModelList = [paperDictionary2 objectForKey:@"partModels"];
            paperModel.descri = [paperDictionary2 objectForKey:@"desc"];
            paperModel.isPublished = [paperDictionary2 objectForKey:@"isPublished"];
            paperModel.title = [paperDictionary2 objectForKey:@"title"];
            for (int j = 0; j < partModelList.count; j ++) {
                PartModel * partModel = [[PartModel alloc]init];
                partModel.qmList = [[NSMutableArray alloc]init];
                NSDictionary * partModelDictionary = [partModelList objectAtIndex:j];
                NSString * title = [partModelDictionary objectForKey:@"title"];
                NSString * desc = [partModelDictionary objectForKey:@"desc"];
                partModel.title = title;
                partModel.desc = desc;
                NSArray * partList = [partModelDictionary objectForKey:@"questionModels"];
                for (int k = 0; k < partList.count ; k++) {
                    NSDictionary * questionDictionary = [partList objectAtIndex:k];
                    QuestionModel * questionModel = [[QuestionModel alloc]init];
                    questionModel.answer = [questionDictionary objectForKey:@"answer"];
                    NSNumber * qId = [questionDictionary objectForKey:@"id"];
                    questionModel.questionModelId = qId.longValue;
                    questionModel.question = [questionDictionary objectForKey:@"question"];
                    questionModel.createTime = [questionDictionary objectForKey:@"createdTime"];
                    questionModel.updatedTime = [questionDictionary objectForKey:@"updatedTime"];
                    if ([[questionDictionary objectForKey:@"isFavourite"] isEqualToString:@"1"]) {
                        questionModel.isFavourite = YES;
                    }else {
                        questionModel.isFavourite = NO;
                    }
                    [paperModel.qmList addObject:questionModel];
                }
            }
        }
        [paperArray addObject:paperModel];
    }
    return paperArray;
}
/*
 *
 *将paperModel list 转化为基本数据对象保存到数据库中
 */
- (void)savePaperModelList:(NSMutableArray *)paperModelList {
    NSMutableDictionary * paperListDictionary = [[NSMutableDictionary alloc]init];
    NSMutableArray * paperArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < paperModelList.count ; i ++ ) {
        PaperModel * paperModel = [paperModelList objectAtIndex:i];
        NSMutableDictionary * paperDictionary = [[NSMutableDictionary alloc]init];
        [paperDictionary setObject:paperModel.descri forKey:@"desc"];
        [paperDictionary setObject:paperModel.isPublished forKey:@"idPublished"];
        [paperDictionary setObject:paperModel.title forKey:@"title"];
        NSMutableArray * partModelList = [[NSMutableArray alloc]init];
        NSMutableArray * questionModelList = [[NSMutableArray alloc]init];
        for (int j = 0; j < paperModel.pmList.count;  j ++) {
            PartModel * partModel = [paperModel.pmList objectAtIndex:j];
            NSMutableDictionary * partDictionary = [[NSMutableDictionary alloc]init];
            [partDictionary setObject:partModel.title forKey:@"title"];
            [partDictionary setObject:partModel.desc forKey:@"desc"];
            NSMutableArray * questionList =  [[NSMutableArray alloc]init];
            for (int k = 0; k < partModel.qmList.count; k ++) {
                QuestionModel * questionModel = [partModel.qmList objectAtIndex:k];
                NSMutableDictionary * questionDictionary = [[NSMutableDictionary alloc]init];
                [questionDictionary setObject:questionModel.question forKey:@"question"];
                [questionDictionary setObject:questionModel.answer forKey:@"answer"];
                NSNumber * qIdNumber = [NSNumber numberWithLong:questionModel.questionModelId];
                [questionDictionary setObject:qIdNumber forKey:@"id"];
                [questionList addObject:questionDictionary];
                if (questionModel.isFavourite) {
                    [questionDictionary setObject:@"1" forKey:@"isFavourite"];
                }else {
                    [questionDictionary setObject:@"0" forKey:@"isFavourite"];
                }
                [questionModelList addObject:questionDictionary];
            }
            [partDictionary setObject:questionList forKey:@"qmList"];
            [partModelList addObject:partDictionary];
        }
        [paperDictionary setObject:partModelList forKey:@"pmList"];
        [paperDictionary setObject:questionModelList forKey:@"qmList"];
        [paperArray addObject:paperDictionary];
    }
    [paperListDictionary setObject:paperArray forKey:@"paperList"];
    [_kvs createTableWithName:paperTablename];
    [_kvs putObject:paperListDictionary withId:@"paperListDictionary" intoTable:paperTablename];
}


/*
 *将paperDictionary 的内容转化为paper 里面只有题目没有part 部分 （根据题目收藏部分需求更改数据结构）
 */
//- (NSMutableArray *)transformPaperDictionaryToQuestionList:(NSDictionary *)paperDictionarys {
//    NSMutableArray * paperArray = [[NSMutableArray alloc]init];
//    NSArray * paperList = [paperDictionarys objectForKey:@"paperList"];
//    for (int i = 0; i < paperList.count; i ++ ) {
//        PaperModel * paperModel = [[PaperModel alloc]init];
//        paperModel.qmList = [[NSMutableArray alloc]init];
//        NSDictionary * paperDictionary = [paperList objectAtIndex:i];
//        if (paperDictionary != nil) {
//            NSArray * partModelList = [paperDictionary objectForKey:@"partModels"];
//            paperModel.descri = [paperDictionary objectForKey:@"desc"];
//            paperModel.isPublished = [paperDictionary objectForKey:@"isPublished"];
//            paperModel.title = [paperDictionary objectForKey:@"title"];
//            for (int j = 0; j < partModelList.count; j ++) {
//                PartModel * partModel = [[PartModel alloc]init];
//                partModel.qmList = [[NSMutableArray alloc]init];
//                NSDictionary * partModelDictionary = [partModelList objectAtIndex:j];
//                NSString * title = [partModelDictionary objectForKey:@"title"];
//                NSString * desc = [partModelDictionary objectForKey:@"desc"];
//                partModel.title = title;
//                partModel.desc = desc;
//                NSArray * partList = [partModelDictionary objectForKey:@"questionModels"];
//                for (int k = 0; k < partList.count ; k++) {
//                    NSDictionary * questionDictionary = [partList objectAtIndex:k];
//                    QuestionModel * questionModel = [[QuestionModel alloc]init];
//                    questionModel.answer = [questionDictionary objectForKey:@"answer"];
//                    NSNumber * qId = [questionDictionary objectForKey:@"id"];
//                    questionModel.questionModelId = qId.longValue;
//                    questionModel.question = [questionDictionary objectForKey:@"question"];
//                    questionModel.createTime = [questionDictionary objectForKey:@"createdTime"];
//                    questionModel.updatedTime = [questionDictionary objectForKey:@"updatedTime"];
//                    [paperModel.qmList addObject:questionModel];
//                }
//                [paperModel.pmList addObject:partModel];
//            }
//        }
//        [paperArray addObject:paperModel];
//    }
//    
//    return nil;
//}

/*
 *保存所有的收藏
 */
- (void)saveFavourite:(NSDictionary *)favouriteList {
    NSArray * collections = [favouriteList objectForKey:@"collections"];
    
    [_kvs createTableWithName:@"FavouriteTable"];
    [_kvs putObject:collections withId:@"FavouriteArray" intoTable:@"FavouriteTable"];
    
}

- (NSMutableArray *)getFavouriteFromDB {
    [_kvs createTableWithName:@"FavouriteTable"];
    NSMutableArray * collections = [_kvs getObjectById:@"FavouriteArray" fromTable:@"FavouriteTable"];
    return collections;
}

/*
 *将缓存中的favourite 转换成 array 的形式.
 */
- (NSMutableArray *)transformFavouriteArray:(NSMutableArray *)collections {
    NSMutableArray * collectionsArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < collections.count;  i ++) {
        NSMutableDictionary * questionDictionary = [collections objectAtIndex:i];
        QuestionModel * questionModel = [[QuestionModel alloc]init];
        questionModel.answer = [questionDictionary objectForKey:@"answer"];
        NSNumber * qId = [questionDictionary objectForKey:@"id"];
        questionModel.questionModelId = qId.longValue;
        questionModel.question = [questionDictionary objectForKey:@"question"];
        [collectionsArray addObject:questionModel];
    }
    return collectionsArray;
}

- (void)addFavouriteInDB:(int )firstIndex SecondIndex:(int)secondIndex IsFavourite:(BOOL)isFavourite{
    [_kvs createTableWithName:paperTablename];
//    [_kvs putObject:paperListDictionary withId:@"paperListDictionary" intoTable:paperTablename];
    NSMutableDictionary * paperListDictionary = [_kvs getObjectById:@"paperListDictionary" fromTable:paperTablename];
    
    NSMutableArray * paperArray = [paperListDictionary objectForKey:@"paperList"];
    NSMutableDictionary * paperDictionary = [paperArray objectAtIndex:firstIndex];
    NSMutableArray * qmList = [paperDictionary objectForKey:@"qmList"];
    NSMutableDictionary * questionDictionary = [qmList objectAtIndex:secondIndex];
    if (isFavourite) {
        [questionDictionary setObject:@"1" forKey:@"isFavourite"];
    }else {
        [questionDictionary setObject:@"0" forKey:@"isFavourite"];
    }
}


@end
