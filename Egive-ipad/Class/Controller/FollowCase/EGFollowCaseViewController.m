//
//  EGFollowCaseViewController.m
//  Egive-ipad
//
//  Created by User01 on 15/11/19.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGFollowCaseViewController.h"
#import "EGClickCharityCell.h" //列表cell
#import "EGHomeModel.h"
#import "EGLoginViewController.h"
#import "EGScrollView.h"
#import "EGClickCharityModel.h"
#import "EGHomeCellView.h"

#define FONT  [UIFont systemFontOfSize:14]  //cell字体
//标题
#define titleMinFont 14
#define titleFont 16
#define titleMaxFont 20

@interface EGFollowCaseViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,EGClickCharityDelegate>
{
    UIFont *_font;
}

@property (strong, nonatomic) EGClickCharityModel * model;//cell数据模型
@property (nonatomic,strong) UIScrollView * nameScrollView;//大标题背景
@property (nonatomic,strong) UIScrollView * titleScrollView;//小标题背景
@property (nonatomic,strong) NSArray * nameFlagArray;//小标题标示符数组
@property (nonatomic,strong) NSString * nameString;
@property (nonatomic,strong) NSArray * titleArray;//小标题数组
@property (nonatomic,strong) NSArray * flagArray;//小标题标示符数组
@property (nonatomic,strong) UITableView * FRtableView;
@property (nonatomic,strong) NSMutableArray * cellArray;//cell数据
@property (nonatomic,strong) NSString * searchTitle; //搜索内容

@property (nonatomic,strong) NSDictionary * categoryDict; //???????

@property (nonatomic,strong) NSDictionary * cellIndexDic;//标示显示哪个详情index
@property (nonatomic,strong) NSString * VCString;//标示从首页跳过来
@property (nonatomic,strong) NSString * BBString;//标示(天使行动&&最新专案)

@property (nonatomic,strong) NSMutableArray * IDarray;//购物车ID
@property (nonatomic,strong) NSString * memberString;//MemberID表示符

@property (nonatomic,strong) EGLoginTool * EGLT;

//右边详情页
@property (nonatomic,strong) UIScrollView * bgScrollView;//右滚动视图背景

@property (nonatomic,strong) UIImageView * JDbgImageView;//进度背景
@property (strong, nonatomic) UIProgressView * progress;//进度条
@property (nonatomic,strong) UIImageView * people;//人图像
@property (nonatomic,strong) UIImageView * heartImage;//心按钮
@property (nonatomic,strong) UILabel * proportionLabel;//比例
@property (nonatomic,strong) UILabel * timeLabel; //剩余时间
@property (nonatomic,strong) UIButton * JDButton;//进度报告

@property (nonatomic,strong) UIImageView * TPbgImageView;//图片背景
@property (nonatomic,strong) UILabel * YCLabel; //已筹金额lb
@property (nonatomic,strong) UILabel * MBLabel; //目标金额lb
@property (nonatomic,strong) UILabel * JZLabel; //捐赠者lb
@property (nonatomic,strong) UILabel * SZFLabel; //送祝福lb
@property (nonatomic,strong) EGScrollView * loopScrollView;//滚动图片
@property (nonatomic,strong) UIImageView * LBImage;//类别图片
@property (nonatomic,strong) UILabel * titleLabel; //标题lb
@property (nonatomic,strong) UIButton * SCButton;//收藏图片按钮

@property (nonatomic,strong) UIImageView * ZYbgImageView;//摘要背景

@property (nonatomic,strong) UIImageView * NRbgImageView;//内容背景
@property (nonatomic,strong) NSArray * NRtitleArray;//内容标题数组
@property (nonatomic,strong) UITableView * OCTableView;
@property (nonatomic,strong) NSMutableArray * selectedArr;//选中标识数组
@property (nonatomic) CGSize retSize;//cell高度

@property (nonatomic,strong) UIImageView * LSbgImageView;//类似个案背景
@property (nonatomic,strong) UIScrollView * LSScrollView;//类似个案图片背景

@property (nonatomic,strong) UIImageView * TBbgImageView;//Tabar背景
@property (nonatomic,strong) UIButton * ZFButton;//送上祝福
@property (nonatomic,strong) UIButton * JKButton;//立即捐款

@property (nonatomic,strong) NSDictionary * detailDicData;//详情页数据
@property (nonatomic,strong) NSDictionary * LXDic;//类型图标
@property (nonatomic,strong) NSString * CategoryString;//类型表识

@property (nonatomic,strong) NSString * caseId;//区分不同的个案

@property (nonatomic,strong) NSString * CString;//用来收藏刷新

@property (nonatomic,strong) UIButton * favouriteButton;//尾部视图收藏按钮
@property (nonatomic,strong) UIImageView * ZTView;//尾部视图成功筹募

@property (nonatomic,strong) NSTimer * timerView;//刷新金额
@property (nonatomic,assign) BOOL isSwap;

@property (nonatomic,assign) int cellIndex;//记录点击cell

@property (nonatomic,strong) UIImageView * fontView;//字体调整背景
@property (nonatomic,assign) float tableVFont;//字体大小

@end

@implementation EGFollowCaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:233/255.0 green:234/255.0 blue:235/255.0 alpha:1];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"newsNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FollowCaseShare" object:nil];
}

-(void)setMenoryDate
{
    self.timerView = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(timerViewAction) userInfo:nil repeats:YES];
    self.isSwap = YES;
}

- (void)timerViewAction{
    
    if (self.isSwap) {
        self.isSwap = NO;
        
    }else{
        self.isSwap = YES;
    }
    [self.FRtableView reloadData];
}


-(void)viewWillAppear:(BOOL)animated
{
    self.EGLT=[EGLoginTool loginSingleton];
    if (self.EGLT.isLoggedIn) {
        self.tableVFont=titleFont;
        [self setModel];
        [self setTitleScrollView];
        [self SetTableView];
        [self setMenoryDate];
    }
}

#pragma mark - 初始化储存器
-(void)setModel
{
    EGUserModel * UModel=[self.EGLT currentUser];
    if (UModel.MemberID == nil) {
        self.memberString=@"";
    }
    else
    {
        self.memberString=UModel.MemberID;
    }
    self.selectedArr=[[NSMutableArray alloc] init];
    self.detailDicData=[[NSDictionary alloc] init];
    self.IDarray=[[NSMutableArray alloc] init];
    self.cellArray=[[NSMutableArray alloc] init];
    self.titleArray=@[HKLocalizedString(@"GirdView_selectButton_title"),
                      HKLocalizedString(@"願望一覽"),
                      HKLocalizedString(@"祝福之最"),
                      HKLocalizedString(@"助学"),
                      HKLocalizedString(@"安老"),
                      HKLocalizedString(@"助医"),
                      HKLocalizedString(@"扶贫"),
                      HKLocalizedString(@"紧急援助"),
                      HKLocalizedString(@"意赠行动"),
                      HKLocalizedString(@"其他")];
    self.flagArray=@[@"",
                     @"ANGELACT",
                     @"ANGELACT5",
                     @"S",
                     @"E",
                     @"M",
                     @"P",
                     @"U",
                     @"A",
                     @"O"];
    self.categoryDict= @{@"0":@"", @"1":@"S",
                         @"2":@"E",@"3":@"M",
                         @"4":@"P",@"5":@"U",
                         @"6":@"A",@"7":@"0",};
    self.LXDic= @{@"S":@"comment_list_type_education",
                  @"E":@"comment_list_type_elder",
                  @"U":@"comment_list_type_emergency",
                  @"M":@"comment_list_type_medical",
                  @"P":@"comment_list_type_poverty",
                  @"A":@"comment_list_type_case_list",
                  @"O":@"comment_list_type_others"};
    self.NRtitleArray=@[HKLocalizedString(@"专案内容"),
                        HKLocalizedString(@"受惠者背景"),
                        HKLocalizedString(@"援助需要"),
                        HKLocalizedString(@"心声分享")];
    
    _font = [UIFont systemFontOfSize:16];
}

