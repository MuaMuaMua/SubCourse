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
//- (void)savePaper:(NSMutableDictionary *)paperDictionary {
//    _kvs = [[YTKKeyValueStore alloc]initDBWithName:@"SUBCOURSEDB"];
//    [_kvs createTableWithName:paperTablename];
//    [_kvs putObject:paperDictionary withId:@"paperDictionary" intoTable:paperTablename];
//    [_kvs close];
//}


/*
 *从数据库中获取试卷dictionarys
 */
//- (NSMutableDictionary *)getPaperDictionarys {
//    _kvs = [[YTKKeyValueStore alloc]initDBWithName:@"SUBCOURSEDB"];
//    [_kvs createTableWithName:paperTablename];
//    NSMutableDictionary *paperDictionarys = [_kvs getObjectById:@"paperDictionary" fromTable:paperTablename];
//    if(paperDictionarys == nil){
//        return nil;
//    }
//    [_kvs close];
//    return paperDictionarys;
//}

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


- (PaperModel *)getExistPaperFromDB :(NSDictionary * )paperDictionary{
    PaperModel * paperModel = [[PaperModel alloc]init];
    paperModel.pmList = [[NSMutableArray alloc]init];
    paperModel.qmList = [[NSMutableArray alloc]init];
    paperModel.title = [paperDictionary objectForKey:@"title"];
    if (paperDictionary != nil) {
        NSArray * partModelList = [paperDictionary objectForKey:@"partModels"];
        paperModel.descri = [paperDictionary objectForKey:@"desc"];
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
                questionModel.paperTitle = [paperDictionary objectForKey:@"title"];
                questionModel.partId = [partModelDictionary objectForKey:@"id"];
                questionModel.partTitle = [partModelDictionary objectForKey:@"title"];
                NSNumber * number = [questionDictionary objectForKey:@"questionNumber"];
                questionModel.questionNumber = number;
                [partModel.qmList addObject:questionModel];
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
                    questionModel.paperTitle = [paperDictionary objectForKey:@"title"];
                    questionModel.partId = [partModelDictionary objectForKey:@"id"];
                    questionModel.partTitle = [partModelDictionary objectForKey:@"title"];
                    questionModel.questionNumber = [questionDictionary objectForKey:@"questionNumber"];
                    [paperModel.qmList addObject:questionModel];
                }
            }
        }else {
            for ( int k = 0; k < questionList.count; k ++ ) {
                NSDictionary * questionDictionary = [questionList objectAtIndex:k];
                QuestionModel * questionModel = [[QuestionModel alloc]init];
                questionModel.answer = [questionDictionary objectForKey:@"answer"];
                questionModel.question = [questionDictionary objectForKey:@"question"];
                questionModel.paperTitle = [paperDictionary objectForKey:@"title"];
                NSNumber * qId = [questionDictionary objectForKey:@"id"];
                questionModel.questionModelId = qId.longValue;
                questionModel.partTitle = [questionDictionary objectForKey:@"partTitle"];
                questionModel.partId = [questionDictionary objectForKey:@"partId"];
                if ([questionDictionary objectForKey:@"questionNumber"]!=nil) {
                    questionModel.questionNumber = [questionDictionary objectForKey:@"questionNumber"];
                }
                NSString * isFavourite = [questionDictionary objectForKey:@"isFavourite"];
                if ([isFavourite isEqualToString:@"1"]) {
                    questionModel.isFavourite = YES;
                }
                [paperModel.qmList addObject:questionModel];
            }
        }
    }
    return paperModel;

}

