//
//  HomeViewController.m
//  Egive-ipad
//
//  Created by vincentmac on 15/11/3.
//  Copyright (c) 2015年 Sino. All rights reserved.
//

#import "EGHomeViewController.h"
#import <Facebook-iOS-SDK/FBSDKCoreKit/FBSDKCoreKit.h>
#import <WeiboSDK/WeiboSDK.h>
#import "EGHomeModel.h"

#import "EGHomeTableViewCell.h"
#import "EGScrollView.h"
#import "EGHomeSportView.h"
#import "EGLoginViewController.h"
#import "EGLogoController.h"

@interface EGHomeViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,EGHomeCellDelegate,EGHomeSportViewDelegate>

@property (nonatomic,assign) int currentPage;
@property (nonatomic,strong) UITableView * FRtableView;
@property (nonatomic,strong) UIImageView * headBgView;
@property (nonatomic,strong) UIImageView * titleView;
@property (nonatomic,strong) UIScrollView * scrollView;
@property (nonatomic,strong) EGScrollView * loopScrollView;
@property (nonatomic,strong) EGHomeSportView * SportView;
@property (nonatomic,strong) NSMutableArray * SPic0Array;//广告图片数据
@property (nonatomic,strong) NSArray * SPic1Array;//广告数据
@property (nonatomic,strong) NSDictionary * moneyDic;//顶部[累积金额&累积人次]数据
@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,strong) NSMutableArray * cellArray;//cell数据
@property (nonatomic,strong) NSMutableArray * randomArray;//随机数组
@property (nonatomic,strong) NSMutableArray * IDarray;//购物车ID

@property (nonatomic,strong) NSString * memberString;//MemberID表示符

@property (nonatomic,strong) EGLoginTool * EGLT;

@property (nonatomic,strong) EGDataCenter * DC;//my单例

@property (nonatomic,strong) NSTimer * timerView;//刷新金额
@property (nonatomic,assign) BOOL isSwap;

@property (nonatomic,strong) NSArray * scrollArray;//滚动文字数组

@end

@implementation EGHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:233/255.0 green:234/255.0 blue:235/255.0 alpha:1];
    [self setModel];
    [self loadData];
    [self SetTableView];
    [self setMenoryDate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RefreshCellData) name:@"RefreshCellData" object:nil];
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


-(void)RefreshCellData
{
    [self.cellArray removeAllObjects];
    [self loadData];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RefreshCellData" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"scrollTitle" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"lastView" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cellDetail" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"newsNotification" object:nil];
}

-(void)setModel//初始化储存器
{
    self.EGLT=[EGLoginTool loginSingleton];
    EGUserModel * UModel=[self.EGLT currentUser];
    if (UModel.MemberID == nil) {
        self.memberString=@"";
    }
    else
    {
        self.memberString=UModel.MemberID;
    }
    self.SPic0Array=[[NSMutableArray alloc] init];
    self.SPic1Array=[[NSArray alloc] init];
    self.cellArray=[[NSMutableArray alloc] init];
    self.moneyDic=[[NSDictionary alloc] init];
    self.IDarray=[[NSMutableArray alloc] init];
    self.scrollArray=[[NSArray alloc] init];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.DC=[EGDataCenter shareDataCenter];
    if (self.DC.popupSting==nil) {
        [self GetAppInitImage];
    }
    EGUserModel * UModel=[self.EGLT currentUser];
    if (UModel.MemberID != nil) {
        self.memberString=UModel.MemberID;
    }
}