#pragma mark - 顶部小标题button
- (void)setTitleScrollView{
    self.titleScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth-64, 50)];
    self.titleScrollView.backgroundColor=[UIColor whiteColor];
    self.titleScrollView.userInteractionEnabled=YES;
    self.titleScrollView.showsHorizontalScrollIndicator=NO;
    [self.view addSubview:self.titleScrollView];
    
    for (int i=0; i<self.titleArray.count; i++) {
        UIButton * button=[[UIButton alloc] initWithFrame:CGRectMake(self.titleScrollView.frame.size.width/8*i, 0, self.titleScrollView.frame.size.width/8, 50)];
        button.tag=10+i;
        [self.titleScrollView addSubview:button];
        
        [button setTitle:self.titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:tabarColor forState:UIControlStateSelected];
        
        UILabel * label=[[UILabel alloc] initWithFrame:CGRectMake(0, 50-3, self.titleScrollView.frame.size.width/8, 3)];
        label.tag=50+i;
        [button addSubview:label];
        if (button.tag == 10) {
            label.backgroundColor=tabarColor;
            button.selected=YES;
            self.CString=self.flagArray[button.tag-10];
            [self requestApiData:self.flagArray[button.tag-10] andMemberID:self.memberString];
            [self requestXQData:self.flagArray[button.tag-10] andMemberID:self.memberString];
        }
        
        [button addTarget:self action:@selector(clickTitleButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    self.titleScrollView.contentSize = CGSizeMake(self.titleScrollView.frame.size.width/8*self.titleArray.count, 50);
}

-(void)clickTitleButton:(UIButton *)button{
    //DLOG(@"button.tag==%lu",button.tag);
    for(UIButton * bt in self.titleScrollView.subviews)
    {
        for (UILabel * lb in bt.subviews) {
            lb.backgroundColor=[UIColor clearColor];
        }
    }
    for (int i=0; i<self.titleArray.count; i++) {
        UIButton * butto=(UIButton *)[self.titleScrollView viewWithTag:i+10];
        butto.selected=NO;
    }
    UIButton * but=(UIButton *)[self.titleScrollView viewWithTag:button.tag];
    but.selected=YES;
    UILabel * label=(UILabel *)[but viewWithTag:button.tag+40];
    label.backgroundColor=tabarColor;
    
    self.CString=self.flagArray[button.tag-10];
    [self requestApiData:self.flagArray[button.tag-10] andMemberID:self.memberString];
}


#pragma mark - 设置内容OCTableView

-(void)setOCTableView
{
    //内容背景
    self.NRbgImageView=[[UIImageView alloc] initWithFrame:CGRectMake((screenWidth-64)*2/5+3, 53, screenWidth-64-(screenWidth-64)*2/5-3, screenHeight-103-50)];
    self.NRbgImageView.backgroundColor=[UIColor whiteColor];
    self.NRbgImageView.userInteractionEnabled=YES;
    [self.view addSubview:self.NRbgImageView];
    
    self.OCTableView=[[UITableView alloc] initWithFrame:CGRectMake(20, 0, screenWidth-64-(screenWidth-64)*2/5-3-20*2, screenHeight-103-70) style:UITableViewStylePlain];
    //self.OCTableView=[[UITableView alloc] initWithFrame:CGRectMake(20, 0, self.NRbgImageView.frame.size.width-20*2, 200) style:UITableViewStylePlain];
    self.OCTableView.backgroundColor=[UIColor whiteColor];
    self.OCTableView.delegate=self;
    self.OCTableView.dataSource=self;
    self.OCTableView.separatorStyle = NO;
    self.OCTableView.showsVerticalScrollIndicator = NO;
    //[self.NRbgImageView addSubview:self.OCTableView];
    [self.NRbgImageView addSubview:self.OCTableView];
    
    [self SetDetailView];
    [self setPressView];
}

#pragma mark ScrollView
-(void)SetDetailView
{
    //头部视图背景
    self.bgScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(20+(screenWidth-64)*2/5+5, 105, screenWidth-64-(screenWidth-64)*2/5-5-20*2, screenHeight-105+8)];
    self.bgScrollView.userInteractionEnabled=YES;
    self.bgScrollView.backgroundColor=[UIColor whiteColor];
    self.OCTableView.tableHeaderView=self.bgScrollView;
    
    self.TBbgImageView=[[UIImageView alloc] initWithFrame:CGRectMake((screenWidth-64)*2/5+5, screenHeight-64-50, screenWidth-64-(screenWidth-64)*2/5-5, 50)];
    self.TBbgImageView.userInteractionEnabled=YES;
    self.TBbgImageView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.TBbgImageView];
    [self setTabarButton];
    
    //进度背景
    self.JDbgImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bgScrollView.frame.size.width, 60)];
    self.JDbgImageView.backgroundColor=[UIColor whiteColor];
    self.JDbgImageView.userInteractionEnabled=YES;
    [self.bgScrollView addSubview:self.JDbgImageView];
    [self setJDView];
    //灰色分割线
    [self setLine:self.JDbgImageView andY:self.JDbgImageView.frame.origin.y+self.JDbgImageView.frame.size.height-2];
    
    //图片背景
    self.TPbgImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, self.JDbgImageView.frame.origin.y+self.JDbgImageView.frame.size.height, self.bgScrollView.frame.size.width, 488)];
    self.TPbgImageView.backgroundColor=[UIColor whiteColor];
    self.TPbgImageView.userInteractionEnabled=YES;
    [self.bgScrollView addSubview:self.TPbgImageView];
    [self setTPView];
    
    //摘要背景
    self.ZYbgImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, self.TPbgImageView.frame.origin.y+self.TPbgImageView.frame.size.height, self.bgScrollView.frame.size.width, 120)];
    self.ZYbgImageView.backgroundColor=[UIColor whiteColor];
    [self.bgScrollView addSubview:self.ZYbgImageView];
    [self setZYView];
    
    NSArray * array=[self.model.SimilarCaseList objectForKey:@"ItemList"];
    if (array.count>0) {
        //尾部视图类似个案
        self.LSbgImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.OCTableView.frame.size.width, (((screenWidth-64-40)/3)*3)/4-10+50)];
        self.LSbgImageView.backgroundColor=[UIColor whiteColor];
        self.LSbgImageView.userInteractionEnabled=YES;
        self.OCTableView.tableFooterView=self.LSbgImageView;
        [self setLine:self.LSbgImageView andY:0];
        
        UILabel * title=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, 200, 30)];
        //title.backgroundColor=[UIColor redColor];
        title.textColor=tabarColor;
        title.text=[NSString stringWithFormat:@"%@ ( %lu )",HKLocalizedString(@"类似个案"),[[self.model.SimilarCaseList objectForKey:@"ItemList"] count]];
        [self.LSbgImageView addSubview:title];
        
        self.LSScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, self.OCTableView.frame.size.width, (((screenWidth-64-40)/3)*3)/4-10)];
        //self.LSScrollView.backgroundColor=[UIColor redColor];
        self.LSScrollView.delegate=self;
        self.LSScrollView.userInteractionEnabled=YES;
        self.LSScrollView.showsHorizontalScrollIndicator = YES;
        self.LSScrollView.showsVerticalScrollIndicator = YES;
        [self.LSbgImageView addSubview:self.LSScrollView];
        
        for (int i=0; i<array.count; i++) {
            NSString *  URL = [SITE_URL stringByAppendingPathComponent:[[array[i] objectForKey:@"ProfilePicURL"] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
            UIImageView * picImage=[[UIImageView alloc] initWithFrame:CGRectMake(((screenWidth-64-40)/3+10)*i, 0, (screenWidth-64-40)/3, (((screenWidth-64-40)/3)*3)/4-10)];
            //picImage.backgroundColor=[UIColor greenColor];
            picImage.userInteractionEnabled=YES;
            picImage.tag=200+i;
            [picImage sd_setImageWithURL:[NSURL URLWithString:URL]];
            [self.LSScrollView addSubview:picImage];
            [self setpurpleView:picImage andDictionary:array[i] andI:i];
            
            UITapGestureRecognizer * TSG=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)];
            [picImage addGestureRecognizer:TSG];
        }
    }
    
    self.LSScrollView.contentSize=CGSizeMake(((screenWidth-64-40)/3+10)*array.count, (((screenWidth-64-40)/3)*3)/4-10);
}

#pragma mark 类似个案点击事件
-(void)clickImage:(UITapGestureRecognizer *)TSG
{
    [self.OCTableView removeFromSuperview];
    NSArray * array=[self.model.SimilarCaseList objectForKey:@"ItemList"];
    [self requestXQData:[array[TSG.view.tag-200] objectForKey:@"CaseID"] andMemberID:self.memberString];
}

//收藏
-(void)clickFavour:(UIButton *)button
{
    NSArray * array=[self.model.SimilarCaseList objectForKey:@"ItemList"];
    if (self.EGLT.isLoggedIn) {
        button.selected=!button.selected;
    }
    if (button.selected) {
        [self AddFavourite:[array[button.tag-500] objectForKey:@"CaseID"]];
    }
    else
    {
        [self DeleteFavourite:[array[button.tag-500] objectForKey:@"CaseID"]];
    }
}