- (PaperModel *)transformQRPaperDictionary:(NSDictionary *)paperDictionary {
    [_kvs createTableWithName:newPaperTablename];
    
    NSString * paperId = [NSString stringWithFormat:@"%ld",(long)[paperDictionary objectForKey:@"id"]];
    NSMutableDictionary * paperDict = [_kvs getObjectById:paperId fromTable:newPaperTablename];
    if (paperDict != nil) {
        PaperModel * paperM = [self getExistPaperFromDB:paperDict];
        return paperM;
    }else {
        PaperModel * paperModel = [[PaperModel alloc]init];
        paperModel.pmList = [[NSMutableArray alloc]init];
        paperModel.qmList = [[NSMutableArray alloc]init];
        paperModel.title = [paperDictionary objectForKey:@"title"];
        if (paperDictionary != nil) {
            NSArray * partModelList = [paperDictionary objectForKey:@"partModels"];
            paperModel.descri = [paperDictionary objectForKey:@"desc"];
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
                    questionModel.paperTitle = [paperDictionary objectForKey:@"title"];
                    questionModel.partId = [partModelDictionary objectForKey:@"id"];
                    questionModel.partTitle = [partModelDictionary objectForKey:@"title"];
                    NSNumber * number = [questionDictionary objectForKey:@"questionNumber"];
                    questionModel.questionNumber = number;
                    
                    if ([questionDictionary objectForKey:@"partNumber"]!=nil) {
                        questionModel.partNumber = [questionDictionary objectForKey:@"partNumber"];
                    }
                    [partModel.qmList addObject:questionModel];
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
                        questionModel.paperTitle = [paperDictionary objectForKey:@"title"];
                        questionModel.partId = [partModelDictionary objectForKey:@"id"];
                        questionModel.partTitle = [partModelDictionary objectForKey:@"title"];
                        questionModel.questionNumber = [questionDictionary objectForKey:@"questionNumber"];
                        questionModel.partNumber = [questionDictionary objectForKey:@"partNumber"];
                        [paperModel.qmList addObject:questionModel];
                    }
                }
            }else {
                for ( int k = 0; k < questionList.count; k ++ ) {
                    NSDictionary * questionDictionary = [questionList objectAtIndex:k];
                    QuestionModel * questionModel = [[QuestionModel alloc]init];
                    questionModel.answer = [questionDictionary objectForKey:@"answer"];
                    questionModel.question = [questionDictionary objectForKey:@"question"];
                    questionModel.paperTitle = [paperDictionary objectForKey:@"title"];
                    NSNumber * qId = [questionDictionary objectForKey:@"id"];
                    questionModel.questionModelId = qId.longValue;
                    questionModel.partTitle = [questionDictionary objectForKey:@"partTitle"];
                    questionModel.partId = [questionDictionary objectForKey:@"partId"];
                    if ([questionDictionary objectForKey:@"questionNumber"]!=nil) {
                        questionModel.questionNumber = [questionDictionary objectForKey:@"questionNumber"];
                    }
                    
                    if ([questionDictionary objectForKey:@"partNumber"]!=nil) {
                        questionModel.partNumber = [questionDictionary objectForKey:@"partNumber"];
                    }
                    
                    NSString * isFavourite = [questionDictionary objectForKey:@"isFavourite"];
                    if ([isFavourite isEqualToString:@"1"]) {
                        questionModel.isFavourite = YES;
                    }
                    [paperModel.qmList addObject:questionModel];
                }
            }
        }
    return paperModel;
    }
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
                    questionModel.paperTitle = [paperDictionary objectForKey:@"title"];
                    questionModel.partId = [partModelDictionary objectForKey:@"id"];
                    questionModel.partTitle = [partModelDictionary objectForKey:@"title"];
