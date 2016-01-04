//
//  User.h
//  SubCourse
//
//  Created by wuhaibin on 15/12/19.
//  Copyright © 2015年 wuhaibin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong, nonatomic) NSString * nickName;
@property (strong, nonatomic) NSString * studentNo;
@property (strong, nonatomic) NSString * password;
@property (strong, nonatomic) NSString * salt;
@property (strong, nonatomic) NSString * token;
@property (strong, nonatomic) NSString * avatar;
@property (strong, nonatomic) NSString * school;
@property (strong, nonatomic) NSString * major;
@property (strong, nonatomic) NSString * clazz;
@property (strong, nonatomic) NSString * realName;
@property (strong, nonatomic) NSString * idCard;
@property (strong, nonatomic) NSString * phone;
@property (strong, nonatomic) NSString * email;
@property (strong, nonatomic) NSString * address;

@end