#pragma mark 尾部视图类似个案紫色图
-(void)setpurpleView:(UIImageView *)picImage andDictionary:(NSDictionary *)dic andI:(int)i
{
    EGHomeModel * Model=[[EGHomeModel alloc] init];
    [Model setDictionary:dic];
    
    self.favouriteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
    self.favouriteButton.tag=500+i;
    [picImage addSubview:self.favouriteButton];
    [self.favouriteButton setBackgroundImage:[UIImage imageNamed:@"comment_poster_favourite_nor"] forState:UIControlStateNormal];
    [self.favouriteButton setBackgroundImage:[UIImage imageNamed:@"comment_poster_favourite_sel"] forState:UIControlStateSelected];
    if (Model.Isfavourite) {
        self.favouriteButton.selected=YES;
    }
    [self.favouriteButton addTarget:self action:@selector(clickFavour:) forControlEvents:UIControlEventTouchUpInside];
    
    self.ZTView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75, 75)];
    self.ZTView.image=[UIImage imageNamed:@"comment_poster_complete"];
    [picImage addSubview:self.ZTView];
    self.ZTView.hidden=YES;
    if (Model.Percentage >= 100) {
        self.ZTView.hidden=NO;
    }
    UILabel * succeedLabel =[[UILabel alloc] initWithFrame:CGRectMake(-5, 20, 70, 20)];
    [self.ZTView addSubview:succeedLabel];
    succeedLabel.text=HKLocalizedString(@"筹募");
    succeedLabel.textAlignment = NSTextAlignmentCenter;
    succeedLabel.font = [UIFont systemFontOfSize:12];
    succeedLabel.textColor = [UIColor whiteColor];
    succeedLabel.transform = CGAffineTransformMakeRotation(-M_PI/4);
    
    EGHomeCellView * view = [[EGHomeCellView alloc] initWithFrame:CGRectMake(0, (((screenWidth-64-40)/3)*5)/6-10-80, picImage.frame.size.width, 80)];
    [picImage addSubview:view];
    
    view.backgroundColor=tabarColor;
    if (Model.Category.length>0) {
        view.typeImage.image=[UIImage imageNamed:[self.LXDic objectForKey:[Model.Category substringToIndex:1]]];
    }
    else
    {
        view.typeImage.image=[UIImage imageNamed:[self.LXDic objectForKey:@"O"]];
    }
    view.titleLabel.text = [NSString stringWithFormat:@"%@(%@)",Model.Title,Model.Region];
    view.timeLabel.text = [NSString stringWithFormat:@"%@%@%@",HKLocalizedString(@"GirdView_time_label"),Model.RemainingValue,Model.RemainingUnit];
    view.peopleLabel.text=[NSString stringWithFormat:@"%@%@",HKLocalizedString(@"GirdView_count_label"),Model.DonorCount];
    view.moneyLabel.text=[NSString stringWithFormat:@"%@:$%@",HKLocalizedString(@"HomePage_atm_label"),Model.Amt];
    for (NSString * str in self.IDarray) {
        if ([str isEqualToString:Model.CaseID]) {
            view.CollectButton.selected = YES;
        }
    }
    [view.CollectButton setImage:[UIImage imageNamed:@"common_cart_nor"] forState:UIControlStateNormal];
    [view.CollectButton setImage:[UIImage imageNamed:@"common_cart_sel"] forState:UIControlStateSelected];
    view.CollectButton.tag=10+i;
    [view.CollectButton addTarget:self action:@selector(clickCollectButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * lineLLabel=[[UILabel alloc] initWithFrame:CGRectMake(190, 5, 2, 40)];
    lineLLabel.backgroundColor=[UIColor whiteColor];
    lineLLabel.alpha=0.3;
    
    UILabel * lineDLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 50, picImage.frame.size.width, 1)];
    lineDLabel.backgroundColor=[UIColor whiteColor];
    lineDLabel.alpha=0.3;
    
    [view addSubview:lineLLabel];
    [view addSubview:lineDLabel];
    
    self.progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progress.frame = CGRectMake(40, 37, 85, 2);
    //self.progress.backgroundColor=[UIColor redColor];
    self.progress.layer.cornerRadius = 3;
    self.progress.layer.masksToBounds = YES;
    self.progress.transform = CGAffineTransformMakeScale(1.0f,3.0f);
    //设置进度条左边的进度颜色
    [self.progress setProgressTintColor:[UIColor colorWithRed:255/255.0 green:175/255.0 blue:35/255.0 alpha:1]];
    //设置进度条右边的进度颜色
    [self.progress setTrackTintColor:[UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1]];
    [view addSubview:self.progress];
    if (Model.Percentage >= 100) {
        [self.progress setProgressTintColor:[UIColor colorWithRed:185/255.0 green:55/255.0 blue:83/255.0 alpha:1]];
        self.progress.progress=1;
        view.valueLabel.text = [NSString stringWithFormat:@"100%%"];
        //把图片添加到动态数组
        NSMutableArray * animateArray = [[NSMutableArray alloc]initWithCapacity:2];
        [animateArray addObject:[UIImage imageNamed:@"comment_progress_heart_nor"]];
        [animateArray addObject:[UIImage imageNamed:@"comment_progress_heart_mid"]];
        [animateArray addObject:[UIImage imageNamed:@"comment_progress_heart_complete"]];
        //为图片设置动态
        view.yellowButton.animationImages = animateArray;
        //为动画设置持续时间
        view.yellowButton.animationDuration = 0.5;
        //为默认的无限循环
        view.yellowButton.animationRepeatCount = 0;
        //开始播放动画
        [view.yellowButton startAnimating];
    }else{
        view.yellowButton.image=[UIImage imageNamed:@"comment_progress_heart_nor"];
        self.progress.progress=Model.Percentage/100.0;
        view.valueLabel.text = [NSString stringWithFormat:@"%2.f%%",Model.Percentage];
    }
    UIImageView * people=[[UIImageView alloc] initWithFrame:CGRectMake(40+85*self.progress.progress-12, 25, 25, 25)];
    if (self.progress.progress<0.5) {
        people.image=[UIImage imageNamed:@"comment_detail_progress_run_1"];
    }
    else
    {
        if (self.progress.progress<0.85) {
            people.image=[UIImage imageNamed:@"comment_detail_progress_run_2"];
        }
    }
    [view addSubview:people];
}

//购物车
-(void)clickCollectButton:(UIButton *)but
{
    NSArray * array=[self.model.SimilarCaseList objectForKey:@"ItemList"];
    [self saveShoppingCartItem:[array[but.tag-10] objectForKey:@"CaseID"] andBut:but andRemainingValue:[array[but.tag-10] objectForKey:@"RemainingValue"] andIsSuccess:[array[but.tag-10] objectForKey:@"IsSuccess"] andStyleStr:@"NO"];
    if (!([[array[but.tag-10] objectForKey:@"RemainingValue"] intValue] == 0||
          [[array[but.tag-10] objectForKey:@"IsSuccess"] intValue] == 1)) {
        but.selected=YES;
    }
}


#pragma mark 灰色分割线
-(void)setLine:(UIImageView *)View andY:(float)Y
{
    //灰色分割线
    UILabel * lineLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, Y, View.frame.size.width, 2)];
    lineLabel.backgroundColor=[UIColor grayColor];
    lineLabel.alpha=0.4;
    [View addSubview:lineLabel];
}

#pragma mark 设置进度JDbgImageView
-(void)setJDView
{
    self.progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progress.frame = CGRectMake(0, 20, self.JDbgImageView.frame.size.width-200, 2);
    //self.progress.backgroundColor=[UIColor redColor];
    self.progress.layer.cornerRadius = 3;
    self.progress.layer.masksToBounds = YES;
    self.progress.transform = CGAffineTransformMakeScale(1.0f,3.0f);
    //设置进度条左边的进度颜色
    [self.progress setProgressTintColor:[UIColor colorWithRed:255/255.0 green:175/255.0 blue:35/255.0 alpha:1]];
    //设置进度条右边的进度颜色
    [self.progress setTrackTintColor:[UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1]];
    
    self.people=[[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 30, 30)];
    //self.people.image=[UIImage imageNamed:@"comment_detail_progress_run_1"];
    
    self.heartImage=[[UIImageView alloc] initWithFrame:CGRectMake(self.progress.frame.origin.x+self.progress.frame.size.width-5, 10, 20, 18)];
    //self.heartImage.backgroundColor=[UIColor redColor];
    self.heartImage.image=[UIImage imageNamed:@"comment_progress_heart_nor"];
    
    self.proportionLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.heartImage.frame.origin.x+self.heartImage.frame.size.width, self.heartImage.frame.origin.y-2, 50, 20)];
    //self.proportionLabel.backgroundColor=[UIColor redColor];
    self.proportionLabel.text=@"100%";//暂定
    
    self.timeLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, self.people.frame.origin.y+self.people.frame.size.height, 300, 20)];
    //self.timeLabel.backgroundColor=[UIColor redColor];
    LanguageKey lang = [Language getLanguage];
    NSArray * array=self.model.RemainingTime;
    if (array.count==0) {
        self.timeLabel.text=HKLocalizedString(@"GirdView_time");
    }
    if (lang==1||lang==2) {
        if (array.count==1) {
            self.timeLabel.text=[NSString stringWithFormat:@"%@ %@%@",
                                 HKLocalizedString(@"GirdView_time_label"),
                                 [array[0] objectForKey:@"value"],[array[0] objectForKey:@"unit"]];
        }
        if (array.count==2) {
            self.timeLabel.text=[NSString stringWithFormat:@"%@ %@%@ %@%@",
                                 HKLocalizedString(@"GirdView_time_label"),
                                 [array[0] objectForKey:@"value"],[array[0] objectForKey:@"unit"],
                                 [array[1] objectForKey:@"value"],[array[1] objectForKey:@"unit"]];
        }
        if (array.count==3) {
            self.timeLabel.text=[NSString stringWithFormat:@"%@ %@%@ %@%@ %@%@",
                                 HKLocalizedString(@"GirdView_time_label"),
                                 [array[0] objectForKey:@"value"],[array[0] objectForKey:@"unit"],
                                 [array[1] objectForKey:@"value"],[array[1] objectForKey:@"unit"],
                                 [array[2] objectForKey:@"value"],[array[2] objectForKey:@"unit"]];
        }
    }
    if (lang==3) {
        if (array.count==1) {
            self.timeLabel.text=[NSString stringWithFormat:@"%@ %@ To Go",
                                 [array[0] objectForKey:@"value"],[array[0] objectForKey:@"unit"]];
        }
        if (array.count==2) {
            self.timeLabel.text=[NSString stringWithFormat:@"%@ %@ %@ %@ To Go",
                                 [array[0] objectForKey:@"value"],[array[0] objectForKey:@"unit"],
                                 [array[1] objectForKey:@"value"],[array[1] objectForKey:@"unit"]];
        }
        if (array.count==3) {
            self.timeLabel.text=[NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@ To Go",
                                 [array[0] objectForKey:@"value"],[array[0] objectForKey:@"unit"],
                                 [array[1] objectForKey:@"value"],[array[1] objectForKey:@"unit"],
                                 [array[2] objectForKey:@"value"],[array[2] objectForKey:@"unit"]];
        }
    }
    
    if ([self.model.Percentage intValue] >= 100) {
        [self.progress setProgressTintColor:[UIColor colorWithRed:185/255.0 green:55/255.0 blue:83/255.0 alpha:1]];
        self.progress.progress=1;
        self.proportionLabel.text = [NSString stringWithFormat:@"100%%"];
        //把图片添加到动态数组
        NSMutableArray * animateArray = [[NSMutableArray alloc]initWithCapacity:2];
        [animateArray addObject:[UIImage imageNamed:@"comment_progress_heart_nor"]];
        [animateArray addObject:[UIImage imageNamed:@"comment_progress_heart_mid"]];
        [animateArray addObject:[UIImage imageNamed:@"comment_progress_heart_complete"]];
        //为图片设置动态
        self.heartImage.animationImages = animateArray;
        //为动画设置持续时间
        self.heartImage.animationDuration = 0.5;
        //为默认的无限循环
        self.heartImage.animationRepeatCount = 0;
        //开始播放动画
        [self.heartImage startAnimating];
    }else{
        self.heartImage.image=[UIImage imageNamed:@"comment_progress_heart_nor"];
        self.progress.progress=[self.model.Percentage intValue]/100.0;
        self.proportionLabel.text = [NSString stringWithFormat:@"%2.f%%",[self.model.Percentage floatValue]];
        self.proportionLabel.font=[UIFont boldSystemFontOfSize:18];
    }
    if (self.progress.progress>0.94) {
        self.people.frame=CGRectMake(self.progress.frame.size.width*0.94-10, 5, 30, 30);
    }
    else
    {
        self.people.frame=CGRectMake(self.progress.frame.size.width*self.progress.progress-10, 5, 30, 30);
    }
    
    if (self.progress.progress<0.5) {
        self.people.image=[UIImage imageNamed:@"comment_detail_progress_run_1"];
    }
    else
    {
        if (self.progress.progress<0.9999) {
            self.people.image=[UIImage imageNamed:@"comment_detail_progress_run_2"];
        }
    }
    
    //灰色分割线
    UILabel * lineLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.proportionLabel.frame.origin.x+self.proportionLabel.frame.size.width+10, 10, 2, 40)];
    lineLabel.backgroundColor=[UIColor grayColor];
    lineLabel.alpha=0.4;
    
    self.JDButton=[[UIButton alloc] initWithFrame:CGRectMake(self.JDbgImageView.frame.size.width-90, 5, 80, 50)];
    //self.JDButton.backgroundColor=[UIColor redColor];
    [self.JDButton setImage:[UIImage imageNamed:@"case_detail_progress"] forState:UIControlStateNormal];
    [self.JDButton setTitle:HKLocalizedString(@"GirdView_report_label") forState:UIControlStateNormal];
    [self.JDButton setTitleColor:greeBar forState:UIControlStateNormal];
    //[UIColor colorWithRed:90/255.0 green:172/255.0 blue:33/255.0 alpha:1]
    //设置图片和文字位置
    self.JDButton.titleEdgeInsets = UIEdgeInsetsMake(0, -40, -25, 0);
    self.JDButton.imageEdgeInsets = UIEdgeInsetsMake(-25, 4, 0, -4);
    [self.JDButton addTarget:self action:@selector(clickJDButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.JDbgImageView addSubview:self.progress];
    [self.JDbgImageView addSubview:self.people];
    [self.JDbgImageView addSubview:self.heartImage];
    [self.JDbgImageView addSubview:self.proportionLabel];
    [self.JDbgImageView addSubview:self.timeLabel];
    [self.JDbgImageView addSubview:lineLabel];
    [self.JDbgImageView addSubview:self.JDButton];
}