//                    questionModel.paperTitle = [questionDictionary objectForKey:@"paperTitle"];
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
                        questionModel.paperTitle = [paperDictionary objectForKey:@"title"];

                        questionModel.partId = [partModelDictionary objectForKey:@"id"];
                        questionModel.partTitle = [partModelDictionary objectForKey:@"title"];
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
                    questionModel.paperTitle = [paperDictionary objectForKey:@"title"];
                    NSNumber * qId = [questionDictionary objectForKey:@"id"];
                    questionModel.questionModelId = qId.longValue;
                    questionModel.partTitle = [questionDictionary objectForKey:@"partTitle"];
                    questionModel.partId = [questionDictionary objectForKey:@"partId"];
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
//    NSMutableArray * fList = [[NSMutableArray alloc]init];
//    for (int i = 0; i < collections .count; i ++) {
//        NSDictionary * paperDictionary = [collections objectAtIndex:i];
//        NSMutableArray * questionModels = [paperDictionary objectForKey:@"questionModels"];
//        for (int j = 0; j < questionModels.count; j ++) {
//            NSMutableDictionary * questionDictionary = [[NSMutableDictionary alloc]initWithDictionary:[questionModels objectAtIndex:j]];
//            [questionDictionary setObject:[paperDictionary objectForKey:@"title"] forKey:@"paperTitle"];
////            favouriteList
//            [fList addObject:questionDictionary];
//        }
//    }
    
    NSMutableArray * fList = [[NSMutableArray alloc]init];
    for (int i = 0; i < collections.count; i ++) {
        NSMutableDictionary * paperDictionary = [collections objectAtIndex:i];
        NSMutableArray * partList = [paperDictionary objectForKey:@"partModelList"];
        for (int j = 0 ; j < partList.count ; j++) {
            NSMutableDictionary * partDictionary = [partList objectAtIndex:j];
            NSMutableArray * questionList = [partDictionary objectForKey:@"questionModels"];
            for ( int k = 0 ; k < questionList.count;  k ++) {
                NSMutableDictionary * questionDictionary = [[NSMutableDictionary alloc]initWithDictionary:[questionList objectAtIndex:k]];
                [questionDictionary setObject:[partDictionary objectForKey:@"title"] forKey:@"partTitle"];
                [questionDictionary setObject:[partDictionary objectForKey:@"id"] forKey:@"partId"];
                [questionDictionary setObject:[paperDictionary objectForKey:@"title"] forKey:@"paperTitle"];
                [fList addObject:questionDictionary];
            }
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

#pragma mark - 保存收藏或者取消收藏isFavourite为YES则为收藏，如果为NO则为不收藏 数据库中字符@"0"为没收藏字符@"1"为收藏

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
    [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadFavourite" object:nil];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isAddFavourit"];
}

#pragma mark - 保存二维码扫到的试卷信息到数据库中 如果获取的所有的试卷信息已经存在 则覆盖 待优化

- (void)saveQRPaperIntoDB:(NSDictionary *)paperDictionary {

    [_kvs createTableWithName:newPaperTablename];
    
    NSMutableDictionary * paperDictionary2 = [[NSMutableDictionary alloc]initWithDictionary:paperDictionary];
    
    NSString * paperId = [NSString stringWithFormat:@"%ld",(long)[paperDictionary2 objectForKey:@"id"]];
    NSMutableDictionary * paperDic = [_kvs getObjectById:paperId fromTable:newPaperTablename];
    if (paperDic == nil) {
//        [_kvs putObject:paperDictionary2 withId:paperId intoTable:newPaperTablename];
        NSMutableArray * partList = [paperDictionary2 objectForKey:@"partModels"];
        int count = 0;
        NSMutableArray * questionArray = [[NSMutableArray alloc]init];
        for (int j = 0; j < partList.count; j ++) {
            NSDictionary * partDictionary = [partList objectAtIndex:j];
            NSMutableArray * questionList = [partDictionary objectForKey:@"questionModels"];
            for (int k = 0; k < questionList.count ; k ++) {
                NSMutableDictionary * questionDictionary = [[NSMutableDictionary alloc]initWithDictionary:[questionList objectAtIndex:k]];
                [questionDictionary setObject:[paperDictionary2 objectForKey:@"id"] forKey:@"paperId"];
                NSNumber * questionIDNumber = [questionDictionary objectForKey:@"id"];
                [questionDictionary setObject:[paperDictionary2 objectForKey:@"title"] forKey:@"paperTitle"];
                NSString * questionIdString = [NSString stringWithFormat:@"%d",questionIDNumber.intValue];
                [questionDictionary setObject:[partDictionary objectForKey:@"title"] forKey:@"partTitle"];
                NSNumber * number = [NSNumber numberWithInt:count];
                [questionDictionary setObject:number forKey:@"questionNumber"];
                count ++;
                //            questionDictionary s
                [questionDictionary setObject:[partDictionary objectForKey:@"id"] forKey:@"partId"];
                [questionArray addObject:questionDictionary];
                [_kvs putObject:questionDictionary withId:questionIdString intoTable:newQuestionTable];
            }
        }
        [paperDictionary2 setObject:questionArray forKey:@"questionModels"];
        NSString * paperId2 = [NSString stringWithFormat:@"%ld",(long)[paperDictionary2 objectForKey:@"id"]];
        NSMutableDictionary * paperDic2 = [_kvs getObjectById:paperId fromTable:newPaperTablename];
        if (paperDic == nil) {
            [_kvs putObject:paperDictionary2 withId:paperId2 intoTable:newPaperTablename];
        }
        [_kvs close];
    }else {
        
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"QrCodePaper" object:paperDictionary];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"getAllPaperNotification" object:nil];
}

