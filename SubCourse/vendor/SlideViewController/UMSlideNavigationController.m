//
//  UMSlideNavigationController.m
//  SegmentFault
//
//  Created by jiajun on 11/26/12.
//  Copyright (c) 2012 SegmentFault.com. All rights reserved.
//

#define ANIMATION_DURATION              0.3f
#define SILENT_DISTANCE                 30.0f
//#define SLIDE_VIEW_WIDTH                280.0f//260.0f

//#import "IDGMyFavouritesTableViewCell.h"
#import "UMSlideNavigationController.h"
//#import "IDGMyProductTableViewCell.h"
//#import "IDGMyFavouritesTableViewCell.h"
#import "UMViewController.h"
#import "StyleConstant.h"
//#import "Config.h"
#import "SourceController.h"
#import "MyFavouriteController.h"
#import "MyQuestionController.h"
#import "SafetySettingController.h"


@interface UMSlideNavigationController ()<UIGestureRecognizerDelegate>

// 可以滑动的View
@property (strong, nonatomic)   UIView            *contentView;
// 标记ContentView的静止状态left

// 标记滑动状态
@property (assign, nonatomic)   BOOL              moving;
@property (strong,nonatomic) UIPanGestureRecognizer *panRecognizer;

// 动画
- (void)moveContentViewTo:(CGPoint)toPoint WithPath:(UIBezierPath *)path inDuration:(CGFloat)duration;
// 左上角导航键
- (void)slideButtonClicked;
- (void)slideNavigatorDidDisappear;
- (void)slideNavigatorDidAppear;
// 滑动控制
- (void)slidePanAction:(UIPanGestureRecognizer *)recognizer;
// 没有切换
- (void)switchCurrentView;

@end

@implementation UMSlideNavigationController

@synthesize contentView     = _contentView;
@synthesize currentIndex    = _currentIndex;
@synthesize items           = _items;
@synthesize left            = _left;
@synthesize navItem         = _navItem;
@synthesize slideView       = _slideView;

#pragma mark - private

- (void)addPanRecognizer
{
    self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(slidePanAction:)];
    [self.contentView addGestureRecognizer:self.panRecognizer];
    self.left = self.contentView.left;
}

-(void)removePanRecongnizer
{
    if(self.panRecognizer != nil)
       [self.contentView removeGestureRecognizer:self.panRecognizer];
}

//最终移动方法
- (void)moveContentViewTo:(CGPoint)toPoint WithPath:(UIBezierPath *)path inDuration:(CGFloat)duration
{
    self.contentView.layer.anchorPoint = CGPointZero;
    self.contentView.layer.frame = CGRectMake(toPoint.x, toPoint.y, self.contentView.width, self.contentView.height);
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.duration = duration;
    pathAnimation.path = path.CGPath;
    pathAnimation.calculationMode = kCAAnimationLinear;
    [self.contentView.layer addAnimation:pathAnimation forKey:[NSString stringWithFormat:@"%f", [NSDate timeIntervalSinceReferenceDate]]];
    self.left = toPoint.x;
    
    if (0 < toPoint.x) {
        UIControl *backToNormal = (UIControl *)[self.contentView viewWithTag:SLIDE_CONTROL_TAG];
        if (nil == backToNormal) {
            backToNormal = [[UIControl alloc] initWithFrame:self.contentView.bounds];
        }
        backToNormal.backgroundColor = [UIColor clearColor];
        backToNormal.tag = SLIDE_CONTROL_TAG;
        [backToNormal addTarget:self action:@selector(slideButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [backToNormal removeFromSuperview];
        [self.contentView addSubview:backToNormal];
        [self performSelector:@selector(slideNavigatorDidAppear) withObject:nil afterDelay:duration];
        //move out
    }
    else {
        __weak UIControl *backToNormal = (UIControl *)[self.contentView viewWithTag:SLIDE_CONTROL_TAG];
        [backToNormal removeFromSuperview];
        [self performSelector:@selector(slideNavigatorDidDisappear) withObject:nil afterDelay:duration];
        //move in
    }
    self.moving = NO;
}

- (void)slideButtonClicked //Hamburger
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    //NSLog(@"UMSlideNavigationController");
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(self.contentView.left, 0.0f)];
    self.moving = YES;
    if (0.0f < self.contentView.left) {//MOVE IN
        [self viewWillDisappear:YES];
        //[path addLineToPoint:CGPointMake(self.contentView.width, 0.0f)]; //FUCK YOU MOVE TO OUTSIDE
        [path addLineToPoint:CGPointMake(0.0f, 0.0f)];
        [self moveContentViewTo:CGPointMake(0.0f, 0.0f)
                        WithPath:path
                        inDuration:ANIMATION_DURATION];
    }else {//MOVE OUT
        [self viewWillAppear:YES];
        [path addLineToPoint:CGPointMake(ScreenWidth * SLIDE_VIEW_WIDTH, 0.0f)];
        [self moveContentViewTo:CGPointMake(ScreenWidth * SLIDE_VIEW_WIDTH, 0.0f)
                        WithPath:path
                        inDuration:ANIMATION_DURATION];
    }
}

