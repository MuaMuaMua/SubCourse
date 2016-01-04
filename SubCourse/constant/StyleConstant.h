//
//  StyleConstant.h
//  IDGOODS_iOS
//
//  Created by dosonleung on 9/15/15.
//  Copyright (c) 2015 Guyi Information Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

//the size of the Screen's width
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
//the size of the Screen's height
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
//the size of the navigiation bar button height
#define NAVIGATION_BAR_BTN_RECT  CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)

//the size for verious bars height
static CGFloat statusBarHeight = 20;
static CGFloat navBarHeight = 64;//44 + 20
static CGFloat tabBarHeight = 49;

//the size for cell height
static CGFloat defaultCellHeight = 44;
static CGFloat narrowCellHeight = 30;
static CGFloat qrCodeHeight = 35;

//the size for icons side length
static CGFloat iconXLargeSideLength = 200;
static CGFloat iconLargeSideLength = 160;
static CGFloat iconMediumSideLength = 150;
static CGFloat iconMSmallSlideLength = 100;
static CGFloat iconSmallSideLength = 75;

//the size for verious button width
static CGFloat flatButtonWidth = 280;
static CGFloat thinButtonWidth = 108;

//the size for interval
static CGFloat narrowInterval = 10;
static CGFloat wideInterval = 18;

//the rate of slidewidth
static CGFloat SLIDE_VIEW_WIDTH = 0.8;
//the rate of
static CGFloat SCANVIEW_EdgeTopRate = 0.25;

@interface StyleConstant : NSObject

@end