#pragma mark - 保存试卷 到数据库中

- (void)savePaperIntoDB:(NSDictionary *)paperDictionary {
    _kvs = [[YTKKeyValueStore alloc]initDBWithName:@"SUBCOURSEDB"];
//    [_kvs createTableWithName:newPaperTablename];
    [_kvs createTableWithName:newQuestionTable];
    NSArray * paperList = [paperDictionary objectForKey:@"paperList"];
    for (int i = 0; i < paperList.count; i ++) {
        NSMutableDictionary * paperDictionary2 = [NSMutableDictionary dictionaryWithDictionary:[paperList objectAtIndex:i]];
        NSMutableArray * partList = [paperDictionary2 objectForKey:@"partModels"];
        NSMutableArray * questionArray = [[NSMutableArray alloc]init];
        int count = 0;
        
        for (int j = 0; j < partList.count; j ++) {
            NSDictionary * partDictionary = [partList objectAtIndex:j];
            NSMutableArray * questionList = [partDictionary objectForKey:@"questionModels"];
            int partCount = 0;
            for (int k = 0; k < questionList.count ; k ++) {
                NSMutableDictionary * questionDictionary = [[NSMutableDictionary alloc]initWithDictionary:[questionList objectAtIndex:k]];
                [questionDictionary setObject:[paperDictionary2 objectForKey:@"id"] forKey:@"paperId"];
                NSNumber * questionIDNumber = [questionDictionary objectForKey:@"id"];
                [questionDictionary setObject:[paperDictionary2 objectForKey:@"title"] forKey:@"paperTitle"];
                NSString * questionIdString = [NSString stringWithFormat:@"%d",questionIDNumber.intValue];
                [questionDictionary setObject:[partDictionary objectForKey:@"title"] forKey:@"partTitle"];
                [questionDictionary setObject:[partDictionary objectForKey:@"id"] forKey:@"partId"];
                //设置partCount
                NSNumber * partNumber = [NSNumber numberWithInt:partCount];
                partCount ++ ;
                [questionDictionary setObject:partNumber forKey:@"partNumber"];
                //设置 questionCount
                NSNumber * questionNumber = [NSNumber numberWithInt:count];
                count ++ ;
                [questionDictionary setObject:questionNumber forKey:@"questionNumber"];
                [questionArray addObject:questionDictionary];
                [_kvs putObject:questionDictionary withId:questionIdString intoTable:newQuestionTable];
            }
        }
        [paperDictionary2 setObject:questionArray forKey:@"questionModels"];
        NSNumber * paperId = [paperDictionary2 objectForKey:@"id"];
        [_kvs createTableWithName:newPaperTablename];
        [_kvs putObject:paperDictionary2 withId:paperId intoTable:newPaperTablename];
    }
    [_kvs close];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"getAllPaperNotification" object:nil];
}

