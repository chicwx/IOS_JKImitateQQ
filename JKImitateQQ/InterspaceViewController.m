//
//  InterspaceViewController.m
//  QQFrame
//
//  Created by dg11185_zal on 14/11/27.
//  Copyright (c) 2014年 dg11185. All rights reserved.
//

#import "InterspaceViewController.h"

@interface InterspaceViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    float cellHeight;
}

@end

@implementation InterspaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    cellHeight = 45;
    //显示导航栏
    [self showNavigateView];
    //显示主视图
    [self showMainView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//导航栏
-(void) showNavigateView
{
    //显示按钮
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 25)];
    [button setTitle:@"管理" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightButton;
    self.navigationItem.rightBarButtonItem = rightButton;
}
//主视图
-(void) showMainView
{
    float viewWidth = self.view.frame.size.width;
    //tableHeaderView
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 80)];
    tableHeaderView.backgroundColor = [UIColor clearColor];
    
    //按钮组视图
    float viewHeight = 60;
    NSArray *buttonImgArray = [NSArray arrayWithObjects:@"contacts_circle.png",@"contacts_address_book.png",@"contacts_groups.png",nil];
    NSArray *buttonTextArray = [NSArray arrayWithObjects:@"好友动态",@"附近的人",@"兴趣部落",nil];
    NSInteger buttonCount = buttonImgArray.count;
    float btnWidth = viewWidth/buttonCount;
    float btnTopPadding = 0;
    float ivHeight = 30;
    float ivTopPadding = (viewHeight-ivHeight)/2-5;
    float ivLeftPadding = (btnWidth-ivHeight)/2;
    //添加按钮组
    for (int i=0; i<buttonCount; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i*btnWidth, btnTopPadding, btnWidth, viewHeight)];
        [tableHeaderView addSubview:button];
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
    //横条
    UIView *qqView = [[UIView alloc] initWithFrame:CGRectMake(0, btnTopPadding+viewHeight, viewWidth, 20)];
    qqView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    [tableHeaderView addSubview:qqView];
    
    //列表视图
    UITableView *contactsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, self.view.frame.size.height) style:UITableViewStylePlain];
    contactsTableView.dataSource = self;
    contactsTableView.delegate = self;
    contactsTableView.tableHeaderView = tableHeaderView;
    [self.view addSubview:contactsTableView];
}

#pragma mark -Other



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
    return 10;
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
    //文字
    cell.textLabel.text = @"好友动态";
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    
    return cell;
}
//选中
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //通知事件（通知ViewController开启手势）
    [[NSNotificationCenter defaultCenter] postNotificationName:@"openPanGesture" object:nil];
}

@end
