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
}

@end

@implementation SCDetailViewcontroller

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setscManager];
    [self setSlider];
    [self setBottomLabels];
    [self initNavigationItem];
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
}

- (void)addFavouriteCallBack:(NSDictionary *)responseData {
    NSNumber * code = [responseData objectForKey:@"code"];
    if (code.intValue == 200) {
        [MBProgressHUD showSuccess:@"收藏成功"];
        [_favouriteBtn setImage:[UIImage imageNamed:@"fa-smile-o"]];
    }else {
        
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
//    [_scManager getAllFavourite];
    NSLog(@"%f",self.value);
//    int intValue = self.value;
    if (self.questionModel.isFavourite) {
        self.questionModel.isFavourite = NO;
    }else {
        self.questionModel.isFavourite = YES;
    }
    NSNumber * number = [NSNumber numberWithFloat:self.value];
    int intVal = [number intValue];
    
    [_scManager addFavourite:self.questionModel.questionModelId];
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
//     contentTextView.text = @"卢象昇，宜兴人。象昇虽文士，善射，娴．将略。（崇祯）六年，贼流入畿辅，据西山，象昇击却之。贼走还西山，围冷水村 ，象昇设伏大破之。象昇每临阵，身先士卒，与贼格斗，刃及鞍勿顾，失马即步战。逐贼危． 崖，一贼自巅射中象昇额，象昇提刀战益疾。贼骇走，相戒曰：“卢廉使遇即死，不可犯。” （十年）九月，清兵驻与牛兰。召宣、大、山西三总兵杨国柱、王朴、虎大威入卫。赐象昇尚方剑，督．天下援兵。象昇麻衣草履，誓师及郊。当是时，嗣昌、起潜①主和议。  象昇闻之，顿足叹曰：“予受国恩，恨不得死所，有如万分一不幸，宁捐躯断脰耳。”决策议战，然事多□嗣昌、起潜挠。疏请分兵，则议宣、大、山西三帅属象昇，关、宁诸路属起潜。象昇名督天下兵，实不及二万。次顺义。  清兵南下，三路出师··象昇提残卒，宿三宫野外。十二月十一日，进师至贾庄。起潜拥关、宁兵在鸡泽，距贾庄五十里，象昇遣廷麟往乞援，不应。师至蒿水桥，遇清兵。";
}

#pragma mark - rewriteSlider 

- (void)setBottomLabels {
    int maxInt = self.maxValue;
    int curretInt = self.value;
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
