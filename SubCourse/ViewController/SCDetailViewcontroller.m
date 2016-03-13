//
//  SCDetailViewcontroller.m
//  SubCourse
//
//  Created by wuhaibin on 15/12/22.
//  Copyright © 2015年 wuhaibin. All rights reserved.
//

#import "SCDetailViewcontroller.h"
#import "PaperChooseViewController.h"
#import "SubcourseManager.h"
#import "MBProgressHUD+MJ.h"
#import "MBProgressHUD.h"
#import "CacheManager.h"

@interface SCDetailViewcontroller ()<SubcourseManagerDelegate,UIGestureRecognizerDelegate>{
    IBOutlet UINavigationBar *_navigationBar;
    IBOutlet UITextView *contentTextView;
    IBOutlet UISlider *_slider;
    IBOutlet UILabel *countLabel;
    IBOutlet UILabel *pageLabel;
    IBOutlet UIBarButtonItem *categoryBtn;
    IBOutlet UINavigationItem *_navigationItem;
    IBOutlet UIView *_bottomView;
    IBOutlet UIView *_bgView;
    SubcourseManager * _scManager;
    IBOutlet UIBarButtonItem *_quizBtn;
    IBOutlet UIBarButtonItem *_favouriteBtn;
    CacheManager * _cManager;
    
    IBOutlet UILabel *_paperTitleLabel;
    
    IBOutlet UILabel *_introductionPageLabel;
    
    IBOutlet UIView *_introductionView;
    
}

@end

@implementation SCDetailViewcontroller

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setscManager];
    [self setSlider];
    [self setBottomLabels];
    [self initNavigationItem];
    //    [self setTextView];
    _introductionView.hidden = YES;
    //判断是否从 favouriteVC中跳转
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(favouritSuccessCallBack) name:@"favouritSuccessCallBack" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.isFavouriteListPaper) {
        [categoryBtn setImage:[UIImage imageNamed:@""]];
        [categoryBtn setEnabled:NO];
    }
    
    if (self.questionModel.isFavourite) {
        [_favouriteBtn setImage:[UIImage imageNamed:@"fa-smile-o"]];
    }else {
        [_favouriteBtn setImage:[UIImage imageNamed:@"Fill 180"]];
    }
    
    [self initSlideView];
    _navigationBar.hidden = NO;
    
    [self setGestureRec];
    UILabel * label = [[UILabel alloc]init];
//    label.text = _paperModel.title;
    label.text = _questionModel.paperTitle;
    NSLog(@"%@",_paperModel.title);
    [label sizeToFit];
    label.textColor = [UIColor blackColor];
    _navigationItem.titleView = label;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - scManager Delegate && settings

- (void)setscManager {
    _scManager = [SubcourseManager sharedInstance];
    _scManager.delegate = self;
    
    _cManager = [CacheManager sharedInstance];
    
}

- (void)favouritSuccessCallBack {
    
}

- (void)addFavouriteCallBack:(NSDictionary *)responseData {
    NSNumber * code = [responseData objectForKey:@"code"];
    if (code.intValue == 200) {
        
    }else {
        [MBProgressHUD showError:@"收藏失败"];
    }
}

- (void)addQuizCallBack:(NSDictionary *)responseData {
    NSNumber * code = [responseData objectForKey:@"code"];
    if (code.intValue == 200) {
        [MBProgressHUD showSuccess:@"提问成功"];
        
    }
}

- (void)removeQuizCallBack:(NSDictionary *)responseData {
    
}

- (void)removeFavouriteCallBack:(NSDictionary *)responseData {
    
    NSNumber * code = [responseData objectForKey:@"code"];
    if (code.intValue == 200) {
        
    }else {
        [MBProgressHUD showError:@"取消收藏失败"];
    }
}

- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initNavigationItem {
    
}

- (IBAction)changeFont:(id)sender {
    [_scManager addquiz:self.questionModel.questionModelId];
}

