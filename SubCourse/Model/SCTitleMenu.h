//
//  SCTitleMenu.h
//  SubCourse
//
//  Created by wuhaibin on 15/11/30.
//  Copyright © 2015年 wuhaibin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol SCTitleMenuDelegate <NSObject>

- (void)SCTitleMenu:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

typedef void(^Dismiss)(void);

@interface SCTitleMenu : UIView <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView * tableView;
@property (strong, nonatomic) id<SCTitleMenuDelegate> delegate;
@property (strong, nonatomic) NSArray * arrData;
@property (strong, nonatomic) NSArray * arrImgName;
@property (copy,   nonatomic) Dismiss dismiss;

- (instancetype)initWithDataArr:(NSArray *)dataArr origin:(CGPoint)origin width:(CGFloat)width rowHeight:(CGFloat)rowHeight;

- (void)dismissWithCompletion:(void (^)(SCTitleMenu *object))completion;

@end
