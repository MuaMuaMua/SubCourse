//
//  UIImage+Blur.m
//  Sport
//
//  Created by wuhaibin on 15/11/18.
//  Copyright © 2015年 wuhaibin. All rights reserved.
//

#import "UIImage+Blur.h"
#import <GPUImageTwoPassTextureSamplingFilter.h>
#import <GPUImageGaussianBlurFilter.h>

@implementation UIImage (Blur)

+ (UIImage *)addBlur:(NSInteger)blur Image:(UIImage *)image{
    GPUImageGaussianBlurFilter * gpuBlurFilter =  [[GPUImageGaussianBlurFilter alloc]init];
    gpuBlurFilter.blurRadiusInPixels = blur;
    UIImage * blurredImage = [gpuBlurFilter imageByFilteringImage:image];
    return blurredImage;
}

- (UIImage *)addBlur:(NSInteger)blur Image:(UIImage *)image{
    GPUImageGaussianBlurFilter * gpuBlurFilter =  [[GPUImageGaussianBlurFilter alloc]init];
    gpuBlurFilter.blurRadiusInPixels = blur;
    UIImage * blurredImage = [gpuBlurFilter imageByFilteringImage:image];
    return blurredImage;
}

@end