#pragma mark 点击进度报告
-(void)clickJDButton:(UIButton *)button
{
    EGProReportController * ProReport = [[EGProReportController alloc] init];
//    YQNavigationController *nav = [[YQNavigationController alloc] initWithSize:CGSizeMake(WIDTH-400, HEIGHT-50) rootViewController:ProReport];
//    //nav.touchSpaceHide = YES;//点击没有内容的地方消失
//    nav.panPopView = YES;//滑动返回上一层视图
//    ProReport.title = [Language getStringByKey:@"进度报告"];
//    ProReport.dataArray=self.model.UpdatesDetail;
//    ProReport.nameString=self.model.Title;
//    [nav show:YES animated:YES];
    
    CGSize size = CGSizeMake(screenWidth-400, screenHeight-50);
    [ProReport setContentSize:size  bgAction:NO animated:NO];
    ProReport.dataArray=self.model.UpdatesDetail;
    ProReport.nameString=self.model.Title;
    ProReport.caseId=self.model.CaseID;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:ProReport];
    navigationController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark 设置图片TPbgImageView
-(void)setlaVIEW:(UILabel *)label andImage:(NSString *)image andTitle:(NSString *)title andTextColor:(int)CL andNum:(NSString *)num;
{
    UIImageView * YCImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 40, 40)];
    //YCImage.backgroundColor=[UIColor blackColor];
    YCImage.image=[UIImage imageNamed:image];
    [label addSubview:YCImage];
    
    UILabel * Ylabel=[[UILabel alloc] initWithFrame:CGRectMake(40, 0, label.frame.size.width-YCImage.frame.size.width-5, 25)];
    //Ylabel.backgroundColor=[UIColor greenColor];
    Ylabel.text=title;
    [label addSubview:Ylabel];
    
    UILabel * Clabel=[[UILabel alloc] initWithFrame:CGRectMake(40, 25, label.frame.size.width-YCImage.frame.size.width, 25)];
    //Clabel.backgroundColor=[UIColor blueColor];
    [label addSubview:Clabel];
    
    UIImageView * TImage=[[UIImageView alloc] initWithFrame:CGRectMake(Clabel.frame.size.width-30, 8, 10, 10)];
    TImage.image=[UIImage imageNamed:@"case_detail_arrow"];
    
    if (CL==0) {
        Ylabel.textColor=[UIColor grayColor];
        Clabel.textColor=[UIColor blackColor];
        Clabel.font=[UIFont boldSystemFontOfSize:16];
        Clabel.text=[NSString stringWithFormat:@"$%@",num];
        
    }
    else
    {
        [Clabel addSubview:TImage];
        Ylabel.textColor=greeBar;
        //[UIColor colorWithRed:90/255.0 green:172/255.0 blue:33/255.0 alpha:1];
        Clabel.textColor=greeBar;
        //[UIColor colorWithRed:90/255.0 green:172/255.0 blue:33/255.0 alpha:1];
        Clabel.font=[UIFont boldSystemFontOfSize:16];
        Clabel.text=[NSString stringWithFormat:@"%@",num];
        //Clabel.textAlignment=NSTextAlignmentCenter;
    }
    
}

