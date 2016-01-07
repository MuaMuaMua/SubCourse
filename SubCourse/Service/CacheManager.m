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

#define newPaperTablename @"newPaperTablename"
#define newQuestionTable @"questionTablename"
#define favouriteTabel @"favouriteTable"
#define newFavouriteListTable @"newFavouriteListTable"
//_instance.kvs = [[YTKKeyValueStore alloc]initDBWithName:@"SubCourse"];

//#define


@implementation CacheManager{
    
}

+ (CacheManager *)sharedInstance {
    static CacheManager * _instance = nil;
    @synchronized(self) {
        _instance = [[CacheManager alloc]init];
        _instance.kvs = [[YTKKeyValueStore alloc]initDBWithName:@"SUBCOURSEDB"];
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
    _kvs = [[YTKKeyValueStore alloc]initDBWithName:@"SUBCOURSEDB"];
    [_kvs createTableWithName:tablename];
    NSString * studentNo = [_kvs getStringById:@"StudentNo" fromTable:tablename];
    return studentNo;
}

- (void)setStudent:(NSString *)studentNo {
    _kvs = [[YTKKeyValueStore alloc]initDBWithName:@"SUBCOURSEDB"];
    [_kvs createTableWithName:tablename];
    [_kvs putString:@"studentNo" withId:@"studentNo" intoTable:tablename];
}

/*
 *更新个人信息
 */
- (void)updateUserInfo:(User *)user {
    _kvs = [[YTKKeyValueStore alloc]initDBWithName:@"SUBCOURSEDB"];
    [_kvs createTableWithName:tablename];
    NSMutableDictionary * userDictionary = [[NSMutableDictionary alloc]init];
    [userDictionary setObject:user.avatar forKey:@"avatar"];
    [userDictionary setObject:user.clazz forKey:@"class"];
    [userDictionary setObject:user.email forKey:@"email"];
    [userDictionary setObject:user.major forKey:@"major"];
    [userDictionary setObject:user.token forKey:@"token"];
    [userDictionary setObject:user.studentNo forKey:@"studentNo"];
    [userDictionary setObject:user.password forKey:@"password"];
    [userDictionary setObject:user.realName forKey:@"realName"];
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
    _kvs = [[YTKKeyValueStore alloc]initDBWithName:@"SUBCOURSEDB"];
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
- (void)savePaper:(NSMutableDictionary *)paperDictionary {
    _kvs = [[YTKKeyValueStore alloc]initDBWithName:@"SUBCOURSEDB"];
    [_kvs createTableWithName:paperTablename];
    [_kvs putObject:paperDictionary withId:@"paperDictionary" intoTable:paperTablename];
    [_kvs close];
}


/*
 *从数据库中获取试卷dictionarys
 */
- (NSMutableDictionary *)getPaperDictionarys {
    _kvs = [[YTKKeyValueStore alloc]initDBWithName:@"SUBCOURSEDB"];
    [_kvs createTableWithName:paperTablename];
    NSMutableDictionary *paperDictionarys = [_kvs getObjectById:@"paperDictionary" fromTable:paperTablename];
    if(paperDictionarys == nil){
        return nil;
    }
    [_kvs close];
    return paperDictionarys;
}

/*
 *获取到的数据信息
 */
- (PaperModel *)transformPaperDictionary:(NSDictionary *)paperDictionarys Index:(NSInteger )index {
    PaperModel * paperModel = [[PaperModel alloc]init];
    NSMutableArray * paperList  = [paperDictionarys objectForKey:@"paperList"];
    NSDictionary * paperDictionary = [paperList objectAtIndex:index];
    if (paperDictionary != nil) {
        NSArray * partModelList = [paperDictionary objectForKey:@"partModels"];
        paperModel.descri = [paperDictionary objectForKey:@"desc"];
//        paperModel.isPublished = [paperDictionary objectForKey:@"isPublished"];
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
        paperModel.qmList = [[NSMutableArray alloc]init];
        NSDictionary * paperDictionary = [paperList objectAtIndex:i];
        paperModel.title = [paperDictionary objectForKey:@"title"];
        if (paperDictionary != nil) {
            NSArray * partModelList = [paperDictionary objectForKey:@"partModels"];
            paperModel.descri = [paperDictionary objectForKey:@"desc"];
//            paperModel.isPublished = [paperDictionary objectForKey:@"isPublished"];
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
                    if ([[questionDictionary objectForKey:@"isFavourite"]isEqualToString:@"1"]) {
                        questionModel.isFavourite = YES;
                    }else {
                        questionModel.isFavourite = NO;
                    }
                    questionModel.createTime = [questionDictionary objectForKey:@"createdTime"];
                    questionModel.updatedTime = [questionDictionary objectForKey:@"updatedTime"];
                    [partModel.qmList addObject:questionModel];
//                    [paperModel.qmList addObject:questionModel];
                }
                [paperModel.pmList addObject:partModel];
            }
            NSArray * questionList = [paperDictionary objectForKey:@"questionModels"];
            if (questionList.count == 0) {
                NSArray * partModelList = [paperDictionary objectForKey:@"partModels"];
                paperModel.descri = [paperDictionary objectForKey:@"desc"];
                //            paperModel.isPublished = [paperDictionary objectForKey:@"isPublished"];
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
                        if ([[questionDictionary objectForKey:@"isFavourite"]isEqualToString:@"1"]) {
                            questionModel.isFavourite = YES;
                        }else {
                            questionModel.isFavourite = NO;
                        }
                        questionModel.createTime = [questionDictionary objectForKey:@"createdTime"];
                        questionModel.updatedTime = [questionDictionary objectForKey:@"updatedTime"];
                        [paperModel.qmList addObject:questionModel];
//                        [partModel.qmList addObject:questionModel];
                        //                    [paperModel.qmList addObject:questionModel];
                    }
//                    [paperModel.pmList addObject:partModel];
                }
            }else {
                for ( int k = 0; k < questionList.count; k ++ ) {
                    NSDictionary * questionDictionary = [questionList objectAtIndex:k];
                    QuestionModel * questionModel = [[QuestionModel alloc]init];
                    questionModel.answer = [questionDictionary objectForKey:@"answer"];
                    questionModel.question = [questionDictionary objectForKey:@"question"];
                    NSNumber * qId = [questionDictionary objectForKey:@"id"];
                    questionModel.questionModelId = qId.longValue;
                    NSString * isFavourite = [questionDictionary objectForKey:@"isFavourite"];
                    
                    if ([isFavourite isEqualToString:@"1"]) {
                        questionModel.isFavourite = YES;
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
 *保存所有的收藏
 */
- (void)saveFavourite:(NSDictionary *)favouriteList {
    NSMutableArray * collections = [favouriteList objectForKey:@"collections"];
//    NSArray * collections = favouriteList;
    _kvs = [[YTKKeyValueStore alloc]initDBWithName:@"SUBCOURSEDB"];
    [_kvs createTableWithName:favouriteTabel];
    [_kvs putObject:collections withId:@"FavouriteArray" intoTable:favouriteTabel];
    
//    [_kvs createTableWithName:newFavouriteListTable];
    NSMutableArray * fList = [[NSMutableArray alloc]init];
    for (int i = 0; i < collections .count; i ++) {
        NSDictionary * paperDictionary = [collections objectAtIndex:i];
        NSMutableArray * questionModels = [paperDictionary objectForKey:@"questionModels"];
        for (int j = 0; j < questionModels.count; j ++) {
            NSMutableDictionary * questionDictionary = [[NSMutableDictionary alloc]initWithDictionary:[questionModels objectAtIndex:j]];
            [questionDictionary setObject:[paperDictionary objectForKey:@"title"] forKey:@"paperTitle"];
//            favouriteList
            [fList addObject:questionDictionary];
        }
    }
    [_kvs close];
    [self saveFavouriteInFavouriteTable:fList];
}

- (NSMutableArray *)getFavouriteFromDB {
    _kvs = [[YTKKeyValueStore alloc]initDBWithName:@"SUBCOURSEDB"];

    [_kvs createTableWithName:favouriteTabel];
    NSMutableArray * collections = [_kvs getObjectById:@"FavouriteArray" fromTable:favouriteTabel];
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

- (void)addfavouriteData:(QuestionModel * )questionModel IsFavourite:(BOOL)isFavourite{
    _kvs = [[YTKKeyValueStore alloc]initDBWithName:@"SUBCOURSEDB"];
    [_kvs createTableWithName:newQuestionTable];
    [_kvs createTableWithName:newFavouriteListTable];
    NSNumber * questionNumber = [NSNumber numberWithLong:questionModel.questionModelId];
    NSString * questionidString = [NSString stringWithFormat:@"%d",questionNumber.intValue];
    NSDictionary * questionDictionary = [_kvs getObjectById:questionidString fromTable:newQuestionTable];
    NSMutableDictionary * newQuestionary = [[NSMutableDictionary alloc]initWithDictionary:questionDictionary];
    if (questionModel.paperTitle != nil) {
        [newQuestionary setObject:questionModel.paperTitle forKey:@"paperTitle"];
    }
    if(isFavourite){
        [newQuestionary setObject:@"1" forKey:@"isFavourite"];
        [_kvs putObject:newQuestionary withId:questionidString intoTable:newFavouriteListTable];
    }else {
        [newQuestionary setObject:@"0" forKey:@"isFavourite"];
        [_kvs deleteObjectById:questionidString fromTable:newFavouriteListTable];
    }
    [_kvs deleteObjectById:questionidString fromTable:newQuestionTable];
    [_kvs putObject:newQuestionary withId:questionidString intoTable:newQuestionTable];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadFavouriteTableView" object:nil];
//    [_kvs close];

}


- (void)savePaperIntoDB:(NSDictionary *)paperDictionary {
    _kvs = [[YTKKeyValueStore alloc]initDBWithName:@"SUBCOURSEDB"];
    [_kvs createTableWithName:newPaperTablename];

    NSArray * paperList = [paperDictionary objectForKey:@"paperList"];
    for (int i = 0; i < paperList.count; i ++) {
        NSMutableDictionary * paperDictionary = [NSMutableDictionary dictionaryWithDictionary:[paperList objectAtIndex:i]];
        NSMutableArray * partList = [paperDictionary objectForKey:@"partModels"];
        NSMutableArray * questionArray = [[NSMutableArray alloc]init];
        for (int j = 0; j < partList.count; j ++) {
            NSDictionary * partDictionary = [partList objectAtIndex:j];
            NSMutableArray * questionList = [partDictionary objectForKey:@"questionModels"];
            for (int k = 0; k < questionList.count ; k ++) {
                NSMutableDictionary * questionDictionary = [[NSMutableDictionary alloc]initWithDictionary:[questionList objectAtIndex:k]];
                [questionDictionary setObject:[paperDictionary objectForKey:@"id"] forKey:@"paperId"];
                NSNumber * questionIDNumber = [questionDictionary objectForKey:@"id"];
                NSString * questionIdString = [NSString stringWithFormat:@"%d",questionIDNumber.intValue];
                [questionArray addObject:questionDictionary];
                [_kvs putObject:questionDictionary withId:questionIdString intoTable:newQuestionTable];
            }
        }
        [paperDictionary setObject:questionArray forKey:@"questionModels"];
        NSString * paperId = [NSString stringWithFormat:@"%ld",(long)[paperDictionary objectForKey:@"id"]];
        [_kvs putObject:paperDictionary withId:paperId intoTable:newPaperTablename];
    }
    [_kvs close];

    _kvs = [[YTKKeyValueStore alloc]initDBWithName:@"SUBCOURSEDB"];
    [_kvs createTableWithName:newQuestionTable];
    NSArray * paperList2 = [paperDictionary objectForKey:@"paperList"];
    for (int i = 0; i < paperList2.count; i ++) {
        NSMutableDictionary * paperDictionary = [NSMutableDictionary dictionaryWithDictionary:[paperList2 objectAtIndex:i]];
        NSMutableArray * partList2 = [paperDictionary objectForKey:@"partModels"];
        NSMutableArray * questionArray = [[NSMutableArray alloc]init];
        for (int j = 0; j < partList2.count; j ++) {
            NSDictionary * partDictionary = [partList2 objectAtIndex:j];
            NSMutableArray * questionList = [partDictionary objectForKey:@"questionModels"];
            for (int k = 0; k < questionList.count ; k ++) {
                NSMutableDictionary * questionDictionary = [[NSMutableDictionary alloc]initWithDictionary:[questionList objectAtIndex:k]];
                [questionDictionary setObject:[paperDictionary objectForKey:@"id"] forKey:@"paperId"];
                NSNumber * questionIDNumber = [questionDictionary objectForKey:@"id"];
                NSString * questionIdString = [NSString stringWithFormat:@"%d",questionIDNumber.intValue];
                [questionArray addObject:questionDictionary];
                [_kvs putObject:questionDictionary withId:questionIdString intoTable:newQuestionTable];
            }
        }
        [paperDictionary setObject:questionArray forKey:@"questionModels"];
        NSString * paperId = [NSString stringWithFormat:@"%ld",(long)[paperDictionary objectForKey:@"id"]];
//        [_kvs putObject:paperDictionary withId:paperId intoTable:newPaperTablename];
    }
    [_kvs close];

    [[NSNotificationCenter defaultCenter]postNotificationName:@"getAllPaperNotification" object:nil];
//    [_kvs close];
}

- (NSDictionary *)accemblePaperFromDB:(NSDictionary *)paperDictionary {
    _kvs = [[YTKKeyValueStore alloc]initDBWithName:@"SUBCOURSEDB"];
    [_kvs createTableWithName:newQuestionTable];

    NSMutableDictionary * newPaperDictionary = [[NSMutableDictionary alloc]init];
    [newPaperDictionary setObject:[paperDictionary objectForKey:@"partModels"] forKey:@"partModels"];
    [newPaperDictionary setObject:[paperDictionary objectForKey:@"desc"] forKey:@"desc"];
    [newPaperDictionary setObject:[paperDictionary objectForKey:@"id"] forKey:@"id"];
    [newPaperDictionary setObject:[paperDictionary objectForKey:@"title"] forKey:@"title"];
    NSMutableArray * questionModels = [paperDictionary objectForKey:@"questionModels"];
    NSMutableArray * newQuestionArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < questionModels.count; i ++) {
        NSDictionary * questionDictionary = [questionModels objectAtIndex:i];
        NSNumber * questionID = [questionDictionary objectForKey:@"id"];
        NSString * questionIdString = [NSString stringWithFormat:@"%d",questionID.intValue];

        NSDictionary * newQuestionDictionary = [_kvs getObjectById:questionIdString fromTable:newQuestionTable];
        if (newQuestionDictionary != nil) {
            [newQuestionArray addObject:newQuestionDictionary];
        }
//        NSDictionary * newQuestionDictionary = [questionItem itemObject];
    }
    [newPaperDictionary setObject:newQuestionArray forKey:@"questionModels"];
//    [_kvs close];
    return newPaperDictionary;

}

- (NSArray *)getAllpaperFromDB {
    [_kvs createTableWithName:newPaperTablename];
    NSArray * allPaperList = [_kvs getAllItemsFromTable:newPaperTablename];
    [_kvs close];
    return allPaperList;
}

- (PaperModel *)getAllFavouriteListFromDB:(NSArray * )paperList {
    PaperModel * paperModel = [[PaperModel alloc]init];
    paperModel.qmList = [[NSMutableArray alloc]init];
    NSMutableArray * favouriteList = [[NSMutableArray alloc]init];
    for (int i = 0; i < paperList.count; i ++) {
        NSMutableDictionary * paperDictionary = [paperList objectAtIndex:i];
        NSMutableArray * questionModels = [paperDictionary objectForKey:@"questionModels"];
        for (int j = 0; j < questionModels.count; j ++) {
            NSMutableDictionary * questionDictionary = [[NSMutableDictionary alloc]initWithDictionary:[questionModels objectAtIndex:j]];
            if ([paperDictionary objectForKey:@"title"]!= nil) {
                [questionDictionary setObject:[paperDictionary objectForKey:@"title"] forKey:@"paperTitle"];
            }
            QuestionModel * questionModel = [[QuestionModel alloc]init];
//            questionModel.paperTitle = [paperDictionary objectForKey:@"title"];
            questionModel.answer = [questionDictionary objectForKey:@"answer"];
            questionModel.question = [questionDictionary objectForKey:@"question"];
            questionModel.isFavourite = YES;
            NSNumber * questionId = [questionDictionary objectForKey:@"id"];
            questionModel.questionModelId = questionId.intValue;
//            [self addfavouriteData:questionModel IsFavourite:YES];
            NSString * questionIdString = [NSString stringWithFormat:@"%d",questionId.intValue];
            [paperModel.qmList addObject:questionModel];
            [favouriteList addObject:questionDictionary];
        }
    }
    [self saveFavouriteInFavouriteTable:favouriteList];

    return paperModel;
}

- (void)saveFavouriteInFavouriteTable:(NSMutableArray *)favouriteList{
    _kvs = [[YTKKeyValueStore alloc]initDBWithName:@"SUBCOURSEDB"];
    [_kvs createTableWithName:newFavouriteListTable];
    for (int i = 0; i < favouriteList.count; i ++) {
        NSMutableDictionary * questionDictionary = [[NSMutableDictionary alloc]initWithDictionary:[favouriteList objectAtIndex:i]];
        NSNumber * questionIDNumber = [questionDictionary objectForKey:@"id"];
        NSString * questionIdString = [NSString stringWithFormat:@"%d",questionIDNumber.intValue];
        [questionDictionary setObject:@"1" forKey:@"isFavourite"];
        [_kvs putObject:questionDictionary withId:questionIdString intoTable:newFavouriteListTable];
//        [_kvs putObject:questionDictionary withId:questionIdString intoTable:newQuestionTable];
    }
    [_kvs close];
    
    _kvs = [[YTKKeyValueStore alloc]initDBWithName:@"SUBCOURSEDB"];
    [_kvs createTableWithName:newQuestionTable];
    for (int i = 0; i < favouriteList.count; i ++) {
        NSMutableDictionary * questionDictionary = [[NSMutableDictionary alloc]initWithDictionary:[favouriteList objectAtIndex:i]];
        NSNumber * questionIDNumber = [questionDictionary objectForKey:@"id"];
        NSString * questionIdString = [NSString stringWithFormat:@"%d",questionIDNumber.intValue];
        [questionDictionary setObject:@"1" forKey:@"isFavourite"];
//        [_kvs putObject:questionDictionary withId:questionIdString intoTable:newFavouriteListTable];
        [_kvs putObject:questionDictionary withId:questionIdString intoTable:newQuestionTable];
    }
    [_kvs close];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadFavouriteTableView" object:nil];
}

- (PaperModel *)getFavouriteInFavouriteTable {
    _kvs = [[YTKKeyValueStore alloc]initDBWithName:@"SUBCOURSEDB"];
    [_kvs createTableWithName:newFavouriteListTable];
    PaperModel * paperModel = [[PaperModel alloc]init];
    paperModel.qmList = [[NSMutableArray alloc]init];

    NSArray * favouriteQuestionList = [_kvs getAllItemsFromTable:newFavouriteListTable];
    for (int i = 0; i < favouriteQuestionList.count; i ++) {
        YTKKeyValueItem * questionItem = [favouriteQuestionList objectAtIndex:i];
        NSMutableDictionary * questionDictionary = [questionItem itemObject];
        QuestionModel * questionModel = [[QuestionModel alloc]init];
        questionModel.answer = [questionDictionary objectForKey:@"answer"];
        questionModel.questionModelId = questionItem.itemId.intValue;
        questionModel.question = [questionDictionary objectForKey:@"question"];
        questionModel.paperTitle = [questionDictionary objectForKey:@"paperTitle"];
        questionModel.isFavourite = YES;
        [paperModel.qmList addObject:questionModel];
    }
    if (favouriteQuestionList == nil) {
        return nil;
    }
    [_kvs close];
    return paperModel;
}

@end
