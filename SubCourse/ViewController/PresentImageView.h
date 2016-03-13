//
//  PresentImageView.h
//  SubCourse
//
//  Created by wuhaibin on 16/1/21.
//  Copyright © 2016年 wuhaibin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PresentImageView : UIViewController

@property (strong, nonatomic) UIImageView * previewImageView;
@property (strong, nonatomic) NSString * urlString;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *imageContainerView;

@end