#pragma mark - 请求logo图片
-(void)GetAppInitImage{
    [SVProgressHUD show];
    NSString * soapMessage =
    [NSString stringWithFormat:
     @"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><GetAppInitImage xmlns=\"egive.appservices\" /></soap:Body></soap:Envelope>"
     ];
    [EGHomeModel mypostHomeItemListWithParams:soapMessage block:^(NSArray *data, NSError *error) {
        if (data.count>0) {
            //DLOG(@"data===%@",data);
            [SVProgressHUD dismiss];
            NSString * URL = [SITE_URL stringByAppendingPathComponent:[[data[0] objectForKey:@"FilePath"] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
            self.DC.popupSting=@"popupView";
            EGLogoController * EGBC=[[EGLogoController alloc] init];
            EGBC.urlString=URL;
            CGSize size = CGSizeMake(0, 44);
            [EGBC setContentSize:size  bgAction:NO animated:NO];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:EGBC];
            navigationController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [self presentViewController:navigationController animated:YES completion:nil];
        }
    }];
    [self testURL];
}

#pragma mark - 头部图片
-(void)showAdsData
{
    self.loopScrollView.pageCount = (int)self.SPic0Array.count;
    self.loopScrollView.showPageControl=YES;
    for (int i=0; i<self.SPic0Array.count; i++) {
        [self.loopScrollView setImageWithUrlString:self.SPic0Array[i] atIndex:i];
    }
    
    __weak typeof (self) weakSelf = self;
    [self.loopScrollView setClickAction:^(UIImageView *imageView, int index) {
        //DLOG(@"index===%d\ndattt==%@",index,weakSelf.SPic1Array[index]);
        if (index>=0) {
            NSDictionary * dic=weakSelf.SPic1Array[index];
            
            if (![[dic objectForKey:@"URL"] isEqualToString:@""]) {
                EGBannerController * EGDC=[[EGBannerController alloc] init];
                CGSize size = CGSizeMake(screenWidth-200, screenHeight-50);
                [EGDC setContentSize:size  bgAction:NO animated:NO];
                EGDC.url=[dic objectForKey:@"URL"];
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:EGDC];
                navigationController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                [weakSelf presentViewController:navigationController animated:YES completion:nil];
                
            }else if (![[dic objectForKey:@"RelatedImageFilePath"] isEqualToString:@""]){
                EGBannerController * EGDC=[[EGBannerController alloc] init];
                CGSize size = CGSizeMake(screenWidth-100, screenHeight-50);
                [EGDC setContentSize:size  bgAction:NO animated:NO];
                EGDC.url=@"";
                EGDC.imageurl=[dic objectForKey:@"RelatedImageFilePath"];
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:EGDC];
                navigationController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                [weakSelf presentViewController:navigationController animated:YES completion:nil];
                
            }else if(![[dic objectForKey:@"RelatedVideoFilePath"] isEqualToString:@""]){
                NSString * videoString=[dic objectForKey:@"RelatedVideoFilePath"];
                videoString = [SITE_URL stringByAppendingPathComponent:[videoString stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
                //DLOG(@"videoString===%@",videoString);
                MPMoviePlayerViewController *mpvc = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:videoString]];
                [weakSelf presentViewController:mpvc animated:YES completion:nil];
            }
        }
    }];
}

#pragma mark - TableView
-(void)SetTableView
{
    self.FRtableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth-64, screenHeight-64-10) style:UITableViewStylePlain];
    self.FRtableView.delegate=self;
    self.FRtableView.dataSource=self;
    self.FRtableView.separatorStyle = NO;
    [self.view addSubview:self.FRtableView];
    self.headBgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth-64, (screenHeight-64)/2.2+50)];
    self.headBgView.userInteractionEnabled=YES;
    //self.headBgView.backgroundColor=[UIColor redColor];
    self.FRtableView.tableHeaderView=self.headBgView;
    
    //[self setTitleView];

    //添加滚动视图
    _loopScrollView = [[EGScrollView alloc] initWithFrame:CGRectMake(self.headBgView.frame.origin.x, self.headBgView.frame.origin.y, screenWidth-64, (screenHeight-64)/2.2)];//953 × 320
    _loopScrollView.autoScroll = YES;
    [self.headBgView addSubview:_loopScrollView];
    _loopScrollView.pageCount = 1;
    [_loopScrollView setImage:[UIImage imageNamed:@"dummy_home_ad"] atIndex:0];
}