#pragma mark -  组装试卷 返回值 为NSDictionary  配合transformPaperDictionary (返回值为paperModel)

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
        NSMutableDictionary * newQuestionDictionary = [[NSMutableDictionary alloc]initWithDictionary:[_kvs getObjectById:questionIdString fromTable:newQuestionTable]];
        [newQuestionDictionary setObject:[paperDictionary objectForKey:@"title"] forKey:@"paperTitle"];
//        newPaperDictionary setObject: forKey:(nonnull id<NSCopying>)
        if (newQuestionDictionary != nil) {
            [newQuestionArray addObject:newQuestionDictionary];
        }
    }
    [newPaperDictionary setObject:newQuestionArray forKey:@"questionModels"];
    return newPaperDictionary;

}

#pragma mark - 在本地数据库中 获取所有的试卷.

- (NSArray *)getAllpaperFromDB {
    [_kvs createTableWithName:newPaperTablename];
    NSArray * allPaperList = [_kvs getAllItemsFromTable:newPaperTablename];
    [_kvs close];
    return allPaperList;
}

#pragma mark - 旧策略  已经弃用
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
            if ([paperDictionary objectForKey:@"id"]!=nil) {
                [questionDictionary setObject:[paperDictionary objectForKey:@"id"] forKey:@"paperId"];
            }
            QuestionModel * questionModel = [[QuestionModel alloc]init];
//            questionModel.paperTitle = [paperDictionary objectForKey:@"title"];
            questionModel.answer = [questionDictionary objectForKey:@"answer"];
            questionModel.question = [questionDictionary objectForKey:@"question"];
            questionModel.isFavourite = YES;
            questionModel.paperTitle = [paperDictionary objectForKey:@"title"];
            NSNumber * questionId = [questionDictionary objectForKey:@"id"];
            questionModel.questionModelId = questionId.intValue;
            questionModel.paperId = [paperDictionary objectForKey:@"id"];
//            [self addfavouriteData:questionModel IsFavourite:YES];
            NSString * questionIdString = [NSString stringWithFormat:@"%d",questionId.intValue];
            [paperModel.qmList addObject:questionModel];
            [favouriteList addObject:questionDictionary];
        }
    }
    [self saveFavouriteInFavouriteTable:favouriteList];

    return paperModel;
}

#pragma mark - 保存从服务器获取的所有的收藏  版本1.0 不根据用户的USERID来存 以后更改这个策略

- (void)saveFavouriteInFavouriteTable:(NSMutableArray *)favouriteList{
    //打开YTKKeyValueStore
    _kvs = [[YTKKeyValueStore alloc]initDBWithName:@"SUBCOURSEDB"];
    //创建newFavouriteListTable
    [_kvs createTableWithName:newFavouriteListTable];
    [_kvs createTableWithName:newQuestionTable];
    for (int i = 0; i < favouriteList.count; i ++) {
        NSMutableDictionary * questionDictionary = [[NSMutableDictionary alloc]initWithDictionary:[favouriteList objectAtIndex:i]];
        NSNumber * questionIDNumber = [questionDictionary objectForKey:@"id"];
        NSString * questionIdString = [NSString stringWithFormat:@"%d",questionIDNumber.intValue];
        [questionDictionary setObject:@"1" forKey:@"isFavourite"];
        
        NSMutableDictionary * newQuestionDictionary = [[NSMutableDictionary alloc]initWithDictionary:[_kvs getObjectById:questionIdString fromTable:newQuestionTable]];
        [newQuestionDictionary setObject:@"1" forKey:@"isFavourite"];
        
        [_kvs putObject:newQuestionDictionary withId:questionIdString intoTable:newFavouriteListTable];
        [_kvs putObject:newQuestionDictionary withId:questionIdString intoTable:newQuestionTable];
    }
    [_kvs close];
    
    
    [_kvs createTableWithName:newQuestionTable];
    for (int i = 0; i < favouriteList.count; i ++) {
        NSMutableDictionary * questionDictionary = [[NSMutableDictionary alloc]initWithDictionary:[favouriteList objectAtIndex:i]];
        NSNumber * questionIDNumber = [questionDictionary objectForKey:@"id"];
        NSString * questionIdString = [NSString stringWithFormat:@"%d",questionIDNumber.intValue];
        [questionDictionary setObject:@"1" forKey:@"isFavourite"];
        
        NSMutableDictionary * newQuestionDictionary = [[NSMutableDictionary alloc]initWithDictionary:[_kvs getObjectById:questionIdString fromTable:newQuestionTable]];
        [newQuestionDictionary setObject:@"1" forKey:@"isFavourite"];
        [_kvs putObject:newQuestionDictionary withId:questionIdString intoTable:newQuestionTable];
    }
    [_kvs close];
    // 发送通知，如果是在SOURCEViewController中的翻页效果中点击收藏试题 发送getPaperListFromDB
    // 如果是在favouriteViewController 中的翻页效果中点击了收藏或者取消收藏 发送reloadFavouriteTableView
    [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadFavouriteTableView" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getPaperListFromDB" object:nil];
}


