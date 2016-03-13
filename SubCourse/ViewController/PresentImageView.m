//
//  PresentImageView.m
//  SubCourse
//
//  Created by wuhaibin on 16/1/21.
//  Copyright © 2016年 wuhaibin. All rights reserved.
//

#import "PresentImageView.h"
#import "PrefixHeader.pch"
#import "UIImageView+WebCache.h"
#import "UIView+Layout.h"

typedef void (^MyBlock)(NSString *str);//typedef定义一个block

@interface PresentImageView () <UIGestureRecognizerDelegate,UIScrollViewDelegate> {

}

@end

@implementation PresentImageView

#pragma mark - viewSettings

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MyBlock tblock = ^(NSString *str) {
        NSLog(@"-----%@", str);//1
    };
    
    [self testBlock:tblock];//2
    [self setupImageView];
    
    
//    [self setupTapGestureRecognize];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewWillAppear:(BOOL)animated {

}


//- (void)resizeSubviews {
//    _imageContainerView.origin = CGPointZero;
//    _imageContainerView.width = self.view.width;
//    
//    UIImage *image = _imageView.image;
//    if (image.size.height / image.size.width > self.view.height / self.view.width) {
//        _imageContainerView.height = floor(image.size.height / (image.size.width / self.view.width));
//    } else {
//        CGFloat height = image.size.height / image.size.width * self.view.width;
//        if (height < 1 || isnan(height)) height = self.view.height;
//        height = floor(height);
//        _imageContainerView.height = height;
//        _imageContainerView.centerY = self.view.height / 2;
//    }
//    if (_imageContainerView.height > self.view.height && _imageContainerView.height - self.view.height <= 1) {
//        _imageContainerView.height = self.view.height;
//    }
//    _scrollView.contentSize = CGSizeMake(self.view.width, MAX(_imageContainerView.height, self.view.height));
//    [_scrollView scrollRectToVisible:self.view.bounds animated:NO];
//    _scrollView.alwaysBounceVertical = _imageContainerView.height <= self.view.height ? NO : YES;
//    _imageView.frame = _imageContainerView.bounds;
//}


- (void)resizeSubviews {
    
    CGRect winSize3 = [[UIScreen mainScreen]bounds];
    
    
    _imageContainerView.origin = CGPointZero;
    _imageContainerView.width = winSize3.size.width;
    
    UIImage *image = _imageView.image;
    if (image.size.height / image.size.width > self.view.height / self.view.width) {
        _imageContainerView.height = floor(image.size.height / (image.size.width / winSize3.size.width));
        
        
    } else {
        CGFloat height = image.size.height / image.size.width * winSize3.size.width;
        if (height < 1 || isnan(height)) height = self.view.height;
        height = floor(height);
        _imageContainerView.height = height;
        _imageContainerView.centerY = self.view.height / 2;
        _imageContainerView.centerY = winSize3.size.height / 2 ;
    }
    if (_imageContainerView.height > winSize3.size.height && _imageContainerView.height - self.view.height <= 1) {
        _imageContainerView.height = winSize3.size.height;
        _imageContainerView.height = winSize3.size.height;
    }
    _scrollView.contentSize = CGSizeMake(winSize3.size.width, MAX(_imageContainerView.height, self.view.height));
    [_scrollView scrollRectToVisible:self.view.bounds animated:NO];
    _scrollView.alwaysBounceVertical = _imageContainerView.height <= self.view.height ? NO : YES;
    _imageView.frame = _imageContainerView.bounds;
}

#pragma mark - setupImageView and view.background

