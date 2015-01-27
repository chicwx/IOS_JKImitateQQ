//
//  LeftSideViewController.m
//  QQFrame
//
//  Created by dg11185_zal on 14/11/26.
//  Copyright (c) 2014年 dg11185. All rights reserved.
//

#import "LeftSideViewController.h"

@interface LeftSideViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIButton *headButton;//头部按钮视图
    UIButton *myStateButton;//我的签名按钮视图
    UITableView *listTableView;//内容列表视图
    UIView *bottomView;//底部视图
    NSArray *dataArray;//列表数据
    float cellHeight;//单元高度
}

@end

@implementation LeftSideViewController

#pragma mark -View
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    //初始化数据
    [self initData];
    //显示头部按钮视图
    [self showHeadView];
    //显示列表视图
    [self showTableView];
    //显示底部视图
    [self showBottomView];
}

//初始化数据
-(void) initData{
    dataArray = @[@[@"我的QQ会员",@"leftview_vip.png"],
                  @[@"QQ钱包",@"leftview_qq_purse.png"],
                  @[@"网上营业厅",@"leftview_online_shop.png"],
                  @[@"个性装扮",@"leftview_person_decoration.png"],
                  @[@"我的收藏",@"leftview_collection.png"],
                  @[@"我的文件",@"leftview_file.png"],
                  @[@"我的相册",@"leftview_photo.png"]];
    cellHeight = 45;
}

//头部按钮视图
-(void) showHeadView
{
    float viewWidth = self.view.frame.size.width;
    float headButtonHeight = 60;
    headButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, viewWidth, headButtonHeight)];
    [headButton addTarget:self action:@selector(changeColor:) forControlEvents:UIControlStateHighlighted];
    [headButton addTarget:self action:@selector(clickHeadAction:) forControlEvents:UIControlEventTouchDragExit|UIControlEventTouchUpInside];
    [self.view addSubview:headButton];
    
    float headIvHeight = 55;
    float leftPadding = 30;
    //头像
    UIImageView *headIV = [[UIImageView alloc] initWithFrame:CGRectMake(leftPadding, (headButtonHeight-headIvHeight)/2, headIvHeight, headIvHeight)];
    headIV.layer.cornerRadius = headIvHeight/2;
    headIV.layer.masksToBounds = YES;
    headIV.image = [UIImage imageNamed:@"headIcon.png"];
    headIV.backgroundColor = [UIColor clearColor];
    [headButton addSubview:headIV];
    
    float nameLabelOriginX = headIV.frame.origin.x+headIV.frame.size.width+15;
    //昵称
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabelOriginX, headIV.frame.origin.y, viewWidth-nameLabelOriginX, headIvHeight/2)];
    nameLabel.text = @"我的昵称";
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = [UIFont boldSystemFontOfSize:18];
    [headButton addSubview:nameLabel];
    
    float ivHeight = 15;
    float levelWidth = 30;
    float nameLabelTopPadding = (headIvHeight/2-ivHeight)/2+nameLabel.frame.origin.y+nameLabel.frame.size.height;
    //等级
    UILabel *levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabelOriginX, nameLabelTopPadding, levelWidth, ivHeight)];
    levelLabel.text = @"VIP3";
    levelLabel.textAlignment = NSTextAlignmentCenter;
    levelLabel.backgroundColor = [UIColor redColor];
    levelLabel.textColor = [UIColor whiteColor];
    levelLabel.font = [UIFont boldSystemFontOfSize:12];
    [headButton addSubview:levelLabel];
    //qq等级
    float levelLabelOriginX = nameLabelOriginX+levelWidth+5;
    UIImageView *sunIV = [[UIImageView alloc] initWithFrame:CGRectMake(levelLabelOriginX, nameLabelTopPadding, ivHeight, ivHeight)];
    sunIV.image = [UIImage imageNamed:@"leftview_level_sun.png"];
    sunIV.backgroundColor = [UIColor clearColor];
    [headButton addSubview:sunIV];
    UIImageView *moonIV = [[UIImageView alloc] initWithFrame:CGRectMake(levelLabelOriginX+1*ivHeight, nameLabelTopPadding, ivHeight, ivHeight)];
    moonIV.image = [UIImage imageNamed:@"leftview_level_moon.png"];
    moonIV.backgroundColor = [UIColor clearColor];
    [headButton addSubview:moonIV];
    UIImageView *starIV = [[UIImageView alloc] initWithFrame:CGRectMake(levelLabelOriginX+2*ivHeight, nameLabelTopPadding, ivHeight, ivHeight)];
    starIV.image = [UIImage imageNamed:@"leftview_level_star.png"];
    starIV.backgroundColor = [UIColor clearColor];
    [headButton addSubview:starIV];
    
    float stateHeight = 30;
    //qq签名状态
    myStateButton = [[UIButton alloc] initWithFrame:CGRectMake(0, headButton.frame.origin.y+headButton.frame.size.height+5, viewWidth, stateHeight)];
    [myStateButton addTarget:self action:@selector(changeColor:) forControlEvents:UIControlStateHighlighted];
    [myStateButton addTarget:self action:@selector(clickHeadAction:) forControlEvents:UIControlEventTouchDragExit|UIControlEventTouchUpInside];
    [self.view addSubview:myStateButton];
    //双引号
    float state_child_Height = 15;
    UIImageView *quoteIV = [[UIImageView alloc] initWithFrame:CGRectMake(leftPadding, (stateHeight-state_child_Height)/2, state_child_Height, state_child_Height)];
    quoteIV.image = [UIImage imageNamed:@"leftview_double_quote.png"];
    quoteIV.backgroundColor = [UIColor clearColor];
    [myStateButton addSubview:quoteIV];
    //qq签名
    float quoteOriginX = quoteIV.frame.origin.x+quoteIV.frame.size.width+5;
    UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(quoteOriginX, (stateHeight-state_child_Height)/2, 0.8*viewWidth-quoteOriginX, ivHeight)];
    stateLabel.text = @"我的qq签名状态";
    stateLabel.backgroundColor = [UIColor clearColor];
    stateLabel.textColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    stateLabel.font = [UIFont systemFontOfSize:12];
    [myStateButton addSubview:stateLabel];
}