-(void)setTPView
{
    //已筹金额lb
    self.YCLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, (self.TPbgImageView.frame.size.width)/4, 50)];
    //self.YCLabel.backgroundColor=[UIColor redColor];
    self.YCLabel.text=@"";
    [self.TPbgImageView addSubview:self.YCLabel];
    [self setlaVIEW:self.YCLabel andImage:@"case_detail_amount" andTitle:HKLocalizedString(@"GirdView_atm_label") andTextColor:0 andNum:self.model.Amt];
    
    //目标金额lb
    self.MBLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.YCLabel.frame.origin.x+self.YCLabel.frame.size.width, 0, (self.TPbgImageView.frame.size.width)/4, 50)];
    //self.MBLabel.backgroundColor=[UIColor orangeColor];
    self.MBLabel.text=@"";
    [self.TPbgImageView addSubview:self.MBLabel];
    [self setlaVIEW:self.MBLabel andImage:@"case_detail_target" andTitle:HKLocalizedString(@"GirdView_target_label") andTextColor:0 andNum:self.model.TargetAmt];
    
    //捐赠者lb
    self.JZLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.MBLabel.frame.origin.x+self.MBLabel.frame.size.width, 0, (self.TPbgImageView.frame.size.width)/4, 50)];
    self.JZLabel.userInteractionEnabled=YES;
    //self.JZLabel.backgroundColor=[UIColor redColor];
    self.JZLabel.text=@"";
    [self.TPbgImageView addSubview:self.JZLabel];
    [self setlaVIEW:self.JZLabel andImage:@"case_detail_donor" andTitle:HKLocalizedString(@"GirdView_donors_label") andTextColor:1 andNum:self.model.DonorCount];
    UIButton * JZbutton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.JZLabel.frame.size.width, self.JZLabel.frame.size.height)];
    [self.JZLabel addSubview:JZbutton];
    [JZbutton addTarget:self action:@selector(clickJZbutton:) forControlEvents:UIControlEventTouchUpInside];
    
    //送祝福lb
    self.SZFLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.JZLabel.frame.origin.x+self.JZLabel.frame.size.width, 0, (self.TPbgImageView.frame.size.width)/4, 50)];
    self.SZFLabel.userInteractionEnabled=YES;
    //self.SZFLabel.backgroundColor=[UIColor orangeColor];
    self.SZFLabel.text=@"";
    [self.TPbgImageView addSubview:self.SZFLabel];
    [self setlaVIEW:self.SZFLabel andImage:@"case_detail_bless" andTitle:HKLocalizedString(@"GirdView_blessings_label") andTextColor:1 andNum:self.model.CommentCount];
    UIButton * SZFbutton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.SZFLabel.frame.size.width, self.SZFLabel.frame.size.height)];
    [self.SZFLabel addSubview:SZFbutton];
    [SZFbutton addTarget:self action:@selector(clickSZFbutton:) forControlEvents:UIControlEventTouchUpInside];
    
    NSMutableArray * picArray=[[NSMutableArray alloc] init];
    for (NSDictionary * adDict in self.model.GalleryImg) {
        //DLOG(@"adDict adDict = %@", adDict);
        NSString *  URL = [SITE_URL stringByAppendingPathComponent:[[adDict objectForKey:@"ImgURL"] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
        //DLOG(@"URL = %@", URL);
        [picArray addObject:URL];
    }
    //图片
    self.loopScrollView=[[EGScrollView alloc] initWithFrame:CGRectMake(0, 50, self.TPbgImageView.frame.size.width, self.TPbgImageView.frame.size.height-50-40)];
    self.loopScrollView.backgroundColor=[UIColor whiteColor];
    self.loopScrollView.pageCount=(int)picArray.count;
    [self.TPbgImageView addSubview:self.loopScrollView];
    self.loopScrollView.showPageControl=YES;
    
    for (int i=0; i<picArray.count; i++) {
        [self.loopScrollView setImageWithUrlString:picArray[i] atIndex:i];
    }
    
    //类别图片
    self.LBImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, self.TPbgImageView.frame.size.height-40, 30, 30)];
    //self.LBImage.backgroundColor=[UIColor greenColor];
    self.LBImage.image=[UIImage imageNamed:[self.LXDic objectForKey:self.CategoryString]];
    
    //标题lb
    self.titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.LBImage.frame.origin.x+self.LBImage.frame.size.width, self.TPbgImageView.frame.size.height-40, self.loopScrollView.frame.size.width-80, 30)];
    //self.titleLabel.backgroundColor=[UIColor redColor];
    self.titleLabel.textColor=tabarColor;
    self.titleLabel.text=[NSString stringWithFormat:@"%@(%@)",self.model.Title,self.model.Region];
    
    //收藏图片(关注)
    self.SCButton=[[UIButton alloc] initWithFrame:CGRectMake(self.loopScrollView.frame.size.width-30, self.TPbgImageView.frame.size.height-40, 30, 30)];
    [self.SCButton setImage:[UIImage imageNamed:@"case_detail_favourite_nor"] forState:UIControlStateNormal];
    [self.SCButton setImage:[UIImage imageNamed:@"case_detail_favourite"] forState:UIControlStateSelected];
    [self.TPbgImageView addSubview:self.SCButton];
    [self.SCButton addTarget:self action:@selector(clickSCButton:) forControlEvents:UIControlEventTouchUpInside];
    if (self.model.Isfavourite) {
        self.SCButton.selected=YES;
    }
    
    //灰色分割线
    UILabel * lineLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, self.TPbgImageView.frame.size.height-2, self.TPbgImageView.frame.size.width, 2)];
    lineLabel.backgroundColor=[UIColor grayColor];
    lineLabel.alpha=0.4;
    
    [self.TPbgImageView addSubview:self.LBImage];
    [self.TPbgImageView addSubview:self.titleLabel];
    [self.TPbgImageView addSubview:lineLabel];
}

#pragma mark 点击收藏图片(关注)
-(void)clickSCButton:(UIButton *)button
{
    if (self.EGLT.isLoggedIn) {
        button.selected=!button.selected;
    }
    if (button.selected) {
        [self AddFavourite:self.model.CaseID];
    }
    else
    {
        [self DeleteFavourite:self.model.CaseID];
    }
}

#pragma mark 点击捐增者
-(void)clickJZbutton:(UIButton *)button
{
    //DLOG(@"WIDTH==%f",WIDTH);
    EGDonorsController * EGDC=[[EGDonorsController alloc] init];
//    YQNavigationController *nav = [[YQNavigationController alloc] initWithSize:CGSizeMake(screenWidth-400, screenHeight-50) rootViewController:EGDC];
//    //nav.touchSpaceHide = YES;//点击没有内容的地方消失
//    nav.panPopView = YES;//滑动返回上一层视图
//    EGDC.donorsArray=self.model.Donors;
//    EGDC.title = [NSString stringWithFormat:@"%@(%lu)",HKLocalizedString(@"捐款者"),EGDC.donorsArray.count];
//    [nav show:YES animated:YES];
    
    CGSize size = CGSizeMake(screenWidth-400, screenHeight-50);
    [EGDC setContentSize:size  bgAction:NO animated:NO];
    EGDC.donorsArray=self.model.Donors;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:EGDC];
    navigationController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark 点击送祝福
-(void)clickSZFbutton:(UIButton *)button
{
    EGBlessingController * EGBC=[[EGBlessingController alloc] init];
    CGSize size = CGSizeMake(screenWidth-400, screenHeight-50);
    [EGBC setContentSize:size  bgAction:NO animated:NO];
    EGBC.model=self.model;
    EGBC.caseID=self.caseId;
    EGBC.memberID=self.memberString;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:EGBC];
    navigationController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark 设置摘要ZYbgImageView
