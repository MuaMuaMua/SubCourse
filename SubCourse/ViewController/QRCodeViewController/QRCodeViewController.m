//
//  QRCodeViewController.m
//  SubCourse
//
//  Created by wuhaibin on 15/12/1.
//  Copyright © 2015年 wuhaibin. All rights reserved.
//

#import "QRCodeViewController.h"
#import "ZBarSDK.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define SCANVIEW_EdgeTop ScreenHeight*0.25

#define SCANVIEW_EdgeLeft 60.0
#define TINTCOLOR_ALPHA 0.2 //浅色透明度
#define DARKCOLOR_ALPHA 0.5 //深色透明度
#define winSize [[UIScreen mainScreen]bounds]

@interface QRCodeViewController ()<ZBarReaderViewDelegate>{
    UIView *_QrCodeline;
    NSTimer *_timer;
    //设置扫描画面
    UIView *_scanView;
    ZBarReaderView *_readerView;
    NSString *   _symbolStr;
//    CGFloat SCANVIEW_EdgeTop;
    BOOL up;
    //NSString *_symbolStr;}
}
@end

@implementation QRCodeViewController
	
- ( void )viewDidLoad
{
    [ super viewDidLoad ];
    up = NO;
//    SCANVIEW_EdgeTop = SCANVIEW_EdgeTopRate * ScreenHeight;
    self.presentedViewController.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //currentVC.view.top = -20.0f;
    self.title = @"扫描二维码" ;
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setHidden:NO];
    //初始化扫描界面
    [ self setScanView ];
    _readerView = [[ ZBarReaderView alloc ] init ];
    _readerView . frame = CGRectMake ( 0 , 64 - 20 , ScreenWidth , ScreenHeight);
    _readerView . tracksSymbols = NO ;
    _readerView . readerDelegate = self ;
    [ _readerView addSubview : _scanView ];
    //关闭闪光灯
    _readerView . torchMode = 0 ;
    [ self . view addSubview : _readerView ];
    //扫描区域
    //readerView.scanCrop =
    [ _readerView start ];
    [ self createTimer ];
}

#pragma mark -- ZBarReaderViewDelegate
-( void )readerView:( ZBarReaderView *)readerView didReadSymbols:( ZBarSymbolSet *)symbols fromImage:( UIImage *)image
{
    const zbar_symbol_t *symbol = zbar_symbol_set_first_symbol (symbols. zbarSymbolSet );
    _symbolStr = [ NSString stringWithUTF8String : zbar_symbol_get_data (symbol)];
    //判断是否包含 头'http:'
    NSString *regex = @"http+:[^//s]*" ;
    NSPredicate *predicate = [ NSPredicate predicateWithFormat : @"SELF MATCHES %@" ,regex];
    
    //判断是否包含 头'ssid:'
    NSString *ssid = @"ssid+:[^//s]*" ;;
    NSPredicate *ssidPre = [ NSPredicate predicateWithFormat : @"SELF MATCHES %@" ,ssid];
    if ([predicate evaluateWithObject :_symbolStr]) {
        
    }else if ([ssidPre evaluateWithObject :_symbolStr]){
        NSArray *arr = [_symbolStr componentsSeparatedByString : @";" ];
        NSArray * arrInfoHead = [[arr objectAtIndex : 0 ] componentsSeparatedByString : @":" ];
        NSArray * arrInfoFoot = [[arr objectAtIndex : 1 ] componentsSeparatedByString : @":" ];
        _symbolStr = [ NSString stringWithFormat : @"ssid: %@ /n password:%@" ,
                      [arrInfoHead objectAtIndex : 1 ],[arrInfoFoot objectAtIndex : 1 ]];
        UIPasteboard *pasteboard=[ UIPasteboard generalPasteboard ];
        //然后，可以使用如下代码来把一个字符串放置到剪贴板上：
        pasteboard. string = [arrInfoFoot objectAtIndex : 1 ];
        //[MBProgressHUD showSuccess:[arrInfoFoot objectAtIndex : 1 ]];
    }
    
    //根据_symbolStr进行判断
    if(_symbolStr.length != 13){
        //如果回调得到的二维码的长度不等于13 的部分
        UIAlertView *alertView=[[ UIAlertView alloc ] initWithTitle : @"无效二维码" message :_symbolStr delegate : nil cancelButtonTitle : @"取消" otherButtonTitles : nil ];
        [alertView show ];
    }else{
        NSString *codeString = [_symbolStr substringFromIndex:10];
        int code = [codeString intValue];
        if (code < 0) {
            UIAlertView *alertView=[[ UIAlertView alloc ] initWithTitle : @"无法识别此二维码" message :codeString delegate : nil cancelButtonTitle : @"取消" otherButtonTitles : nil ];
            [alertView show ];
        }else{
        // 直接跳转到具体的试卷的第一页的第一题
//            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"二维码扫描成功" message:codeString delegate:nil
//        cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alertView show];
            
        }
    }
}

#pragma mark - 跳转到具体的题目的vc

- (void)pushToVC{
    
}

#pragma mark - 二维码识别后的回调跳转

- (void)showQRCodeDetail{
    
}

#pragma mark - The effect

