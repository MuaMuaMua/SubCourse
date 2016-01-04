//
//  ExerciseViewController.h
//  SubCourse
//
//  Created by wuhaibin on 15/11/30.
//  Copyright © 2015年 wuhaibin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExerciseViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *numLabel;//大题题号

@property (strong, nonatomic) IBOutlet UILabel *numLabel2;//小题题号

@property (strong, nonatomic) IBOutlet UITextView *contentTextView;

@property (strong, nonatomic) IBOutlet UISlider *sliderControl;

@property (strong, nonatomic) IBOutlet UILabel *currentExerciseLabel;

@property (strong, nonatomic) IBOutlet UILabel *sumExerciseLabel;

@property int minNum;//最大的题号

@property int maxNum;//最小的题号

@property int currentCount;

@end
