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

@interface SCDetailViewcontroller ()<SubcourseManagerDelegate>{
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
    
}

@end

@implementation SCDetailViewcontroller

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setscManager];
    [self setSlider];
    [self setBottomLabels];
    [self initNavigationItem];
    //判断是否从 favouriteVC中跳转
    if (self.isFavouriteListPaper) {
        [categoryBtn setImage:[UIImage imageNamed:@""]];
        [categoryBtn setEnabled:NO];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(favouritSuccessCallBack) name:@"favouritSuccessCallBack" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    
    if (self.questionModel.isFavourite) {
        [_favouriteBtn setImage:[UIImage imageNamed:@"fa-smile-o"]];
    }else {
        [_favouriteBtn setImage:[UIImage imageNamed:@"Fill 180"]];
    }
    
    [self initSlideView];
    [self setTextView];
    _navigationBar.hidden = YES;
    
    [self setGestureRec];
    UILabel * label = [[UILabel alloc]init];
    label.text = _paperModel.title;
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
//        [MBProgressHUD showSuccess:@"收藏成功"];
        [_favouriteBtn setImage:[UIImage imageNamed:@"fa-smile-o"]];
        NSNumber * number = [NSNumber numberWithFloat:self.value];
        int intVal = [number intValue];
        int firs = self.firstPaperIndex;
//        [_cManager addFavouriteInDB:firs SecondIndex:intVal IsFavourite:YES];
        self.questionModel.paperTitle = self.paperModel.title;
        [_cManager addfavouriteData:self.questionModel IsFavourite:YES];
        
        [_scManager addFavourite:self.questionModel.questionModelId];
        self.questionModel.isFavourite = YES;
    }else {
//        [MBProgressHUD showSuccess:@"收藏成功"];
        [_favouriteBtn setImage:[UIImage imageNamed:@"Fill 180"]];
        NSNumber * number = [NSNumber numberWithFloat:self.value];
        int intVal = [number intValue];
        int firs = self.firstPaperIndex;
        self.questionModel.paperTitle = self.paperModel.title;
        [_cManager addfavouriteData:self.questionModel IsFavourite:NO];
        self.questionModel.isFavourite = NO;
        //重写方法
        [_scManager removeFavourite:self.questionModel.questionModelId];
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
    [contentTextView addGestureRecognizer:tapGestureRecognizer];
}

- (void)tapAction:(UITapGestureRecognizer *)tapGestureRec {
    if ([_navigationBar isHidden]) {
        [_navigationBar setHidden:NO];
//        [UIView animateWithDuration:0.1 delay:0.0 options:1 animations:^{
////            _bottomView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.frame.size.width, 0);
//            [_bottomView removeFromSuperview];
//        } completion:^(BOOL finished) {
//        }];
    }else {
        [_navigationBar setHidden:YES];
//        [UIView animateWithDuration:0.1 delay:0.0 options:1 animations:^{
//            _bottomView.frame = CGRectMake(0, self.view.frame.size.height - 40, self.view.frame.size.width, 40);
//            [_bgView addSubview:_bottomView];
//        } completion:^(BOOL finished) {
//        }];
    }
}

#pragma mark - textView attributes

- (void)setTextView {
    contentTextView.text = [self.questionModel.question stringByAppendingString:self.questionModel.answer];
    contentTextView.font = [UIFont systemFontOfSize:20];
}

#pragma mark - rewriteSlider 

- (void)setBottomLabels {
    int maxInt = self.maxValue+1;
    int curretInt = self.value+1;
    int minInt = self.minValue;
    countLabel.text = [NSString stringWithFormat:@"%d/%d",curretInt,maxInt];
    pageLabel.text = [NSString stringWithFormat:@"还有%d页",maxInt - curretInt];
}

- (void)setSlider {
    [_slider setThumbImage:[UIImage imageNamed:@"BlueOval"] forState:UIControlStateNormal];
    [_slider setThumbImage:[UIImage imageNamed:@"BlueOval"] forState:UIControlStateHighlighted];
    [_slider setMinimumTrackTintColor:[UIColor blueColor]];
    [_slider setMaximumTrackTintColor:[UIColor colorWithRed:211.0/255 green:211.0/255 blue:211.0/255 alpha:1]];
    [_slider addTarget:self action:@selector(slideValue) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)categoryVC:(id)sender {
    [self.delegate presentToTableVC:_slider.value];
}

- (void)viewWillDisappear:(BOOL)animated {
    
}

- (void)slideValue{
    [self.delegate slideValueChanged:_slider.value];
}

- (void)initSlideView {
    _slider.maximumValue = self.maxValue;
    _slider.minimumValue = 0;
    _slider.value = self.value;
}

@end