- (void)setupImageView{
    
    self.view.clipsToBounds = YES;
    
    CGRect winSize = [[UIScreen mainScreen]bounds];

//    _scrollView = [[UIScrollView alloc] init];
//    
//    _scrollView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
//    _scrollView.bouncesZoom = YES;
//    _scrollView.maximumZoomScale = 2.5;
//    _scrollView.minimumZoomScale = 1.0;
//    _scrollView.multipleTouchEnabled = YES;
//    _scrollView.delegate = self;
//    _scrollView.scrollsToTop = NO;
//    _scrollView.showsHorizontalScrollIndicator = NO;
//    _scrollView.showsVerticalScrollIndicator = NO;
//    _scrollView.clipsToBounds = YES;
//    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    _scrollView.delaysContentTouches = NO;
//    _scrollView.canCancelContentTouches = YES;
//    _scrollView.alwaysBounceVertical = NO;
//    _scrollView.backgroundColor = [UIColor blackColor];
//    [self.view addSubview:_scrollView];
//    
//    _imageContainerView = [[UIView alloc] init];
//    NSLog(@"%f",self.view.frame.size.width);
//    _imageContainerView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
//    _imageContainerView.clipsToBounds = YES;
//    _imageContainerView.backgroundColor = [UIColor blackColor];
//    [_scrollView addSubview:_imageContainerView];
//    
//    _imageView = [[UIImageView alloc] init];
//    _imageView .frame = CGRectMake(0, 0, self.view.width, self.view.height);
//    _imageView.backgroundColor = [UIColor blackColor];
//    _imageView.clipsToBounds = YES;
//    _imageView.contentMode = UIViewContentModeScaleAspectFit;
//    [_imageContainerView addSubview:_imageView];
    
    CGRect winSize2 = [[UIScreen mainScreen]bounds];

    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.height);
    _scrollView.bouncesZoom = YES;
    _scrollView.maximumZoomScale = 2.5;
    _scrollView.minimumZoomScale = 1.0;
    _scrollView.multipleTouchEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.scrollsToTop = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.delaysContentTouches = NO;
    _scrollView.canCancelContentTouches = YES;
    _scrollView.alwaysBounceVertical = NO;
    _scrollView.clipsToBounds = YES;
    [self.view addSubview:_scrollView];
    
    _imageContainerView = [[UIView alloc] init];
    _imageContainerView.clipsToBounds = YES;
    _imageContainerView.frame = CGRectMake(0, 0, winSize2.size.width, self.view.height);
    [_scrollView addSubview:_imageContainerView];
    
    _imageView = [[UIImageView alloc] init];
    _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
    _imageView.clipsToBounds = YES;
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
//    _imageView.frame = CGRectMake(0, 0, winSize2.size.width, winSize.size.height);
    _imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.height);
    
    
    [_imageContainerView addSubview:_imageView];

    NSURL * url = [NSURL URLWithString:self.urlString];

    self.view.backgroundColor = [UIColor blackColor];
    [_imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"SubcourseIC"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self resizeSubviews];
    }];
    
    
    [_scrollView setZoomScale:1.0 animated:YES];


    
    _scrollView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [_scrollView addGestureRecognizer:tap1];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    tap2.numberOfTapsRequired = 2;
    [tap1 requireGestureRecognizerToFail:tap2];
    [_scrollView addGestureRecognizer:tap2];
}

#pragma mark - UITapGestureRecognizer Event

- (void)doubleTap:(UITapGestureRecognizer *)tap {
    if (_scrollView.zoomScale > 1.0) {
        [_scrollView setZoomScale:1.0 animated:YES];
    }else {
        CGPoint touchPoint = [tap locationInView:self.imageView];
        CGFloat newZoomScale = _scrollView.maximumZoomScale;
        CGFloat xsize = self.view.frame.size.width / newZoomScale;
        CGFloat ysize = self.view.frame.size.height / newZoomScale;
        [_scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

- (void)singleTap:(UITapGestureRecognizer *)tap {
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - UIScrollViewDelegate

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageContainerView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.width > scrollView.contentSize.width) ? (scrollView.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.height > scrollView.contentSize.height) ? (scrollView.height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.imageContainerView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}

- (void)testBlock:(MyBlock)mBlock
//如果开始没有用typedef定义的话，此处的函数变为- (void)testBlock:(void(^)(NSString *str))myblock
//简单的说格式就是 “返回值 + (^) + 参数 + 名字”
{
    mBlock(@"1111");//3
}

#pragma mark - pinchGestureRecognize

- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    UIView *view = pinchGestureRecognizer.view;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        if (pinchGestureRecognizer.scale >= 1) {
            view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
            pinchGestureRecognizer.scale = 1;
        }
    }
}

#pragma mark - panGestureRecognize

- (void) panView:(UIPanGestureRecognizer *)panGestureRecognizer
{
    
    UIView *view = panGestureRecognizer.view;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x, view.center.y + translation.y}];
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
    }
}

#pragma mark - setupTapGestureRecognizer

- (void)setupTapGestureRecognize {
    
    //设置tapGesture
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction)];
    tapGesture.delegate = self;
    tapGesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGesture];
    [self.previewImageView addGestureRecognizer:tapGesture];
    
     //设置panGesture
    UIPanGestureRecognizer * panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panView:)];
    panGesture.delegate = self;
    [self.previewImageView addGestureRecognizer:panGesture];
    
    //设置pinchGesture
    UIPinchGestureRecognizer * pinchGesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchView:)];
    pinchGesture.delegate = self;
    [self.previewImageView addGestureRecognizer:pinchGesture];
}

#pragma mark - TapGesture 回调

- (void)tapGestureAction {
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
