//
//  PaperModel.h
//  SubCourse
//
//  Created by wuhaibin on 15/12/24.
//  Copyright © 2015年 wuhaibin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface PaperModel : BaseModel

@property (strong, nonatomic) NSString * title;
@property (strong, nonatomic) NSString * descri;
@property (strong, nonatomic) NSMutableArray * pmList;
@property (strong, nonatomic) NSString * isPublished;
@property long createTime;
@property long entityId;
@property (strong, nonatomic) NSString * persistent;
@property NSInteger updateTime;
@property (strong, nonatomic) NSMutableArray * qmList;

@end
