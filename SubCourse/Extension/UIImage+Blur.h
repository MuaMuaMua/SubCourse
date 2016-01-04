//
//  UIImage+Blur.h
//  Sport
//
//  Created by wuhaibin on 15/11/18.
//  Copyright © 2015年 wuhaibin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Blur)

+ (UIImage *)addBlur:(NSInteger)blur Image:(UIImage *)image;

- (UIImage *)addBlur:(NSInteger)blur Image:(UIImage *)image;

@end