-(void)setAddAppCountdata
{
    //请求浏览人次数据
    NSString * num =
    [NSString stringWithFormat:
     @"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><AddAppCount xmlns=\"egive.appservices\"/></soap:Body></soap:Envelope>"
     ];
    [EGHomeModel mypostHomeItemListWithParams:num block:^(NSArray *data, NSError *error) {;
        
    }];
}

-(void)setTitleView
{
    self.titleView=[[UIImageView alloc] initWithFrame:CGRectMake(0, (screenHeight-64)/2.2, screenWidth-64, 50)];
    self.titleView.userInteractionEnabled=YES;
    self.titleView.backgroundColor=greeBar;
    //[UIColor colorWithRed:92/255.0 green:175/255.0 blue:33/255.0 alpha:1];
    [self.headBgView addSubview:self.titleView];
    
    self.SportView = [[EGHomeSportView alloc] initWithFrame:CGRectMake(390, 5, screenWidth-64-390, 40)];
    self.SportView.delegate=self;
    self.SportView.userInteractionEnabled=YES;
    [self.titleView addSubview:self.SportView];
    
    UIImageView * bgImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 390, 50)];
    bgImage.backgroundColor=greeBar;
    //[UIColor colorWithRed:92/255.0 green:175/255.0 blue:33/255.0 alpha:1];
    [self.titleView addSubview:bgImage];
    
    NSArray * imageArray=@[@"home_money_total",@"home_people_total"];
    NSArray * titleArray=@[HKLocalizedString(@"HomePage_cumulativeAmount_label"),
                           HKLocalizedString(@"HomePage_cumulative_label")];
                                             //@"浏览人数"
    int num=0;
    NSString * str=[NSString stringWithFormat:@"%@",[self.moneyDic objectForKey:@"TotalViewCount"]];
    if (self.DC.browseString==nil) {
        num=1;
        self.DC.browseString=@"ok";
        //DLOG(@"TotalViewCount===%@",[self.moneyDic objectForKey:@"TotalViewCount"]);
        num=num+[str intValue];
        [self setAddAppCountdata];
    }
    else
    {
        num=[str intValue];
    }
    NSArray * numArray;
    //DLOG(@"self.moneyDic==%@",self.moneyDic);
    if (self.moneyDic.count>0) {
        NSString * Amt=[self setNum:[[self.moneyDic objectForKey:@"TotalAmt"] intValue]];
        NSString * Count=[self setNum:num];
        numArray=@[[NSString stringWithFormat:@"%@",Amt],
                   [NSString stringWithFormat:@"%@",Count]];
    }
    else
    {
        numArray=@[@"",@""];
    }
    for (int i=0; i<2; i++) {
        //特别修改
        if (i==0) {
            [self setButton:self.titleView andTag:i andImage:imageArray[i] andTitle:titleArray[i] andNum:numArray[i] andX:0+(140+20)*i andY:5 andW:150 andH:40];
        }
        else
        {
            [self setButton:self.titleView andTag:i andImage:imageArray[i] andTitle:titleArray[i] andNum:numArray[i] andX:0+(130+20)*i andY:5 andW:165 andH:40];
        }
    }
    
    UILabel * lineLabel=[[UILabel alloc] initWithFrame:CGRectMake(321, 5, 1, 40)];
    lineLabel.backgroundColor=[UIColor whiteColor];
    lineLabel.alpha=0.4;
    [self.titleView addSubview:lineLabel];
    
    UIImageView * newsView=[[UIImageView alloc] initWithFrame:CGRectMake(335, 5, 40, 40)];
    newsView.image=[UIImage imageNamed:@"home_news_total"];
    [self.titleView addSubview:newsView];
}