//草距个手势识别
-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    [touch.view becomeFirstResponder];
    //NSLog(@"view class:%@ view.tag:%ld",[touch.view class],touch.view.tag);//UITableViewCellContentView
    if (touch.view.tag == 9 || [touch.view isKindOfClass:[UITableViewCell class]]) {
        return NO;
    }else
        return YES;
    
}

// 延迟运行
- (void)slideNavigatorDidDisappear
{
    [self viewDidDisappear:YES];
}

- (void)slideNavigatorDidAppear
{
    [self viewDidAppear:YES];
}

- (void)slidePanAction:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.contentView];
    CGPoint velocity = [recognizer velocityInView:self.contentView];
    if(recognizer.state == UIGestureRecognizerStateChanged && 2 <= ABS(self.left - ABS(translation.x))) { // sliding.
        //NSLog(@"is moving with v = %f",velocity.x);
        if (! self.moving) {
            if (0 < self.left) {
                [self viewWillDisappear:YES];
            }
            else {
                [self viewWillAppear:YES];
            }
        }
        self.moving = YES;
        CGFloat newLeft = self.left + translation.x;
        if (0 > newLeft) {
            newLeft = 0;
        }else if (ScreenWidth * SLIDE_VIEW_WIDTH < newLeft) {
            newLeft = ScreenWidth * SLIDE_VIEW_WIDTH;
        }
        if (SILENT_DISTANCE < abs(translation.x)) { // more than SILENT, move
            self.contentView.left = newLeft;
        }
        //NSLog(@"moving x : %f , y : %f",self.contentView.centerX,self.contentView.centerY);
    }else if(recognizer.state == UIGestureRecognizerStateEnded) { // end slide.
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        CGFloat animationDuration = 0.0f;
        CGFloat v = ScreenWidth * SLIDE_VIEW_WIDTH / ANIMATION_DURATION;
        //NSLog(@"SELF.CONTENTVIEW.TOP = %f",self.contentView.top);
        if (0 < velocity.x) { // left to right
            //NSLog(@"velocity=%f",velocity.x);
            if (500.0f < velocity.x || ScreenWidth * SLIDE_VIEW_WIDTH / 2 < self.left + translation.x) { // fast or more than half
                animationDuration = (ScreenWidth * SLIDE_VIEW_WIDTH - translation.x) / v;
                UIBezierPath *path = [UIBezierPath bezierPath];
                
                [path moveToPoint:CGPointMake(self.contentView.left, 0.0f)];
                [path addLineToPoint:CGPointMake(ScreenWidth * SLIDE_VIEW_WIDTH, 0.0f)];
                //NSLog(@"move out");
                [self moveContentViewTo:CGPointMake(ScreenWidth * SLIDE_VIEW_WIDTH, 0.0f)//move out
                               WithPath:path
                             inDuration:animationDuration];
            }
            else if (ScreenWidth * SLIDE_VIEW_WIDTH / 2 >= self.left + translation.x) {
                animationDuration = translation.x / v;
                UIBezierPath *path = [UIBezierPath bezierPath];
                [path moveToPoint:CGPointMake(self.contentView.left, 0.0f)];
                [path addLineToPoint:CGPointMake(0.0f, 0.0f)];
                //NSLog(@"move out ? ");
                [self moveContentViewTo:CGPointMake(0.0f, 0.0f)
                               WithPath:path
                             inDuration:animationDuration];
            }
        }
        else { // right to left
            //NSLog(@"velocity=%f",velocity.x);
            if (-500.0f > velocity.x || ScreenWidth * SLIDE_VIEW_WIDTH / 2 > self.left + translation.x) { // fast or more than half
                animationDuration = (ScreenWidth * SLIDE_VIEW_WIDTH + translation.x) / v;
                UIBezierPath *path = [UIBezierPath bezierPath];
                [path moveToPoint:CGPointMake(self.contentView.left, 0.0f)];
                [path addLineToPoint:CGPointMake(0.0f, 0.0f)];
                //NSLog(@"move in");
                [self moveContentViewTo:CGPointMake(0.0f, 0.0f)//move in
                               WithPath:path
                             inDuration:animationDuration];
            }
            else if (ScreenWidth * SLIDE_VIEW_WIDTH / 2 <= self.left + translation.x) {
                animationDuration = - translation.x / v;
                UIBezierPath *path = [UIBezierPath bezierPath];
                [path moveToPoint:CGPointMake(self.contentView.left, 0.0f)];
                [path addLineToPoint:CGPointMake(ScreenWidth * SLIDE_VIEW_WIDTH, 0.0f)];
                //NSLog(@"move in ?");
                [self moveContentViewTo:CGPointMake(ScreenWidth * SLIDE_VIEW_WIDTH, 0.0f)
                               WithPath:path
                             inDuration:animationDuration];
            }
        }
    }
}

