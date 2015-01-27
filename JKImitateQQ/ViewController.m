//
//  ViewController.m
//  QQFrame
//
//  Created by dg11185_zal on 14/11/24.
//  Copyright (c) 2014年 dg11185. All rights reserved.
//

#import "ViewController.h"
#import "OpenNewViewController.h"

#define LEFTSCALE 0.8
#define MAINSCALE 0.7

@interface ViewController ()
{
    UIView *mainView;//主视图
    UIView *leftView;//左侧视图
    BOOL isShowLeft;//显示左侧视图的标记
    float leftViewWidth;//左侧视图的宽度
    float leftViewOriginX;//初始化左侧视图的位置
    float scaleX;//总移动距离(用于缩放)
    UITapGestureRecognizer *tapGesture;//点击手势
    UIPanGestureRecognizer *panGesture;//拖拽手势
    UIScreenEdgePanGestureRecognizer *edgeGesture;//边缘拖拽手势
    float gestureWidth;//手势视图宽度
    UIView *gestureView;//手势视图
}

@end

@implementation ViewController

@synthesize mainVC,leftVC;

- (void)viewDidLoad {
    [super viewDidLoad];
    float viewWidth = self.view.frame.size.width;
    float viewHeight = self.view.frame.size.height;
    //把视图分为上下半
    UIImageView *topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 100)];
    topView.image = [UIImage imageNamed:@"leftview_bg.jpg"];
    [self.view addSubview:topView];
    UIImageView *bottomView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, viewWidth, viewHeight-100)];
    bottomView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    UIImage *bgImg = [UIImage imageNamed:@"leftview_bg_mask.png"];
    bgImg = [bgImg stretchableImageWithLeftCapWidth:0 topCapHeight:bgImg.size.height-1];
    [bottomView setImage:bgImg];
    [self.view addSubview:bottomView];
    
    isShowLeft = NO;
    leftViewWidth = 0.8*viewWidth;
    leftViewOriginX = viewWidth-leftViewWidth;
    scaleX = 0.0f;
    gestureWidth = 20;

    //添加左侧视图
    leftView = leftVC.view;
    leftView.autoresizesSubviews = YES;
    leftView.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
    leftView.frame = CGRectMake(-leftViewOriginX, 60, viewWidth, viewHeight-60);
    [self.view addSubview:leftView];
    
    //添加主视图
    mainView = mainVC.view;
    mainView.autoresizesSubviews = YES;
    mainView.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    mainView.frame = self.view.bounds;
    [self.view addSubview:mainView];
    
    //左侧添加一个边缘手势视图
    gestureView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, gestureWidth, viewHeight)];
    gestureView.backgroundColor = [UIColor clearColor];
    [mainView addSubview:gestureView];
    
    //添加点击手势
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showLeftView)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.enabled = NO;
    [gestureView addGestureRecognizer:tapGesture];
    
//    //添加边缘拖拽手势
//    edgeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftView:)];
//    edgeGesture.edges = UIRectEdgeLeft;
//    [mainView addGestureRecognizer:edgeGesture];
    
    //添加拖拽手势
    panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftView:)];
    [gestureView addGestureRecognizer:panGesture];
    
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openNewViewController) name:@"openNewViewController" object:nil];
    //通知事件（通知开启手势）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openPanGesture) name:@"openPanGesture" object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//手势点击事件