//二维码的扫描区域
- ( void )setScanView
{
    _scanView =[[ UIView alloc ] initWithFrame : CGRectMake ( 0 , 0 , ScreenWidth , ScreenHeight - 64 )];
    _scanView . backgroundColor =[ UIColor clearColor ];
    //最上部view
    UIView * upView = [[ UIView alloc ] initWithFrame : CGRectMake ( 0 , 0 , ScreenWidth , SCANVIEW_EdgeTop )];
    upView. alpha = TINTCOLOR_ALPHA ;
    upView. backgroundColor = [ UIColor blackColor ];
    [ _scanView addSubview :upView];
    //左侧的view
    UIView *leftView = [[ UIView alloc ] initWithFrame : CGRectMake ( 0 , SCANVIEW_EdgeTop , SCANVIEW_EdgeLeft , ScreenWidth - 2 * SCANVIEW_EdgeLeft )];
    leftView. alpha = TINTCOLOR_ALPHA ;
    leftView. backgroundColor = [ UIColor blackColor ];
    [ _scanView addSubview :leftView];
    /******************中间扫描区域****************************/
    UIImageView *scanCropView=[[ UIImageView alloc ] initWithFrame : CGRectMake ( SCANVIEW_EdgeLeft , SCANVIEW_EdgeTop , ScreenWidth - 2 * SCANVIEW_EdgeLeft , ScreenWidth - 2 * SCANVIEW_EdgeLeft )];
    //scanCropView.image=[UIImage imageNamed:@""];
    scanCropView. layer . borderColor =[ UIColor lightGrayColor ]. CGColor ;
    scanCropView. layer . borderWidth = 1.0 ;
    scanCropView. backgroundColor =[ UIColor clearColor ];
    [ _scanView addSubview :scanCropView];
    //右侧的view
    UIView *rightView = [[ UIView alloc ] initWithFrame : CGRectMake ( ScreenWidth - SCANVIEW_EdgeLeft , SCANVIEW_EdgeTop , SCANVIEW_EdgeLeft , ScreenWidth - 2 * SCANVIEW_EdgeLeft )];
    rightView. alpha = TINTCOLOR_ALPHA ;
    rightView. backgroundColor = [ UIColor blackColor ];
    [ _scanView addSubview :rightView];
    //底部view
    UIView *downView = [[ UIView alloc ] initWithFrame : CGRectMake ( 0 , ScreenWidth - 2 * SCANVIEW_EdgeLeft + SCANVIEW_EdgeTop , ScreenWidth , ScreenHeight -( ScreenWidth - 2 * SCANVIEW_EdgeLeft + SCANVIEW_EdgeTop ))];
    //downView.alpha = TINTCOLOR_ALPHA;
    downView. backgroundColor = [[ UIColor blackColor ] colorWithAlphaComponent : TINTCOLOR_ALPHA ];
    [ _scanView addSubview :downView];
    //用于说明的label
    UILabel *labIntroudction= [[ UILabel alloc ] init ];
    labIntroudction. backgroundColor = [ UIColor clearColor ];
    labIntroudction. frame = CGRectMake ( 0 , 5 , ScreenWidth , 20 );
    labIntroudction. numberOfLines = 1 ;
    labIntroudction. font =[ UIFont systemFontOfSize : 15.0 ];
    labIntroudction. textAlignment = NSTextAlignmentCenter ;
    labIntroudction. textColor =[ UIColor whiteColor ];
    labIntroudction. text = @"将二维码对准方框，即可自动扫描" ;
    //画中间的基准线
    _QrCodeline = [[ UIView alloc ] initWithFrame : CGRectMake ( SCANVIEW_EdgeLeft , SCANVIEW_EdgeTop , ScreenWidth - 2 * SCANVIEW_EdgeLeft , 2 )];
    _QrCodeline . backgroundColor = [ UIColor lightGrayColor];
    [ _scanView addSubview : _QrCodeline ];
}

- ( void )openLight
{
    if ( _readerView . torchMode == 0 ) {
        _readerView . torchMode = 1 ;
    } else
    {
        _readerView . torchMode = 0 ;
    }
}
- ( void )viewWillDisappear:( BOOL )animated
{
    [ super viewWillDisappear :animated];
    if ( _readerView . torchMode == 1 ) {
        _readerView . torchMode = 0 ;
    }
    [ self stopTimer ];
    [ _readerView stop ];
}


//二维码的横线移动
- ( void )moveUpAndDownLine
{
    CGFloat Y= _QrCodeline . frame . origin . y ;
    NSLog(@"UP %hhd Y %f",up,Y);
    //CGRectMake(SCANVIEW_EdgeLeft, SCANVIEW_EdgeTop, ScreenWidth-2*SCANVIEW_EdgeLeft, 1)]
    if (!up){
        up = true;
        [UIView animateWithDuration:0.9 animations:^{
            _QrCodeline.frame=CGRectMake(SCANVIEW_EdgeLeft, SCANVIEW_EdgeTop -1, ScreenWidth- 2 *SCANVIEW_EdgeLeft, 2 );
        }];
    } else{
        up = false;
        [UIView animateWithDuration:0.9 animations:^{
            _QrCodeline.frame=CGRectMake(SCANVIEW_EdgeLeft, ScreenWidth- 2 * SCANVIEW_EdgeLeft + SCANVIEW_EdgeTop -1, ScreenWidth- 2 *SCANVIEW_EdgeLeft, 2 );
        }];
    }
}


- ( void )createTimer
{
    //创建一个时间计数
    _timer=[NSTimer scheduledTimerWithTimeInterval: 1.0 target: self selector: @selector (moveUpAndDownLine) userInfo: nil repeats: YES ];
}
- ( void )stopTimer
{
    if ([_timer isValid] == YES ) {
        [_timer invalidate];
        _timer = nil ;
    }
}
- ( void )didReceiveMemoryWarning
{
    [ super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
