//
//  Exercise.h
//  SubCourse
//
//  Created by wuhaibin on 15/12/2.
//  Copyright © 2015年 wuhaibin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Exercise : NSObject

@property (strong, nonatomic) NSMutableArray * exerciseArray;
@property (strong, nonatomic) NSString * title;
@property (strong, nonatomic) NSString * subject;
@property NSInteger type;

@end