-(void)setZYView
{
    UILabel * title=[[UILabel alloc] initWithFrame:CGRectMake(0, 5, 200, 30)];
    //title.backgroundColor=[UIColor greenColor];
    title.text=HKLocalizedString(@"专案摘要");
    [self.ZYbgImageView addSubview:title];
    
    UILabel * text=[[UILabel alloc] initWithFrame:CGRectMake(0, 40, self.ZYbgImageView.frame.size.width, 80)];
    //text.backgroundColor=[UIColor greenColor];
    text.tag=80;
    text.numberOfLines=0;
    NSString *s = [self.model.ShortDesc stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
    text.text=s;
    text.font=[UIFont systemFontOfSize:self.tableVFont];
    [self.ZYbgImageView addSubview:text];
}

#pragma mark 设置Tabar的button
-(void)setTabarButton
{
    self.ZFButton=[[UIButton alloc] initWithFrame:CGRectMake(20, 10, (self.TBbgImageView.frame.size.width-20*3)/2, 30)];
    //self.ZFButton.backgroundColor=tabarColor;
    self.ZFButton.backgroundColor=greeBar;
    //[UIColor colorWithRed:90/255.0 green:172/255.0 blue:33/255.0 alpha:1];
    self.ZFButton.layer.cornerRadius=5;
    [self.ZFButton setImage:[UIImage imageNamed:@"common_footer_bless"] forState:UIControlStateNormal];
    [self.ZFButton setTitle:HKLocalizedString(@"GirdView_blessings_button") forState:UIControlStateNormal];
    [self.ZFButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.TBbgImageView addSubview:self.ZFButton];
    
    self.JKButton=[[UIButton alloc] initWithFrame:CGRectMake(self.ZFButton.frame.origin.x+self.ZFButton.frame.size.width+20, 10, self.ZFButton.frame.size.width, 30)];
    //self.JKButton.backgroundColor=tabarColor;
    self.JKButton.backgroundColor=greeBar;
    //[UIColor colorWithRed:90/255.0 green:172/255.0 blue:33/255.0 alpha:1];
    self.JKButton.layer.cornerRadius=5;
    [self.JKButton setImage:[UIImage imageNamed:@"comment_list_cart_nor"] forState:UIControlStateNormal];
    [self.JKButton setImage:[UIImage imageNamed:@"comment_list_cart_sel"] forState:UIControlStateSelected];
    [self.JKButton setTitle:HKLocalizedString(@"GirdView_donate_button") forState:UIControlStateNormal];
    [self.JKButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.TBbgImageView addSubview:self.JKButton];
    
    [self.ZFButton addTarget:self action:@selector(clickZFButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.JKButton addTarget:self action:@selector(clickJKButton:) forControlEvents:UIControlEventTouchUpInside];
    
    for (NSString * str in self.IDarray) {
        if ([str isEqualToString:self.caseId]) {
            self.JKButton.selected = YES;
            self.JKButton.backgroundColor=greeBar;
            //[UIColor colorWithRed:90/255.0 green:172/255.0 blue:33/255.0 alpha:1];
        }
    }
}

#pragma mark 点击送上祝福按钮
-(void)clickZFButton:(UIButton *)button
{
    EGUserModel * UModel=[self.EGLT currentUser];
    if (UModel.MemberID != nil){
        EGEditBlessingController * EGBC=[[EGEditBlessingController alloc] init];
        CGSize size = CGSizeMake(screenWidth-400, screenHeight-50);
        [EGBC setContentSize:size  bgAction:NO animated:NO];
        EGBC.model=self.model;
        EGBC.disappearStr=@"disappear";
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:EGBC];
        navigationController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:navigationController animated:YES completion:nil];
        
    }else{
        //会员登录
        EGLoginViewController* vc = [[EGLoginViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark 点击立即捐款按钮
-(void)clickJKButton:(UIButton *)button
{
    NSString * Remaining;//标记是否结束
    NSString * Success;//标记是否成功
    if (self.model.RemainingTime.count>0) {
        Remaining=@"1";
    }
    else
    {
        Remaining=@"0";
    }
    if (self.model.IsSuccess) {
        Success=@"1";
    }
    else
    {
        Success=@"0";
    }
    [self myID:self.caseId andBut:button andRemainingValue:Remaining andIsSuccess:Success andStyleStr:@"OK"];
}

#pragma mark - TableView
-(void)SetTableView
{
    self.FRtableView=[[UITableView alloc] init];
    self.FRtableView.frame=CGRectMake(0, self.titleScrollView.frame.size.height+3, (screenWidth-64)*2/5, screenHeight-64-50);
    //self.FRtableView=[[UITableView alloc] initWithFrame:CGRectMake(0, self.nameScrollView.frame.size.height+self.titleScrollView.frame.size.height, screenWidth-64, screenHeight-64-100) style:UITableViewStylePlain];
    self.FRtableView.backgroundColor=[UIColor colorWithRed:233/255.0 green:234/255.0 blue:235/255.0 alpha:1];
    self.FRtableView.delegate=self;
    self.FRtableView.dataSource=self;
    self.FRtableView.separatorStyle = NO;
    [self.view addSubview:self.FRtableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.FRtableView]) {
        return self.cellArray.count;
    }
    if ([tableView isEqual:self.OCTableView]) {
        return 1;//组里的数量
    }
    
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([tableView isEqual:self.FRtableView]) {
        return 1;
    }
    else
    {
        return self.NRtitleArray.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.FRtableView]) {
        return 95;
    }
    else
    {
        //        DLOG(@"selectedArr==%@",self.selectedArr);
        //        DLOG(@"self.retSize.height==selectedArr==%f",self.retSize.height);
        NSString *indexStr = [NSString stringWithFormat:@"%lu",(long)indexPath.section];
        if ([self.selectedArr containsObject:indexStr]) {
            if (self.retSize.height<50) {
                return 50;
            }
            else
            {
                return self.retSize.height+20;
            }
        }
    }
    
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:self.OCTableView]) {
        return 50;
    }
    else
    {
        return 0.00001;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.FRtableView]) {
        static NSString * str=@"cell";
        EGClickCharityCell * cell=[tableView dequeueReusableCellWithIdentifier:str];
        if (cell==nil) {
            cell=[[EGClickCharityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
            cell.delegate=self;
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;//cell的选中风格
        if (self.cellIndex==indexPath.row) {
            cell.backgroundColor=[UIColor colorWithRed:233/255.0 green:234/255.0 blue:236/255.0 alpha:1];
        }
        else
        {
            cell.backgroundColor=[UIColor whiteColor];
        }

        EGHomeModel * hModel=[[EGHomeModel alloc] init];
        [hModel setDictionary:self.cellArray[indexPath.row]];
        [cell setModel:hModel andIndex:(int)indexPath.row andID:self.IDarray andBool:self.isSwap];
        return cell;
    }
    else
    {
//        static NSString * str=@"NRcell";
//        UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:str];
//        if (cell==nil) {
//            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
//        }
//        cell.selectionStyle=UITableViewCellSelectionStyleNone;//cell的选中风格
//        cell.textLabel.numberOfLines=0;
//        NSString *indexStr = [NSString stringWithFormat:@"%lu",(long)indexPath.section];
//        if (indexPath.section==0) {
//            if ([self.selectedArr containsObject:indexStr]) {
//                NSString *s = [self.model.Content stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
//                cell.textLabel.text=s;
//                cell.textLabel.font=[UIFont systemFontOfSize:self.tableVFont];
//                self.retSize = EG_MULTILINE_TEXTSIZE(s, [UIFont systemFontOfSize:self.tableVFont], CGSizeMake(300,CGFLOAT_MAX), NSLineBreakByWordWrapping);
//            }
//            
//        }
//        else if (indexPath.section==1)
//        {
//            if ([self.selectedArr containsObject:indexStr]) {
//                NSString *s = [self.model.BackGround stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
//                cell.textLabel.text=s;
//                cell.textLabel.font=[UIFont systemFontOfSize:self.tableVFont];
//                self.retSize = EG_MULTILINE_TEXTSIZE(s, [UIFont systemFontOfSize:self.tableVFont], CGSizeMake(300,CGFLOAT_MAX), NSLineBreakByWordWrapping);
//            }
//        }
//        else if (indexPath.section==2)
//        {
//            if ([self.selectedArr containsObject:indexStr]) {
//                NSString *s = [self.model.Need stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
//                cell.textLabel.text=s;
//                cell.textLabel.font=[UIFont systemFontOfSize:self.tableVFont];
//                self.retSize = EG_MULTILINE_TEXTSIZE(s, [UIFont systemFontOfSize:self.tableVFont], CGSizeMake(300,CGFLOAT_MAX), NSLineBreakByWordWrapping);
//            }
//        }
//        else
//        {
//            if ([self.selectedArr containsObject:indexStr]) {
//                NSString *s = [self.model.Share stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
//                cell.textLabel.text=s;
//                cell.textLabel.font=[UIFont systemFontOfSize:self.tableVFont];
//                self.retSize = EG_MULTILINE_TEXTSIZE(s, [UIFont systemFontOfSize:self.tableVFont], CGSizeMake(300,CGFLOAT_MAX), NSLineBreakByWordWrapping);
//            }
//        }
        static NSString * str=@"NRcell";
        EGGirdTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:str];
        if (cell==nil) {
            cell = [[EGGirdTableViewCell alloc] init:self];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;//cell的选中风格
        cell.textLabel.numberOfLines=0;
        NSString *indexStr = [NSString stringWithFormat:@"%lu",(long)indexPath.section];
        if (indexPath.section==0) {
            if ([self.selectedArr containsObject:indexStr]) {
                NSString *fontString = [NSString stringWithFormat:@"%f",_font.pointSize];
                CGFloat fontSize = [fontString floatValue];
                UIFont *wfont = [UIFont systemFontOfSize:fontSize];
                [cell setLabelFont:wfont];
                NSString *s = [_model.Content stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
                [cell setLabelText:s];//[NSString captureData:s]];
                _retSize = EG_MULTILINE_TEXTSIZE(s, wfont, CGSizeMake(300,CGFLOAT_MAX), NSLineBreakByWordWrapping);
            }
        }
        else if (indexPath.section==1)
        {
            if ([self.selectedArr containsObject:indexStr]) {
                NSString *fontString = [NSString stringWithFormat:@"%f",_font.pointSize];
                CGFloat fontSize = [fontString floatValue];
                UIFont *wfont = [UIFont systemFontOfSize:fontSize];
                [cell setLabelFont:wfont];
                [cell setLabelText:[_model.BackGround stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"]];
                _retSize = EG_MULTILINE_TEXTSIZE([_model.BackGround stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"], wfont, CGSizeMake(300,CGFLOAT_MAX), NSLineBreakByWordWrapping);
            }
        }
        else if (indexPath.section==2)
        {
            if ([self.selectedArr containsObject:indexStr]) {
                NSString *fontString = [NSString stringWithFormat:@"%f",_font.pointSize];
                CGFloat fontSize = [fontString floatValue];
                UIFont *wfont = [UIFont systemFontOfSize:fontSize];
                [cell setLabelFont:wfont];
                [cell setLabelText:[_model.Need stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"]];
                _retSize = EG_MULTILINE_TEXTSIZE([_model.Need stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"], wfont, CGSizeMake(300,CGFLOAT_MAX), NSLineBreakByWordWrapping);
            }
        }
        else
        {
            if ([self.selectedArr containsObject:indexStr]) {
                NSString *fontString = [NSString stringWithFormat:@"%f",_font.pointSize];
                CGFloat fontSize = [fontString floatValue];
                UIFont *wfont = [UIFont systemFontOfSize:fontSize];
                [cell setLabelFont:wfont];
                [cell setLabelText:[_model.Share stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"]];
                _retSize = EG_MULTILINE_TEXTSIZE([_model.Share stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"], wfont, CGSizeMake(300,CGFLOAT_MAX), NSLineBreakByWordWrapping);
            }
        }
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"indexPath.row==%lu",indexPath.row);
    if ([tableView isEqual:self.FRtableView]) {
        self.cellIndex=(int)indexPath.row;
        [self.FRtableView reloadData];
        [self requestXQData:[self.cellArray[indexPath.row] objectForKey:@"CaseID"] andMemberID:self.memberString];
        
        if ([[self.cellArray[indexPath.row] objectForKey:@"Category"] length]>0) {
            self.CategoryString=[[self.cellArray[indexPath.row] objectForKey:@"Category"] substringToIndex:1];
        }
        else
        {
            self.CategoryString=@"O";
        }
    }
    else
    {
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(clickLongPress)];
        [tableView addGestureRecognizer:longPress];
        
        UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTap)];
        [tableView addGestureRecognizer:tap];
    }
}

#pragma mark 尾部视图
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//
//    UIImageView * image=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.OCTableView.frame.size.width, 200)];
//    image.backgroundColor=[UIColor redColor];tableFooterView
//    return image;
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:self.OCTableView]) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.OCTableView.frame.size.width, 50)];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, tableView.frame.size.width-40, 40)];
        titleLabel.text = [self.NRtitleArray objectAtIndex:section];
        titleLabel.textColor=tabarColor;
        //titleLabel.textAlignment=NSTextAlignmentCenter;
        [view addSubview:titleLabel];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.OCTableView.frame.size.width-30, (50-16)/2, 30, 16)];
        
        //imageView.backgroundColor=[UIColor redColor];
        imageView.tag = 20000+section;
        
        UILabel * label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.OCTableView.frame.size.width, 1)];
        label.backgroundColor=[UIColor grayColor];
        label.alpha=0.4;
        [view addSubview:label];
        
        UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 0.5)];
        lineImage.backgroundColor=[UIColor lightGrayColor];
        lineImage.alpha=0.4;
        [view addSubview:lineImage];
        
        //判断是不是选中状态
        NSString *string = [NSString stringWithFormat:@"%lu",(long)section];
        if ([self.selectedArr containsObject:string]) {
            imageView.image = [UIImage imageNamed:@"case_detail_close"];
            //self.OCTableView.separatorStyle = UITableViewCellSelectionStyleBlue;
            lineImage.hidden=YES;
        }
        else
        {
            //self.OCTableView.separatorStyle = UITableViewCellSelectionStyleNone;
            imageView.image = [UIImage imageNamed:@"case_detail_expand"];
            lineImage.hidden=NO;
            //            NSIndexSet * set=[[NSIndexSet alloc] initWithIndex:section];
            //            [tableView reloadSections:set withRowAnimation:UITableViewRowAnimationLeft];
            
        }
        [view addSubview:imageView];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, self.view.frame.size.width, 50);
        button.tag = 200+section;
        [button addTarget:self action:@selector(doButton:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
        return view;
    }
    
    return nil;
}