- (void)switchCurrentView //CLICK THE TABLECELL ITEMS
{
    [self.contentView removeAllSubviews];
    UIViewController *currentVC = (UIViewController *)self.items[self.currentIndex.section][self.currentIndex.row];
    [self.contentView addSubview:currentVC.view];
    //currentVC.view.top = -20.0f;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(self.contentView.left, 00.0f)];
    [path addLineToPoint:CGPointMake(0.0f, 0.0f)];
    [self moveContentViewTo:CGPointMake(0.0f, 0.0f) WithPath:path inDuration:ANIMATION_DURATION];
    
    // 每次切换会清空contentView，这里重新贴阴影
//    UIImageView *shadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slide_navigator_shadow.png"]];
//    shadow.height = self.contentView.height;
//    shadow.right = self.contentView.left;
//    [self.contentView addSubview:shadow];
}

#pragma mark - public

- (id)initWithItems:(NSArray *)items
{
    self = [super init];
    if (self) {
        self.items = [[NSMutableArray alloc] init];
        for (NSArray *section in items) {
            [self.items addObject:[section mutableCopy]];
        }
        return self;
    }
    return nil;
}

//用户点击了选项
- (void)showItemAtIndex:(NSIndexPath *)index withAnimation:(BOOL)animated
{
    if (animated) {//move in
        if (index.section < [self.items count] && index.row < [self.items[index.section] count]) {
            self.currentIndex = index;
            //UIBezierPath *path = [UIBezierPath bezierPath];
            //[path moveToPoint:CGPointMake(self.contentView.left, 0.0f)];
            //[path addLineToPoint:CGPointMake(self.contentView.width, 0.0f)];
            //[self moveContentViewTo:CGPointMake(self.contentView.width, 0.0f) WithPath:path inDuration:0.2f];
            [self performSelector:@selector(switchCurrentView) withObject:nil afterDelay:0.0f];
        }
    }
    else {
        if (index.section < [self.items count] && index.row < [self.items[index.section] count]) {
            self.currentIndex = index;
            [self.contentView removeAllSubviews];

            UIViewController *currentVC = (UIViewController *)self.items[self.currentIndex.section][self.currentIndex.row];
            [self.contentView addSubview:currentVC.view];
            //currentVC.view.top = -20.0f;
            
            // 每次切换会清空contentView，这里重新贴阴影
//            UIImageView *shadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slide_navigator_shadow.png"]];
//            shadow.height = self.contentView.height;
//            shadow.right = self.contentView.left;
//            [self.contentView addSubview:shadow];
        }
    }
    //设置新的 跳转页面
//    [self.contentView removeFromSuperview];
    
}

#pragma mark

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navItem = [[UINavigationItem alloc] initWithTitle:@""];
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.width, self.view.height)];
    
//    UIImageView *shadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slide_navigator_shadow.png"]];
//    shadow.height = self.contentView.height;
//    shadow.right = self.contentView.left + 1.0f;
//    [self.contentView addSubview:shadow];
    
    self.slideView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.width, self.view.height)
                                                  style:UITableViewStylePlain];
    UIView * verSeparatorLine = [[UIView alloc]initWithFrame:CGRectMake(self.slideView.frame.size.width- 2, 0, 2, self.view.frame.size.height)];
    verSeparatorLine.backgroundColor = [UIColor blackColor];
    [self.slideView addSubview:verSeparatorLine];
//    self.slideView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    
//    SafetySettingController * ssc 
    
    if (0 < self.items.count) {
        [self.contentView addSubview:[(UIViewController *)self.items[0][0] view]];
    }
    
    [self.view addSubview:self.slideView];
    [self.view addSubview:self.contentView];
    self.view .backgroundColor = [UIColor whiteColor];
    
    [self addPanRecognizer];
    self.panRecognizer.delegate = self;
    
    self.currentIndex = [NSIndexPath indexPathForRow:0 inSection:1];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:UMNotificationWillShow object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:UMNotificationHidden object:nil];
}



@end
