//
//  MessageViewController.m
//  QQFrame
//
//  Created by dg11185_zal on 14/11/27.
//  Copyright (c) 2014年 dg11185. All rights reserved.
//

#import "MessageViewController.h"

@interface MessageViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    BOOL isShowListButton;
    UIImageView *showListButtonIV;//显示选择列表按钮视图的点击图标
    UIView *showListButtonView;//显示选择列表按钮视图
    UIView *shieldView;//屏蔽视图
    
    UITableView *messageTableView;//聊天列表视图
    NSMutableArray *messageArray;//聊天列表数据
    float cellHeight;//cell的高度
}

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化数据
    [self initData];
    //显示导航栏
    [self showNavigateView];
    //显示主视图
    [self showMainView];
    //显示选择序列视图
    [self showListButtonView];
}

//初始化数据
-(void) initData
{
    self.view.backgroundColor = [UIColor whiteColor];
    isShowListButton = NO;
    messageArray = [NSMutableArray arrayWithObjects:@"好友",@"马云",@"刘强东",@"雷军",@"马化腾",@"丁磊",@"张朝阳",@"周鸿祎",@"陈天桥",@"史玉柱",@"唐僧",@"孙悟空",@"二师弟",@"三师弟",@"大师兄",@"师父",@"大哥",@"小弟", nil];
    cellHeight = 50;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//导航栏
-(void) showNavigateView
{
    //显示下拉按钮
    showListButtonIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    showListButtonIV.image = [UIImage imageNamed:@"message_arrow.png"];
    showListButtonIV.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showListButton)];
    tapGesture.numberOfTapsRequired = 1;
    [showListButtonIV addGestureRecognizer:tapGesture];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:showListButtonIV];
    self.navigationItem.rightBarButtonItem = rightButton;
    self.navigationItem.rightBarButtonItem = rightButton;
}

//选择序列视图
-(void) showListButtonView
{
    float topPadding = self.navigationController.navigationBar.frame.size.height+[UIApplication sharedApplication].statusBarFrame.size.height;
    float viewWidth = self.view.frame.size.width;
    float viewHeight = 70;
    //屏蔽视图
    shieldView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, self.view.frame.size.height)];
    shieldView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.1];
    [self.view addSubview:shieldView];
    //先隐藏
    shieldView.hidden = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showListButton)];
    tapGesture.numberOfTapsRequired = 1;
    [shieldView addGestureRecognizer:tapGesture];
    
    //按钮选择视图
    showListButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, topPadding-viewHeight, viewWidth, viewHeight)];
    showListButtonView.backgroundColor = [UIColor whiteColor];
    [shieldView addSubview:showListButtonView];
    
    NSArray *buttonImgArray = [NSArray arrayWithObjects:@"message_create_group.png",@"message_conversation.png",@"message_share_photo.png",@"message_qrcode.png", nil];
    NSArray *buttonTextArray = [NSArray arrayWithObjects:@"建讨论组",@"多人通话",@"共享图片",@"扫一扫", nil];
    NSInteger buttonCount = buttonImgArray.count;
    float btnWidth = viewWidth/buttonCount;
    float ivHeight = 30;
    float ivTopPadding = (viewHeight-ivHeight)/2-5;
    float ivLeftPadding = (btnWidth-ivHeight)/2;
    //添加按钮组
    for (int i=0; i<buttonCount; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i*btnWidth, 0, btnWidth, viewHeight)];
        [showListButtonView addSubview:button];
        //添加图标
        UIImageView *btnIV = [[UIImageView alloc] initWithFrame:CGRectMake(ivLeftPadding, ivTopPadding, ivHeight, ivHeight)];
        btnIV.image = [UIImage imageNamed:[buttonImgArray objectAtIndex:i]];
        [button addSubview:btnIV];
        //添加文字
        UILabel *btnLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, ivTopPadding+ivHeight, btnWidth, 15)];
        btnLabel.backgroundColor = [UIColor clearColor];
        btnLabel.font = [UIFont boldSystemFontOfSize:12];
        btnLabel.textColor = [UIColor blackColor];
        btnLabel.textAlignment = NSTextAlignmentCenter;
        btnLabel.text = [buttonTextArray objectAtIndex:i];
        [button addSubview:btnLabel];
    }
}

//主视图
-(void) showMainView
{
    float viewWidth = self.view.frame.size.width;
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 40)];
    searchBar.placeholder = @"搜索";
    searchBar.delegate = self;
    [self.view addSubview:searchBar];

    messageTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, self.view.frame.size.height) style:UITableViewStylePlain];
    messageTableView.dataSource = self;
    messageTableView.delegate = self;
    messageTableView.tableHeaderView = searchBar;
    [self.view addSubview:messageTableView];
}

#pragma mark -Other
//显示下拉选择按钮
-(void) showListButton
{
    isShowListButton = !isShowListButton;
    if (isShowListButton) {
        //显示
        showListButtonIV.transform = CGAffineTransformMakeRotation(M_PI);
        
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = showListButtonView.frame;
            frame.origin.y += frame.size.height;
            showListButtonView.frame = frame;
            shieldView.hidden = NO;
        }];
    }else{
        //隐藏
        showListButtonIV.transform = CGAffineTransformMakeRotation(0.0f);

        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = showListButtonView.frame;
            frame.origin.y -= frame.size.height;
            showListButtonView.frame = frame;
        } completion:^(BOOL finished) {
            shieldView.hidden = YES;
        }];
    }
}

#pragma mark -Delegate
//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
}
//块数
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//行数
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return messageArray.count;
}
//列表单元视图
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    //自定义
    cell.backgroundColor = [UIColor clearColor];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, cellHeight)];
    bgView.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:bgView];
    //图标
    float ivHeight = 40;
    UIImageView *toolIV = [[UIImageView alloc] initWithFrame:CGRectMake(15, (cellHeight-ivHeight)/2, ivHeight, ivHeight)];
    toolIV.image = [UIImage imageNamed:@"headIcon.png"];
    toolIV.layer.cornerRadius = ivHeight/2;
    toolIV.layer.masksToBounds = YES;
    [bgView addSubview:toolIV];
    //字
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(toolIV.frame.origin.x+toolIV.frame.size.width+10, toolIV.frame.origin.y, 100, ivHeight)];
    textLabel.text = [messageArray objectAtIndex:indexPath.row];
    textLabel.textColor = [UIColor blackColor];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.font = [UIFont systemFontOfSize:16];
    [bgView addSubview:textLabel];

    return cell;
}
//选中
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//UISearchBarDelegate
-(BOOL) searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    searchBar.showsCancelButton = YES;
    return YES;
}
-(void) searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    searchBar.showsCancelButton = NO;
    
    [searchBar resignFirstResponder];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //通知事件（通知ViewController开启手势）
    [[NSNotificationCenter defaultCenter] postNotificationName:@"openPanGesture" object:nil];
}

@end
