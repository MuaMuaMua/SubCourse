//
//  BaseModel.h
//  SubCourse
//
//  Created by wuhaibin on 15/12/24.
//  Copyright © 2015年 wuhaibin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

//@property int indentify;
@property (strong, nonatomic) NSString * indentify;
@property BOOL isDeleted;
@property long updateTime;
@property long created_time;

@end