//主视图
-(void) showTableView
{
    float tableOriginX = myStateButton.frame.origin.y+myStateButton.frame.size.height+5;
    listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, tableOriginX, self.view.frame.size.width, self.view.frame.size.height-tableOriginX-110) style:UITableViewStylePlain];
    listTableView.dataSource = self;
    listTableView.delegate = self;
    listTableView.backgroundColor = [UIColor clearColor];
    listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:listTableView];
}

//底部视图
-(void) showBottomView
{
    float tableOriginY = listTableView.frame.origin.y+listTableView.frame.size.height;
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, tableOriginY, self.view.frame.size.width, 50)];
    bottomView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bottomView];
    
    //设置按钮
    UIButton *settingButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 10, 50, 15)];
    [bottomView addSubview:settingButton];
    //按钮图标
    UIImageView *settingIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    settingIV.image = [UIImage imageNamed:@"leftview_setting.png"];
    settingIV.backgroundColor = [UIColor clearColor];
    [settingButton addSubview:settingIV];
    //按钮文字
    float settingOriginX = settingIV.frame.origin.x+settingIV.frame.size.width+5;
    UILabel *settingLabel = [[UILabel alloc] initWithFrame:CGRectMake(settingOriginX, 0, 30, 15)];
    settingLabel.text = @"设置";
    settingLabel.backgroundColor = [UIColor clearColor];
    settingLabel.textColor = [UIColor colorWithWhite:0.8 alpha:0.5];
    settingLabel.font = [UIFont systemFontOfSize:12];
    [settingButton addSubview:settingLabel];
    
    //夜间模式切换按钮
    UIButton *modeButton = [[UIButton alloc] initWithFrame:CGRectMake(settingButton.frame.origin.x+100, 10, 50, 15)];
    [bottomView addSubview:modeButton];
    //按钮图标
    UIImageView *modeIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    modeIV.image = [UIImage imageNamed:@"leftview_night_mode.png"];
    modeIV.backgroundColor = [UIColor clearColor];
    [modeButton addSubview:modeIV];
    //按钮文字
    float modeOriginX = modeIV.frame.origin.x+modeIV.frame.size.width+5;
    UILabel *modeLabel = [[UILabel alloc] initWithFrame:CGRectMake(modeOriginX, 0, 30, 15)];
    modeLabel.text = @"夜间";
    modeLabel.backgroundColor = [UIColor clearColor];
    modeLabel.textColor = [UIColor colorWithWhite:0.8 alpha:0.5];
    modeLabel.font = [UIFont systemFontOfSize:12];
    [modeButton addSubview:modeLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    //NSArray *sectionArray = [dataArray objectAtIndex:section];
    return dataArray.count;
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
    float ivHeight = 30;
    UIImageView *toolIV = [[UIImageView alloc] initWithFrame:CGRectMake(30, (cellHeight-ivHeight)/2, ivHeight, ivHeight)];
    toolIV.image = [UIImage imageWithCGImage:[UIImage imageNamed:[[dataArray objectAtIndex:indexPath.row] objectAtIndex:1]].CGImage scale:2 orientation:UIImageOrientationUp];
    [bgView addSubview:toolIV];
    //字
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(toolIV.frame.origin.x+toolIV.frame.size.width+10, toolIV.frame.origin.y, 100, ivHeight)];
    textLabel.text = [[dataArray objectAtIndex:indexPath.row] objectAtIndex:0];
    textLabel.textColor = [UIColor whiteColor];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:textLabel];

    //设置选中时的颜色
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
    return cell;
}
//选中
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //通知框架打开新界面
    [[NSNotificationCenter defaultCenter] postNotificationName:@"openNewViewController" object:nil];
}

#pragma mark -Other
//点击高亮
-(void) changeColor:(UIButton*)sender
{
    sender.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.3];
}
//点击头部事件
-(void) clickHeadAction:(UIButton*)sender
{
    //点击头像
    sender.backgroundColor = [UIColor clearColor];
}


@end