#pragma mark - 从本地数据库获取所有的Favourite

- (PaperModel *)getFavouriteInFavouriteTable {
    _kvs = [[YTKKeyValueStore alloc]initDBWithName:@"SUBCOURSEDB"];
    [_kvs createTableWithName:newFavouriteListTable];
    PaperModel * paperModel = [[PaperModel alloc]init];
    paperModel.qmList = [[NSMutableArray alloc]init];

    NSArray * favouriteQuestionList = [_kvs getAllItemsFromTable:newFavouriteListTable];
    
    [_kvs createTableWithName:newQuestionTable];
    for (int i = 0; i < favouriteQuestionList.count; i ++) {
        YTKKeyValueItem * questionItem = [favouriteQuestionList objectAtIndex:i];
        NSMutableDictionary * questionDictionary = [[NSMutableDictionary alloc]initWithDictionary:[questionItem itemObject]];
        
        NSNumber * questionIDNumber = [questionDictionary objectForKey:@"id"];
        NSString * questionIdString = [NSString stringWithFormat:@"%d",questionIDNumber.intValue];
        
        NSMutableDictionary * newQuestionDictionary = [_kvs getObjectById:questionIdString fromTable:newQuestionTable];
        QuestionModel * questionModel = [[QuestionModel alloc]init];
        questionModel.answer = [questionDictionary objectForKey:@"answer"];
        questionModel.questionModelId = questionItem.itemId.intValue;
        questionModel.question = [questionDictionary objectForKey:@"question"];
        questionModel.paperTitle = [questionDictionary objectForKey:@"paperTitle"];
        questionModel.partTitle = [questionDictionary objectForKey:@"partTitle"];
        questionModel.isFavourite = YES;
        questionModel.questionNumber = [questionDictionary objectForKey:@"questionNumber"];
        questionModel.paperId = [questionDictionary objectForKey:@"paperId"];
        NSNumber * number = [questionDictionary objectForKey:@"partId"];
        questionModel.partId = [questionDictionary objectForKey:@"partId"];
        questionModel.partNumber = [newQuestionDictionary objectForKey:@"partNumber"];
        
        [paperModel.qmList addObject:questionModel];
    }
    if (favouriteQuestionList == nil) {
        return nil;
    }
    [_kvs close];
    return paperModel;
}

// 根据paperID获取试卷

- (PaperModel *)getPaperById:(NSNumber *)paperId {
    
    [_kvs createTableWithName:newPaperTablename];
    NSString * paperIdString = [NSString stringWithFormat:@"%@",paperId];
    NSDictionary * paperDict = [_kvs getObjectById:paperId fromTable:newPaperTablename];
    
    NSDictionary * newPaperDict = [self accemblePaperFromDB:paperDict];
    
    PaperModel * paperModel = [self getExistPaperFromDB:newPaperDict];
    
    return paperModel;
}

@end