- (IBAction)favouriteAction:(id)sender {
    
    NSLog(@"%f",self.value);
    if (self.questionModel.isFavourite == NO) {
        [_favouriteBtn setImage:[UIImage imageNamed:@"fa-smile-o"]];
        NSNumber * number = [NSNumber numberWithFloat:self.value];
        int intVal = [number intValue];
        int firs = self.firstPaperIndex;
        self.questionModel.paperTitle = self.paperModel.title;
        [_cManager addfavouriteData:self.questionModel IsFavourite:YES];

        [_scManager addFavourite:self.questionModel.questionModelId DTZSuccessBlock:^(NSDictionary *successBlock) {
            
        } DTZFailBlock:^(NSDictionary *failBlock) {
            
        }];
        self.questionModel.isFavourite = YES;
    }else {
        [_favouriteBtn setImage:[UIImage imageNamed:@"Fill 180"]];
        NSNumber * number = [NSNumber numberWithFloat:self.value];
        int intVal = [number intValue];
        int firs = self.firstPaperIndex;
        self.questionModel.paperTitle = self.paperModel.title;
        [_cManager addfavouriteData:self.questionModel IsFavourite:NO];
        self.questionModel.isFavourite = NO;
        //重写方法

        [_scManager removeFavourite:self.questionModel.questionModelId DTZSuccessBlock:^(NSDictionary *successBlock) {
            
        } DTZFailBlock:^(NSDictionary *failBlock) {
            
        }];
        
    }
    
}

#pragma mark - bottomView Settings

- (void)bottomViewSetting {
    
}

#pragma mark - setGestureRecognizer

- (void)setGestureRec {
    UITapGestureRecognizer * tapGestureRecognizer = [[UITapGestureRecognizer alloc]init];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [tapGestureRecognizer addTarget:self action:@selector(tapAction:)];
    //    [_contentTextView addGestureRecognizer:tapGestureRecognizer];
}

- (void)tapAction:(UITapGestureRecognizer *)tapGestureRec {
    if ([_navigationBar isHidden]) {
        [_navigationBar setHidden:NO];
        
    }else {
        [_navigationBar setHidden:YES];
        
    }
}

#pragma mark - textView attributes


#pragma mark - rewriteSlider

- (void)setBottomLabels {
    int maxInt = self.maxValue+1;
    int curretInt = self.value+1;
    int minInt = self.minValue;
    countLabel.text = [NSString stringWithFormat:@"%d/%d",curretInt,maxInt];
    pageLabel.text = [NSString stringWithFormat:@"还有%d页",maxInt - curretInt];
}

- (void)setSlider {
    [_slider setThumbImage:[UIImage imageNamed:@"Oval 1"] forState:UIControlStateNormal];
    [_slider setThumbImage:[UIImage imageNamed:@"Oval 1"] forState:UIControlStateHighlighted];
    [_slider setMinimumTrackTintColor:[UIColor blackColor]];
    [_slider setMaximumTrackTintColor:[UIColor colorWithRed:211.0/255 green:211.0/255 blue:211.0/255 alpha:1]];
    
    [_slider addTarget:self action:@selector(slideValue) forControlEvents:UIControlEventTouchUpInside];
    
    [_slider addTarget:self action:@selector(slideStop) forControlEvents:UIControlEventTouchUpOutside];
    
    [_slider addTarget:self action:@selector(slideSwipe) forControlEvents:UIControlEventTouchDragInside];
    
    [_slider addTarget:self action:@selector(slideSwipe) forControlEvents:UIControlEventTouchDragOutside];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (IBAction)categoryVC:(id)sender {
    [self.delegate presentToTableVC:_slider.value];
}

- (void)slideSwipe {
    //创建 slide 上面的view 添加
    _introductionView.hidden = NO;
    int currentValue = _slider.value + 1;
    QuestionModel * currentQuestionModel = [self.paperModel.qmList objectAtIndex:currentValue-1];
    NSString * string = [NSString stringWithFormat:@"%@部分",currentQuestionModel.partTitle];
    _paperTitleLabel.text = string ;
    _introductionPageLabel.text = [NSString stringWithFormat:@"第%d小题",currentValue];
}

- (void)slideStop {
    _introductionView.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    
}

- (void)slideValue{
    _introductionView.hidden = YES;
    [self.delegate slideValueChanged:_slider.value];
}

- (void)initSlideView {
    _slider.maximumValue = self.maxValue;
    _slider.minimumValue = 0;
    _slider.value = self.value;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UISlider class]]) {
        _introductionView.hidden = NO;
        return YES;
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]]) {
        return NO;
    }
    if([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]){
        return NO;
    }
    return YES;
}

@end