-(NSString *)setNum:(int)num
{
    NSString * str;
    int a=num/1000;
    if (a>0) {
        str=[NSString stringWithFormat:@"%d,%d",a,num%1000];
        int b=a/1000;
        if (b>0) {
            str=[NSString stringWithFormat:@"%d,%d,%d",b,a%1000,num%1000];
            int c=b/1000;
            if (c>0) {
                str=[NSString stringWithFormat:@"%d,%d,%d,%d",c,b%1000,a%1000,num%1000];
                int d=c/1000;
                if (d>0) {
                    str=[NSString stringWithFormat:@"%d,%d,%d,%d,%d",d,c%1000,b%1000,a%1000,num%1000];
                }
            }
        }
    }
    else
    {
        str=[NSString stringWithFormat:@"%d",num];
    }
    return str;
}

#pragma mark 创建button
-(void)setButton:(UIImageView *)superView andTag:(int)tag andImage:(NSString *)image andTitle:(NSString *)title andNum:(NSString *)num andX:(float)x andY:(float)y andW:(float)w andH:(float)h
{
    UIButton * button=[[UIButton alloc] initWithFrame:CGRectMake(x, y, w, h)];
    //button.backgroundColor=[UIColor redColor];
    button.tag=tag;
    [superView addSubview:button];
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView * ImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, h, h)];
    ImageView.image=[UIImage imageNamed:image];
    
    UILabel * titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(h, 0, w-h+5, h/2)];
    //titleLabel.textAlignment=NSTextAlignmentCenter;
    //titleLabel.backgroundColor=[UIColor orangeColor];
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.text=title;
    titleLabel.font=[UIFont boldSystemFontOfSize:16];
    
    UILabel * numLabel=[[UILabel alloc] initWithFrame:CGRectMake(h, h/2, w-h, h/2)];
    //numLabel.textAlignment=NSTextAlignmentCenter;
    numLabel.textColor=[UIColor whiteColor];
    numLabel.font=[UIFont systemFontOfSize:16];
    if (tag==0) {
        numLabel.text=[NSString stringWithFormat:@"$%@",num];
    }
    else
    {
        numLabel.text=[NSString stringWithFormat:@"%@",num];
    }
    
    [button addSubview:ImageView];
    [button addSubview:titleLabel];
    [button addSubview:numLabel];
}

-(void)clickButton:(UIButton *)button
{
    //DLOG(@"button.tag==%lu",button.tag);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.cellArray.count%3==0) {
        return self.cellArray.count/3;
    }
    else
    {
        return self.cellArray.count/3+1;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return (((screenWidth-64-106)/3)*3)/4+29;
    }
    return (((screenWidth-64-106)/3)*3)/4+25;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * str=@"cell";
    EGHomeTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        
        cell=[[EGHomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        cell.delegate=self;
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;//cell的选中风格
    
    NSMutableArray * array=[[NSMutableArray alloc] init];
    for (int i=0; i<3; i++) {
        if ((i+indexPath.row*3)<self.cellArray.count) {
            [array addObject:self.cellArray[i+indexPath.row*3]];
        }
    }
    [cell setDataArray:array andIndex:(int)indexPath.row andID:self.IDarray andBool:self.isSwap andTypes:@"home"];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"indexPath.row==%lu",(long)indexPath.row);
}

#pragma mark - 滚动文字回调
-(void)clickTitleIndex:(int)index
{
    if([[self.scrollArray[index] objectForKey:@"Msg"] rangeOfString:HKLocalizedString(@"Support_Donation")].location==NSNotFound)
    {
        //DLOG(@"index==%@",[self.scrollArray[index] objectForKey:@"Msg"]);
        NSDictionary * dic=@{@"CaseID":[self.scrollArray[index] objectForKey:@"CaseID"],
                             @"MemberID":self.memberString};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollTitle" object:nil userInfo:@{@"index" : dic}];
    }
}

#pragma mark - cell回调方法
//点击最后一个VIEW跳到点击行善
-(void)clickLastView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"lastView" object:nil];
}

//点击View后返回的数据
-(void)clickView:(NSDictionary *)fdm and:(int)index
{
//    DLOG(@"fdm==%@",fdm);
//    DLOG(@"index==%d",index);
    NSDictionary * dic=@{@"Category":[fdm objectForKey:@"Category"],
                         @"CaseID":[fdm objectForKey:@"CaseID"],
                         @"MemberID":self.memberString};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cellDetail" object:nil userInfo:@{@"index" : dic}];
    //DLOG(@"index==%@",dic);
}