-(void) showLeftView{
    if (isShowLeft) {
        //动画
        [UIView animateWithDuration:0.5 animations:^{
            //左侧视图隐藏
            CGRect leftFrame = leftView.frame;
            leftFrame.origin.x = -leftViewOriginX;
            leftView.frame = leftFrame;
            leftView.transform = CGAffineTransformMakeScale(1.0, LEFTSCALE);
            //右侧视图左移
            CGRect mainFrame = mainView.frame;
            mainFrame.origin.x = 0;
            mainView.frame = mainFrame;
            mainView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
        tapGesture.enabled = NO;
        CGRect gestureFrame = tapGesture.view.frame;
        gestureFrame.size.width = gestureWidth;
        tapGesture.view.frame = gestureFrame;
    }
    else{
        //动画
        [UIView animateWithDuration:0.5 animations:^{
            //左侧视图出现
            CGRect leftFrame = leftView.frame;
            leftFrame.origin.x = 0;
            leftView.frame = leftFrame;
            leftView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            //右侧视图右移
            CGRect mainFrame = mainView.frame;
            mainFrame.origin.x = leftViewWidth;
            mainView.frame = mainFrame;
            mainView.transform = CGAffineTransformMakeScale(1.0, MAINSCALE);
        }];
        tapGesture.enabled = YES;
        CGRect gestureFrame = tapGesture.view.frame;
        gestureFrame.size.width = leftViewOriginX;
        tapGesture.view.frame = gestureFrame;
    }
    isShowLeft = !isShowLeft;
}

//手势滑动事件
-(void) swipeLeftView:(UIScreenEdgePanGestureRecognizer*)sender{
    CGFloat moveX = [sender translationInView:sender.view].x;
    scaleX += moveX;
    
    CGRect mainFrame = mainView.frame;
    CGRect leftFrame = leftView.frame;
    
    NSLog(@"scaleX is %f,moveX is %f,mainFrame.origin.x is %f,leftViewWidth is %f",scaleX,moveX,mainFrame.origin.x,leftViewWidth);
    
    //根据视图位置判断是左滑还是右边滑动
    if (sender.state==UIGestureRecognizerStateBegan || sender.state==UIGestureRecognizerStateChanged) {

        //视图随手势移动
        mainFrame.origin.x += moveX;
        leftFrame.origin.x += moveX*leftViewOriginX/leftViewWidth;
        if (mainFrame.origin.x>leftViewWidth-2) {
            mainFrame.origin.x = leftViewWidth;
            leftFrame.origin.x = 0;
            scaleX = 0;
            isShowLeft = YES;
        }
        
        if (mainFrame.origin.x<0.0f+2) {
            mainFrame.origin.x = 0.0f;
            leftFrame.origin.x = -leftViewOriginX;
            scaleX = 0;
            isShowLeft = NO;
        }
        mainView.frame = mainFrame;
        leftView.frame = leftFrame;

        if(scaleX>0)
        {

            float scale1 = LEFTSCALE+(1-LEFTSCALE)*scaleX/leftViewWidth;
            float scale2 = 1-(1-MAINSCALE)*scaleX/leftViewWidth;
            NSLog(@"scale1 is %f,scale2 is %f,scaleX is %f",scale1,scale2,scaleX);
                    
            if (scale1<1)
            {
                leftView.transform = CGAffineTransformMakeScale(1,scale1);
                mainView.transform = CGAffineTransformMakeScale(1,scale2);
            }else
            {
                NSLog(@"??????????");
            }
        }
            
        else if (scaleX<0)
        {
                
            float scale3 = 1+(1-LEFTSCALE)*scaleX/leftViewWidth;
            float scale4 = MAINSCALE-(1-MAINSCALE)*scaleX/leftViewWidth;
            NSLog(@"scale3 ??? is %f,scale4 is %f，scaleX＝%f",scale3,scale4,scaleX);
                
            if (scale3<1)
            {
                leftView.transform = CGAffineTransformMakeScale(1,scale3);
                mainView.transform = CGAffineTransformMakeScale(1,scale4);
            }
        }
        
        
        
//        else
//        {
//            mainFrame.origin.x = 256.0f;
//            mainView.frame = mainFrame;
//            leftFrame.origin.x += moveX*leftViewOriginX/leftViewWidth;
//            leftView.frame = leftFrame;
//        
//        }

            [sender setTranslation:CGPointZero inView:sender.view];
        
    }
    
    if (sender.state==UIGestureRecognizerStateEnded) {
      
    //手势结束后修正位置
        if (scaleX>64){
            //隐藏主视图，显示左侧视图
            [self hideMainView];
            isShowLeft = !isShowLeft;
        }
        else if (scaleX<-64) {
            //显示主视图，隐藏左侧视图
            [self showMainView];
            isShowLeft = !isShowLeft;
        }
        else
        {
            //移动距离不够大，还原视图的位置
            if (isShowLeft) {
                //隐藏主视图，显示左侧视图
                [self hideMainView];
            }else{
                //显示主视图，隐藏左侧视图
                [self showMainView];
            }
        }
        
        scaleX = 0.0f;
    }

}

#pragma mark -Helper
//显示主视图，隐藏左侧视图
-(void) showMainView{
    CGRect mainFrame = mainView.frame;
    CGRect leftFrame = leftView.frame;
    //动画执行
    [UIView beginAnimations:nil context:nil];
    mainFrame.origin.x = 0;
    mainView.frame = mainFrame;
    mainView.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
    leftFrame.origin.x = -leftViewOriginX;
    leftView.frame = leftFrame;
    leftView.transform = CGAffineTransformMakeScale(1.0,LEFTSCALE);
    [UIView commitAnimations];
    tapGesture.enabled = NO;
    CGRect gestureFrame = tapGesture.view.frame;
    gestureFrame.size.width = gestureWidth;
    tapGesture.view.frame = gestureFrame;
}
//隐藏主视图，显示左侧视图
-(void) hideMainView{
    CGRect mainFrame = mainView.frame;
    CGRect leftFrame = leftView.frame;
    //动画执行
    [UIView beginAnimations:nil context:nil];
    mainFrame.origin.x = leftViewWidth;
    mainView.frame = mainFrame;
    mainView.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,MAINSCALE);
    leftFrame.origin.x = 0;
    leftView.frame = leftFrame;
    leftView.transform = CGAffineTransformMakeScale(1.0,1.0);
    [UIView commitAnimations];
    tapGesture.enabled = YES;
    CGRect gestureFrame = tapGesture.view.frame;
    gestureFrame.size.width = leftViewOriginX;
    tapGesture.view.frame = gestureFrame;
}

//通知事件，打开新界面
-(void) openNewViewController
{
    [self showMainView];
    OpenNewViewController *onVC = [[OpenNewViewController alloc] init];
    NSInteger viewIndex = ((UITabBarController*)self.mainVC).selectedIndex;
    [self.mainVC.childViewControllers[viewIndex] pushViewController:onVC animated:NO];
    gestureView.userInteractionEnabled = NO;
}

//openPanGesture开启手势
-(void) openPanGesture
{
    gestureView.userInteractionEnabled = YES;
}


@end
