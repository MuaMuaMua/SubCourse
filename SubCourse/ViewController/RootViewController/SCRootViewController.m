//
//  SCRootViewController.m
//  SubCourse
//
//  Created by wuhaibin on 15/11/27.
//  Copyright © 2015年 wuhaibin. All rights reserved.
//

#import "SCRootViewController.h"
#import "AppDelegate.h"
#import "QRCodeViewController.h"

@interface SCRootViewController (){
    AppDelegate * _appDelegate;
//    UIBarButtonItem * _rightBtn;
}

@end

@implementation SCRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _appDelegate = [[UIApplication sharedApplication]delegate];
    [self initNavigator];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initNavigator {
    UIButton * navigationLeftBtn = [[UIButton  alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [navigationLeftBtn setImage:[UIImage imageNamed:@"LeftBtn"] forState:UIControlStateNormal];
    [navigationLeftBtn addTarget:_appDelegate.slideNavigator action:@selector(slideButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithCustomView:navigationLeftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.qrCodeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.qrCodeBtn setImage:[UIImage imageNamed:@"QRCode"] forState:UIControlStateNormal];

    [self.qrCodeBtn addTarget:self action:@selector(clickQRCodeBtn) forControlEvents:UIControlEventTouchUpInside];
    _rightBtn = [[UIBarButtonItem alloc]initWithCustomView:self.qrCodeBtn];
//    _rightBtn.customView setHidden:
    self.navigationItem.rightBarButtonItem = _rightBtn;
}

- (void)clickLeftBtn {
    
}

//- (void)clickQRCodeBtn {
//    NSString * mediaType = AVMediaTypeVideo;
//    AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
//    if (authorizationStatus == AVAuthorizationStatusRestricted|| authorizationStatus == AVAuthorizationStatusDenied) {
//        UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"摄像头访问受限" message:nil preferredStyle:UIAlertControllerStyleAlert];
//        [self presentViewController:alertC animated:YES completion:nil];
//        UIAlertAction * action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//            [self dismissViewControllerAnimated:YES completion:nil];
//        }];
//        [alertC addAction:action];
//    }else{
//        QRCodeViewController * qrcvc = [[QRCodeViewController alloc]init];
//        //    [self presentViewController:qrcvc animated:YES completion:nil];
//        [self.navigationController pushViewController:qrcvc animated:YES];
//    }
//}

@end