//添加购物车
-(void)saveShoppingCartItem:(NSString *)caseID andBut:(UIButton *)but andRemainingValue:(NSString *)RemainingValue andIsSuccess:(NSString *)Success andStyleStr:(NSString *)StyleStr
{
    //DLOG(@"AddcaseID==%@",caseID);
    if (but.selected) {
        if ([StyleStr isEqualToString:@"OK"]) {
            EGMyDonationViewController *root = [[EGMyDonationViewController alloc] initWithNibName:@"EGMyDonationViewController" bundle:nil];
            CGSize size = CGSizeMake(WIDTH-200, HEIGHT-100);
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
                UIAlertView *alertView = [[UIAlertView alloc] init];
                alertView.message = HKLocalizedString(@"alert_msg_saveShoppingCartItemSuccess");
                [alertView addButtonWithTitle:HKLocalizedString(@"Common_button_confirm")];
                [alertView show];
                [self GetAndSaveShoppingCart];
            }];
        }
    }
}

//添加收藏
-(void)AddCaseFavourite:(NSString *)caseID
{
    if (self.EGLT.isLoggedIn) {
        NSString * soapMessage =
        [NSString stringWithFormat:
         @"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><AddCaseFavourite xmlns=\"egive.appservices\"><CaseID>%@</CaseID><MemberID>%@</MemberID></AddCaseFavourite></soap:Body></soap:Envelope>",caseID,self.memberString];
        
        [EGHomeModel postFavouriteWithParams:soapMessage block:^(NSString *data, NSError *error) {
            //DLOG(@"data====%@",data);
            if ([data isEqual:@"\"\""]) {
                UIAlertView *alertView = [[UIAlertView alloc] init];
                alertView.message = HKLocalizedString(@"收藏成功");
                [alertView addButtonWithTitle:HKLocalizedString(@"Common_button_confirm")];
                [alertView show];
                [self loadData];
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

//取消收藏
-(void)DeleteCaseFavourite:(NSString *)caseID
{
    //DLOG(@"DeletecaseID==%@",caseID);
    if (self.EGLT.isLoggedIn) {
        NSString * soapMessage =
        [NSString stringWithFormat:
         @"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body> <DeleteCaseFavourite xmlns=\"egive.appservices\"><CaseID>%@</CaseID><MemberID>%@</MemberID></DeleteCaseFavourite></soap:Body></soap:Envelope>",caseID,self.memberString];
        
        [EGHomeModel postFavouriteWithParams:soapMessage block:^(NSString *data, NSError *error) {
            //DLOG(@"data====%@",data);
            if ([data isEqual:@"\"\""]) {
                UIAlertView *alertView = [[UIAlertView alloc] init];
                alertView.message = HKLocalizedString(@"取消成功");
                [alertView addButtonWithTitle:HKLocalizedString(@"Common_button_confirm")];
                [alertView show];
                [self loadData];
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

#pragma mark - private method数据请求
-(void)loadData{
    //DLOG(@"SITE_URL==%@",SITE_URL);
    //请求广告数据
    [SVProgressHUD show];
    NSString * Message =
    [NSString stringWithFormat:
     @"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><GetAppBannerAd xmlns=\"egive.appservices\" /></soap:Body></soap:Envelope>"
     ];
    
    [EGHomeModel mypostHomeItemListWithParams:Message block:^(NSArray *data, NSError *error) {;
        if (data.count>0) {
            self.SPic1Array=data;
            //DLOG(@"ssss=%@",self.SPic1Array);
            NSString *baseURL = SITE_URL;
            //DLOG(@"SITE_URL==%@",SITE_URL);
            for (NSDictionary * adDict in data) {
                //DLOG(@"adDict adDict = %@", adDict);
                NSString *  URL = [baseURL stringByAppendingPathComponent:[[adDict objectForKey:@"FilePath"] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"]];
                //DLOG(@"URL = %@", URL);
                [self.SPic0Array addObject:URL];
                [self.FRtableView reloadData];
            }
            [self showAdsData];
        }
    }];
    
    //请求顶部[累积金额&累积人次]数据
    NSString * money =
    [NSString stringWithFormat:
     @"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><GetTotalDonationInfo xmlns=\"egive.appservices\"/></soap:Body></soap:Envelope>"
     ];
    [EGHomeModel mypostHomeItemListWithParams:money block:^(NSArray *data, NSError *error) {;
        if (data.count>0) {
            self.moneyDic=(NSDictionary *)data;
            //DLOG(@"self.moneyDic==%@",self.moneyDic);
            [self setTitleView];
            [self.FRtableView reloadData];
        }
    }];
    LanguageKey lang = [Language getLanguage];
    //请求广播数据
    NSString * soap =
    [NSString stringWithFormat:
     @"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body> <GetDonationBar xmlns=\"egive.appservices\"><Lang>%ld</Lang><IsFirstTimeLoading>0</IsFirstTimeLoading><UpdateTime></UpdateTime><MemberID></MemberID></GetDonationBar></soap:Body></soap:Envelope>",lang
     ];
    [EGHomeModel postHomeItemListWithParams:soap block:^(NSArray *data, NSError *error) {
        //DLOG(@"data=%@",data);
        //self.SportView.str = [data[0] objectForKey:@"Msg"];
        if (data.count>0) {
            self.scrollArray=data;
            self.SportView.dataArray=data;
            //[self.SportView setArray:data];
            [self.FRtableView reloadData];
        }
    }];

    //DLOG(@"lang====%ld",lang);
    //请求列表数据
    NSString * soapMessage =
    [NSString stringWithFormat:
     @"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><GetCaseList xmlns=\"egive.appservices\"><Lang>%ld</Lang><Category>%@</Category><CaseTitle></CaseTitle><MemberID>%@</MemberID><StartRowNo>1</StartRowNo><NumberOfRows>12</NumberOfRows></GetCaseList></soap:Body></soap:Envelope>",lang,@"Random",self.memberString
     ];
    [EGHomeModel postHomeItemListWithParams:soapMessage block:^(NSArray *data, NSError *error) {
        //NSLog(@"array==%@",data);
        if (self.cellArray.count>0) {
            [self.cellArray removeAllObjects];
        }
        if (data.count>0) {
            [SVProgressHUD dismiss];
            for (int i=0; i<5; i++) {
                [self.cellArray addObject:data[i]];
            }
            //self.cellArray=(NSMutableArray *)data;//总数
            //DLOG(@"ww=%@",self.cellArray);
            [self GetAndSaveShoppingCart];
            //[self.FRtableView reloadData];
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

//请求购物车数据
- (void)GetAndSaveShoppingCart{
    NSString *cookieId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    //DLOG(@"cookieId==%@",cookieId);
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
        //DLOG(@"dic===%@",data);
        NSDictionary * dataDic=(NSDictionary *)data;
        for(NSDictionary * dic in [dataDic objectForKey:@"ItemList"])
        {
            [self.IDarray addObject:[dic objectForKey:@"CaseID"]];
        }
        //NSLog(@"IDarray===%@",self.IDarray);
        
        //[dataDic objectForKey:@"NumberOfItems"]购物车数量
        [[NSNotificationCenter defaultCenter] postNotificationName:@"newsNotification" object:nil userInfo:@{@"news" : [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"NumberOfItems"]]}];//更新购物车数量
        
        [self.FRtableView reloadData];
        
    }];
}


- (IBAction)facebook:(id)sender {
    
}


#define Weibo_redirectURI @"http://www.sina.com"

- (IBAction)weibo:(id)sender {
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = Weibo_redirectURI;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"LoginViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    
    [WeiboSDK sendRequest:request];
}


@end
