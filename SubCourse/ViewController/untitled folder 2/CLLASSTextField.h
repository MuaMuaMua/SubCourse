//
//  CLLASSTextField.h
//  SubCourse
//
//  Created by wuhaibin on 16/1/18.
//  Copyright © 2016年 wuhaibin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLLASSTextField : UITextField

- (CGRect)placeholderRectForBounds:(CGRect)bounds;

-(CGRect)textRectForBounds:(CGRect)bounds;

- (CGRect)editingRectForBounds:(CGRect)bounds;
@end
