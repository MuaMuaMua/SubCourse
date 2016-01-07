//
//  QuestionModel.h
//  SubCourse
//
//  Created by wuhaibin on 15/12/22.
//  Copyright © 2015年 wuhaibin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionModel : NSObject

@property (strong, nonatomic) NSString * question;
@property (strong, nonatomic) NSString * answer;
@property long entityId;
@property (strong, nonatomic) NSString * updatedTime;
@property long questionModelId;
@property (strong, nonatomic) NSString * createTime;
@property int pageNum;
@property BOOL isFavourite;
@property BOOL isQuiz;
@property (strong, nonatomic) NSString * paperTitle;

@end