-(void)doButton:(UIButton *)sender
{
    NSString *string = [NSString stringWithFormat:@"%ld",sender.tag-200];
    
    if ([self.selectedArr containsObject:string])
    {
        [self.selectedArr removeObject:string];
    }
    else
    {
        [self.selectedArr addObject:string];
    }
    
    [self.OCTableView reloadData];
}


#pragma mark - 请求右视图数据
-(void)requestXQData:(NSString *)caseID andMemberID:(NSString *)memberID{
    self.caseId=caseID;
    [SVProgressHUD show];
    LanguageKey lang = [Language getLanguage];
    NSString * soapMessage =
    [NSString stringWithFormat:
     @"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><GetCaseDtl xmlns=\"egive.appservices\"><Lang>%ld</Lang><CaseID>%@</CaseID><MemberID>%@</MemberID></GetCaseDtl></soap:Body></soap:Envelope>",lang,caseID,memberID];
    //DLOG(@"lang==%ld\ncaseID==%@\nmemberID==%@",lang,caseID,memberID);
    [EGHomeModel postClickCharitytWithParams:soapMessage block:^(NSDictionary *data, NSError *error) {
        [SVProgressHUD dismiss];
        //DLOG(@"data===%@",data);
        if (data.count>0) {
            self.detailDicData=data;
            self.model = [[EGClickCharityModel alloc] init];
            [self.model setValuesForKeysWithDictionary:data];
            //DLOG(@"self.model.Title===%@",self.model.Title);
            //[self SetDetailView];
            [self clickShare];
            [self setOCTableView];
        }
    }];
    
    [self testURL];
}

-(void)testURL
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:@"www.baidu.com"]];
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            // NSLog(@"目前网络不可用");
            [SVProgressHUD dismiss];
        }
    }];
    [manager.reachabilityManager startMonitoring];
}


#pragma mark - cell回调方法
//点击View后返回的数据
-(void)clickView:(NSDictionary *)fdm and:(int)index
{
    //DLOG(@"fdm==%@",fdm);
    //DLOG(@"index==%d",index);
}

//点击立即捐款
-(void)AddDonation:(NSString *)caseId andBut:(UIButton *)but andRemainingValue:(NSString *)RemainingValue andIsSuccess:(BOOL)Success andStyleStr:(NSString *)StyleStr
{
    if (Success) {
        [self myID:caseId andBut:but andRemainingValue:RemainingValue andIsSuccess:@"1" andStyleStr:StyleStr];
    }
    else
    {
        [self myID:caseId andBut:but andRemainingValue:RemainingValue andIsSuccess:@"0" andStyleStr:StyleStr];
    }
}

//添加购物车
-(void)saveShoppingCartItem:(NSString *)caseID andBut:(UIButton *)but andRemainingValue:(NSString *)RemainingValue andIsSuccess:(NSString *)Success andStyleStr:(NSString *)StyleStr
{
    //DLOG(@"AddcaseID==%@",caseID);
    [self myID:caseID andBut:but andRemainingValue:RemainingValue andIsSuccess:Success andStyleStr:StyleStr];
}

-(void)myID:(NSString *)caseID andBut:(UIButton *)but andRemainingValue:(NSString *)RemainingValue andIsSuccess:(NSString *)Success andStyleStr:(NSString *)StyleStr
{
    if (but.selected) {
        if ([StyleStr isEqualToString:@"OK"]) {
            EGMyDonationViewController *root = [[EGMyDonationViewController alloc] initWithNibName:@"EGMyDonationViewController" bundle:nil];
            CGSize size = CGSizeMake(WIDTH-200, HEIGHT-100);//(410, 570)
            [root setContentSize:size  bgAction:NO animated:NO];
            
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:root];
            navigationController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [self presentViewController:navigationController animated:YES completion:nil];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] init];
            alertView.message = HKLocalizedString(@"alert_msg_caseHasAdded");
            [alertView addButtonWithTitle:HKLocalizedString(@"Common_button_confirm")];
            [alertView show];
        }
    }
    else
    {
        if ([RemainingValue intValue] == 0) {
            UIAlertView *alertView = [[UIAlertView alloc] init];
            alertView.message = HKLocalizedString(@"alert_msg_caseFinished");
            [alertView addButtonWithTitle:HKLocalizedString(@"Common_button_confirm")];
            [alertView show];
        } else if ([Success intValue] == 1) {
            UIAlertView *alertView = [[UIAlertView alloc] init];
            alertView.message = HKLocalizedString(@"alert_msg_caseSuccess");
            [alertView addButtonWithTitle:HKLocalizedString(@"Common_button_confirm")];
            [alertView show];
        } else{
            NSString *cookieId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
            if (![self.memberString isEqualToString:@""]) {
                cookieId=@"";
            }
            NSString * soapMsg =[NSString stringWithFormat:
                                 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                                 "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                                 "<soap:Body>"
                                 "<SaveShoppingCartItem xmlns=\"egive.appservices\">"
                                 "<MemberID>%@</MemberID>"
                                 "<CookieID>%@</CookieID>"
                                 "<CaseID>%@</CaseID>"
                                 "<DonateAmt>%ld</DonateAmt>"
                                 "<IsChecked>%d</IsChecked>"
                                 "</SaveShoppingCartItem>"
                                 "</soap:Body>"
                                 "</soap:Envelope>",self.memberString, cookieId, caseID, (long)500, 1];
            [EGHomeModel savepostHomeItemListWithParams:soapMsg block:^(NSString * str, NSError *error) {
                //NSLog(@"data=======%@",str);
                if ([StyleStr isEqualToString:@"OK"]) {
                    EGMyDonationViewController *root = [[EGMyDonationViewController alloc] initWithNibName:@"EGMyDonationViewController" bundle:nil];
                    CGSize size = CGSizeMake(WIDTH-200, HEIGHT-100);//(410, 570)
                    [root setContentSize:size  bgAction:NO animated:NO];
                    
                    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:root];
                    navigationController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                    [self presentViewController:navigationController animated:YES completion:nil];
                }
                else
                {
                    UIAlertView *alertView = [[UIAlertView alloc] init];
                    alertView.message = HKLocalizedString(@"alert_msg_saveShoppingCartItemSuccess");
                    [alertView addButtonWithTitle:HKLocalizedString(@"Common_button_confirm")];
                    [alertView show];
                }
                [self GetAndSaveShoppingCart];
            }];
        }
    }
}

#pragma mark 添加收藏
-(void)AddCaseFavourite:(NSString *)caseID
{
    //DLOG(@"AddcaseID==%@",caseID);
    [self AddFavourite:caseID];
}
#pragma mark 取消收藏
-(void)DeleteCaseFavourite:(NSString *)caseID
{
    //DLOG(@"DeletecaseID==%@",caseID);
    [self DeleteFavourite:caseID];
}

#pragma mark 立即关注
-(void)AddAttention:(NSString *)caseID
{
    [self AddFavourite:caseID];
}
#pragma mark 取消关注
-(void)DeleteAttention:(NSString *)caseID
{
    [self DeleteFavourite:caseID];
}

#pragma mark 添加收藏数据请求
-(void)AddFavourite:(NSString *)caseID
{
    //DLOG(@"AddcaseID==%@",caseID);
    if (self.EGLT.isLoggedIn) {
        NSString * soapMessage =
        [NSString stringWithFormat:
         @"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><AddCaseFavourite xmlns=\"egive.appservices\"><CaseID>%@</CaseID><MemberID>%@</MemberID></AddCaseFavourite></soap:Body></soap:Envelope>",caseID,self.memberString];
        
        [EGHomeModel postFavouriteWithParams:soapMessage block:^(NSString *data, NSError *error) {
            
            if ([data isEqual:@"\"\""]) {
                UIAlertView *alertView = [[UIAlertView alloc] init];
                alertView.message = HKLocalizedString(@"收藏成功");
                [alertView addButtonWithTitle:HKLocalizedString(@"Common_button_confirm")];
                [alertView show];
                [self requestApiData:self.CString andMemberID:self.memberString];
                [self requestXQData:self.model.CaseID andMemberID:self.memberString];
            }else{
//                UIAlertView *alertView = [[UIAlertView alloc] init];
//                alertView.message = data;
//                [alertView addButtonWithTitle:HKLocalizedString(@"Common_button_confirm")];
//                [alertView show];
            }
            
        }];
    }
    else
    {
        //会员登录
        EGLoginViewController* vc = [[EGLoginViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark 取消收藏数据请求
-(void)DeleteFavourite:(NSString *)caseID
{
    //DLOG(@"DeletecaseID==%@",caseID);
    if (self.EGLT.isLoggedIn) {
        NSString * soapMessage =
        [NSString stringWithFormat:
         @"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body> <DeleteCaseFavourite xmlns=\"egive.appservices\"><CaseID>%@</CaseID><MemberID>%@</MemberID></DeleteCaseFavourite></soap:Body></soap:Envelope>",caseID,self.memberString];
        
        [EGHomeModel postFavouriteWithParams:soapMessage block:^(NSString *data, NSError *error) {
            
            if ([data isEqual:@"\"\""]) {
                UIAlertView *alertView = [[UIAlertView alloc] init];
                alertView.message = HKLocalizedString(@"取消成功");
                [alertView addButtonWithTitle:HKLocalizedString(@"Common_button_confirm")];
                [alertView show];
                [self requestApiData:self.CString andMemberID:self.memberString];
                [self requestXQData:self.model.CaseID andMemberID:self.memberString];
            }else{
//                UIAlertView *alertView = [[UIAlertView alloc] init];
//                alertView.message = data;
//                [alertView addButtonWithTitle:HKLocalizedString(@"Common_button_confirm")];
//                [alertView show];
            }
            
        }];
    }
    else
    {
        //会员登录
        EGLoginViewController* vc = [[EGLoginViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark - private method cell请求数据
-(void)requestApiData:(NSString *)category andMemberID:(NSString *)memberID{
    [SVProgressHUD show];
    LanguageKey lang = [Language getLanguage];
    //DLOG(@"lang====%lu",lang);
    //请求列表数据
    if (self.searchTitle == nil) {
        self.searchTitle = @"";
    }
    
    NSString * soapMessage =
    [NSString stringWithFormat:
     @"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><GetCaseList xmlns=\"egive.appservices\"><Lang>%ld</Lang><Category>%@</Category><CaseTitle>%@</CaseTitle><MemberID>%@</MemberID><StartRowNo>1</StartRowNo><NumberOfRows>999</NumberOfRows></GetCaseList></soap:Body></soap:Envelope>",lang,category,self.searchTitle,self.memberString];
    
    [EGHomeModel postHomeItemListWithParams:soapMessage block:^(NSArray *data, NSError *error) {
        [SVProgressHUD dismiss];
        //DLOG(@"data====%@",data);
        if (self.cellArray.count>0) {
            [self.cellArray removeAllObjects];
        }
        for (NSDictionary * listDict in data) {
            if ([[listDict objectForKey:@"Isfavourite"] intValue]==1) {
                [self.cellArray addObject:listDict];
            }
            //DLOG(@"Isfavourite====%@",[listDict objectForKey:@"Isfavourite"]);
        }
//        self.cellArray=(NSMutableArray *)data;
//        DLOG(@"ww=%@",self.cellArray);
        [self GetAndSaveShoppingCart];
        
    }];
    
    [self testURL];
}

//请求购物车数据
- (void)GetAndSaveShoppingCart{
    NSString *cookieId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    if (![self.memberString isEqualToString:@""]) {
        cookieId=@"";
    }
    NSString * soapMsg =[NSString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                         "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                         "<soap:Body>"
                         "<GetAndSaveShoppingCart xmlns=\"egive.appservices\">"
                         "<Lang>%d</Lang>"
                         "<LocationCode>%@</LocationCode>"
                         "<DonateWithCharge>%d</DonateWithCharge>"
                         "<MemberID>%@</MemberID>"
                         "<CookieID>%@</CookieID>"
                         "<StartRowNo>%d</StartRowNo>"
                         "<NumberOfRows>%d</NumberOfRows>"
                         "</GetAndSaveShoppingCart>"
                         "</soap:Body>"
                         "</soap:Envelope>",1, @"HK",YES,self.memberString,cookieId,1,100];
    
    [EGHomeModel mypostHomeItemListWithParams:soapMsg block:^(NSArray *data, NSError *error) {
        //NSLog(@"dic===%@",data);
        NSDictionary * dataDic=(NSDictionary *)data;
        
        for(NSDictionary * dic in [dataDic objectForKey:@"ItemList"])
        {
            [self.IDarray addObject:[dic objectForKey:@"CaseID"]];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"newsNotification" object:nil userInfo:@{@"news" : [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"NumberOfItems"]]}];//更新购物车数量
        
        //NSLog(@"IDarray===%@",self.IDarray);
        [self.FRtableView reloadData];
        //[self setOCTableView];
        if (self.cellArray.count>0) {
            if ([[self.cellArray[0] objectForKey:@"Category"] length]>0) {
                self.CategoryString=[[self.cellArray[0] objectForKey:@"Category"] substringToIndex:1];
            }
            else
            {
                self.CategoryString=@"O";
            }
           [self requestXQData:[self.cellArray[0] objectForKey:@"CaseID"] andMemberID:self.memberString];
        }
    }];
}

#pragma mark - 右视图详情字体调整
-(void)clickTap
{
    self.fontView.hidden=YES;
}

-(void)clickLongPress
{
    self.fontView.hidden=NO;
}

-(void)setPressView
{
    self.fontView=[[UIImageView alloc] initWithFrame:CGRectMake(30, self.NRbgImageView.frame.size.height-80, self.NRbgImageView.frame.size.width-60, 50)];
    self.fontView.backgroundColor=[UIColor grayColor];
    self.fontView.userInteractionEnabled=YES;
    self.fontView.layer.masksToBounds = YES;
    self.fontView.layer.cornerRadius = 4.0;
    self.fontView.hidden=YES;
    self.fontView.alpha=0.8;
    [self.NRbgImageView addSubview:self.fontView];
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(50, (50-20)/2, self.fontView.frame.size.width-100, 20)];
    slider.minimumValue = 0;//指定可变最小值
    slider.maximumValue = 100;//指定可变最大值
    slider.value = 50;//指定初始值
    [slider addTarget:self action:@selector(updateValue:) forControlEvents:UIControlEventValueChanged];//设置响应事件
    [self.fontView addSubview:slider];
    
    UILabel * Llabel=[[UILabel alloc] initWithFrame:CGRectMake(20, (50-30)/2, 30, 30)];
    UILabel * Dlabel=[[UILabel alloc] initWithFrame:CGRectMake(self.fontView.frame.size.width-50, 0, 50, 50)];
    Llabel.text=@"A";
    Dlabel.text=@"A";
    Llabel.textAlignment=NSTextAlignmentRight;
    Llabel.font=[UIFont systemFontOfSize:16];
    Dlabel.font=[UIFont systemFontOfSize:22];
    [self.fontView addSubview:Llabel];
    [self.fontView addSubview:Dlabel];
}

-(void)updateValue:(UISlider *)sender{
    UILabel * label=(UILabel *)[self.ZYbgImageView viewWithTag:80];
    float f=(6/100.00)*sender.value; //读取滑块的值
    self.tableVFont=titleMinFont+f;
    label.font=[UIFont systemFontOfSize:titleMinFont+f];
    _font =[UIFont systemFontOfSize:titleMinFont+f];
    [self.OCTableView reloadData];
}

#pragma mark - 分享内容
-(void)clickShare
{
    if (self.detailDicData.count>0) {//self.model内容模型
        LanguageKey lang = [Language getLanguage];
        NSString * string = @"";
        NSString * subject = @"";
        //NSLog(@"self.nameString%@",self.model.Title);
        if (lang==1) {
            NSString *str = [NSString stringWithFormat:@"Egive – 點擊行善:%@,急需您的捐助 - %@/CaseDetail.aspx?CaseID=%@&lang=%lu\n\n請瀏覽: %@?lang=%lu\n\n意贈慈善基金\nEgive For You Charity Foundation\n電話: (852) 2210 2600\n電郵: info@egive4u.org",[self.model.Title stringByReplacingOccurrencesOfString:@"(null)" withString:@""],SITE_URL,self.model.CaseID,lang,SITE_URL,lang];
            string = str;
            subject = [NSString stringWithFormat:@"Egive – 點擊行善專案:%@",self.model.Title];
            
        }else if (lang==2){
            NSString *str = [NSString stringWithFormat:@"Egive – 点击行善:%@,急需您的捐助！ - %@/CaseDetail.aspx?CaseID=%@&lang=%lu\n\n请浏览: %@?lang=%lu\n\n意赠慈善基金\nEgive For You Charity Foundation\n电话: (852) 2210 2600\n电邮: info@egive4u.org",[self.model.Title stringByReplacingOccurrencesOfString:@"(null)" withString:@""],SITE_URL,self.model.CaseID,lang,SITE_URL,lang];
            string = str;
            subject = [NSString stringWithFormat:@"Egive - 点击行善专案:%@",self.model.Title];
        }else{
            NSString * str = [NSString stringWithFormat:@"Egive - Egive Projects:%@, needs your support! - %@/CaseDetail.aspx?CaseID=%@&lang=%lu\n\nVisit us at %@?lang=%lu\n\nEgive For You Charity Foundation\nTel: (852) 2210 2600\nEmail: info@egive4u.org",[self.model.Title  stringByReplacingOccurrencesOfString:@"(null)" withString:@""],SITE_URL,self.model.CaseID,lang,SITE_URL,lang];
            string = str;
            subject = [NSString stringWithFormat:@"Egive Projects:%@",self.model.Title];
        }
        NSString * image;
        if (self.model.GalleryImg.count>0) {
            image=[self.model.GalleryImg[0] objectForKey:@"ImgURL"];
        }
        else
        {
            image=@"dummy_case_related_default";
        }
        //,@"image":image
        NSDictionary * dic=@{@"title":subject,
                             @"content":string,
                             @"lang":[NSString stringWithFormat:@"%lu",lang],
                             @"caseID":self.model.CaseID};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FollowCaseShare" object:HKLocalizedString(@"MenuView_FollowCase_title") userInfo:dic];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
