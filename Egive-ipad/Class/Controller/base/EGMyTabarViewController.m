//
//  EGMyTabarViewController.m
//  Egive-ipad
//
//  Created by User01 on 15/11/19.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGMyTabarViewController.h"
#import "EGLoginViewController.h"
#import "YQNavigationController.h"
#import "EGMyDonationViewController.h"
#import "EGClickCharityViewController.h"
#import "EGKindnessRankingViewController.h"
#import "SettingViewController.h"
#import "EGShareViewController.h"
#import "NSString+RegexKitLite.h"
#import "EGLoginByPushViewController.h"
#import "EGCompanyMemberZoneVC.h"
#import "AppDelegate.h"
#import "MemberFormModel.h"
#import "EGGiveInformationViewController.h"
#import "EGMessageController.h"

@interface EGMyTabarViewController ()<UIPopoverControllerDelegate>{
    
    //点击购物车弹窗
    YQNavigationController *_cartAlertVC;
}

@property (nonatomic,strong) UIImageView * tabBarBgImageView;
@property (nonatomic,strong) UIColor * titleColorNormal;
@property (nonatomic,strong) UIColor * titleColorSelected;
@property (nonatomic,assign) UIEdgeInsets barTitleEdge;
@property (nonatomic,assign) UIEdgeInsets barImageEdge;

@property (nonatomic,strong)UIViewController *currentViewController;
@property (nonatomic,strong) UIButton * currentSelectedButton;
@property (nonatomic,strong) NSArray * vcArray;
@property (nonatomic,strong) NSArray * photoArray;
@property (nonatomic,strong) NSArray * titleArray;
@property (nonatomic,strong) NSArray * selectedPhotoArray;

@property (nonatomic,strong) UIImageView * mainView;
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UIButton * leftButton;
@property (nonatomic,strong) UIButton * rightButton;
@property (nonatomic,strong) UIButton * memberButton;
@property (nonatomic,strong) UIButton * memberOneV;
@property (nonatomic,strong) UIImageView * giveView;
@property (nonatomic,strong) UILabel * butLabel; //username
@property (nonatomic,strong) UILabel * donationsLabel; //user 累计捐款
@property (nonatomic,strong) UIImageView * butImage;
@property (nonatomic,strong) UIButton * shareButton;

@property (nonatomic,strong) UILabel * newsLabel;//购物车数量

@property (nonatomic,assign) int tagString;//tag标志
@property (nonatomic,assign) int shareIndex;//点击行善分享标志
@property (nonatomic,assign) int mylang;//语言记录标志

@property (nonatomic,copy) NSString* shareType;//点击分享
@property (nonatomic,copy) NSDictionary* shareDic;//分享内容

@property (nonatomic,strong) NSString * charityString;

@property (nonatomic,strong)UILabel * myLabel;//未读信息
@property (nonatomic,strong)NSMutableArray * myArray;//未读信息

@property (strong, nonatomic) EGClickCharityModel * model;
@end

@implementation EGMyTabarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //@"Support"
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Support:) name:@"Support" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateNewsVolume:) name:@"UpdateNewsVolume" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DonationRecord:) name:@"DonationRecord" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newsInformation:) name:@"NEWNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(progressReport:) name:@"progressReport" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goGiveInformation:) name:@"GiveInformation" object:nil];//信息中心 －> 意贈活動
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollTitleView:) name:@"scrollTitle" object:nil];//页面跳转
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lastView) name:@"lastView" object:nil];//页面跳转
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(VCgoVC:) name:@"cellDetail" object:nil];//页面跳转
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NEWS:) name:@"newsNotification" object:nil];//更新购物车数量
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChangeChangeNotification) name:@"LanguageChange" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginChange_ByVC) name:@"loginChange_ByVC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLoginNameAndDonationUI) name:@"loginChange_reloadUI" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setRegisterVC) name:@"goRegisterVC_kevin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismRegisterVC) name:@"dismRegisterVC_kevin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rightButtonClick:) name:@"rightButtonClick_kevin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickCartAddCase) name:kCartAddCase object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GoToKindnessRanking) name:kToKindnessRanking object:nil];
    /********* 关于意增 **********/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isShowShareBtn:) name:@"AboutUs" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isShowShareBtn:) name:@"Chairman" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isNotShowShareBtn:) name:@"Public_OrganizationStructure" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isShowShareBtn:) name:@"Public_Egiver" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isNotShowShareBtn:) name:@"Public_DonationFlow" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isShowShareBtn:) name:@"Public_HowToJoin" object:nil];
    /*******************/
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isShowShareBtn:) name:@"FollowCaseShare" object:nil];//关注个案
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isShowShareBtn:) name:@"YesShare" object:nil];//点击行善
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isNotShowShareBtn:) name:@"NoShare" object:nil];//点击行善
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickCharityToNoShare) name:@"toNoShare" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isShowShareBtn:) name:@"showShare_kevin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isNotShowShareBtn:) name:@"NotShowShare_kevin" object:nil];
    self.shareType = @"";
    self.mylang = [Language getLanguage];
    [self loadData:@""];
}

-(void)loginChange_ByVC{
    int beforeLoginButtonTag = [[[NSUserDefaults standardUserDefaults] objectForKey:@"beforeLoginButtonTag_kevin"] intValue];
     self.tagString = beforeLoginButtonTag;
    
    [self changeLoginNameAndDonationUI];
    if (![EGLoginTool loginSingleton].isLoggedIn) {
        [self refreshVCViewByTag:beforeLoginButtonTag];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LanguageChange" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"loginChange_ByVC" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"goRegisterVC_kevin" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"dismRegisterVC_kevin" object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"rightButtonClick_kevin" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCartAddCase object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kToKindnessRanking object:nil];
}
#pragma mark - 请求表格数据
-(void)requestMemberFormData:(int)lang{
    [SVProgressHUD show];
    [MemberFormModel getMemberFormModelData:lang Block:^(NSDictionary *result, NSError *error) {
        [SVProgressHUD dismiss];
        int tag = [[[NSUserDefaults standardUserDefaults] objectForKey:@"beforeButtonTag_kevin"] intValue];
        
        if (!error) {
            NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
            [standardUserDefaults setObject:result forKey:[NSString stringWithFormat:@"EGIVE_MemberFormModel_%d_kevin",lang]];
            [standardUserDefaults synchronize];
            if (tag == 20) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshUI_kevin" object:nil];
            }
        }
        
    }];
}
#pragma mark 语言改变
- (void)languageChangeChangeNotification
{
    int lang = [Language getLanguage];
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary* dict=[standardUserDefaults objectForKey:[NSString stringWithFormat:@"EGIVE_MemberFormModel_%d_kevin",lang]];
    if (!dict) {
        [self requestMemberFormData:lang];
    }else{
        int tag = [[[NSUserDefaults standardUserDefaults] objectForKey:@"beforeButtonTag_kevin"] intValue];
        if (tag == 20) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshUI_kevin" object:nil];
        }
    }
    
    
    NSArray *titleArray = @[HKLocalizedString(@"MenuView_homeButton_title"),
                            HKLocalizedString(@"MenuView_FollowCase_title"),
                            HKLocalizedString(@"MenuView_MessageCenter_title"),
                            HKLocalizedString(@"MenuView_aboutButton_title"),
                            HKLocalizedString(@"MenuView_girdButton_title"),
                            HKLocalizedString(@"MenuView_rankingButton_title"),
                            HKLocalizedString(@"MenuView_InformationButton_title"),
                            HKLocalizedString(@"MenuView_shareButton_title"),
                            HKLocalizedString(@"MenuView_settingButton_title")];
    self.titleArray=titleArray;
    UILabel * label=(UILabel *)[self.memberButton viewWithTag:200];
    if ([EGLoginTool loginSingleton].isLoggedIn) {
        EGUserModel * model = [[EGLoginTool loginSingleton] currentUser];
        label.text = model.LoginName;
        if ([model.MemberType isEqualToString:@"P"]) {
            
            self.donationsLabel.text = HKLocalizedString(@"个人累积捐款");
        }else{
            self.donationsLabel.text = HKLocalizedString(@"企业累积捐款");
        }
        
    }else{
        label.text=HKLocalizedString(@"MenuView_topTitle");
    }
    
    self.memberButton.hidden = NO;
    if (self.tagString==18) {
        int tag = [[[NSUserDefaults standardUserDefaults] objectForKey:@"beforeButtonTag_kevin"] intValue];
        if (tag<=18) {
            self.titleLabel.text= [titleArray[tag-10] stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        }else{
            if (tag == 19) {
                self.titleLabel.text=HKLocalizedString(@"会员专区");
            }else if (tag == 20){
                self.titleLabel.text=HKLocalizedString(@"意赠之友登记表格");
                self.memberButton.hidden = YES;
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshUI_kevin" object:nil];
            }
        }
        if (tag==10)
        {
            self.titleLabel.text = @"";
        }
    }
    else
    {
        if (self.tagString!=10) {
            self.titleLabel.text = [titleArray[self.tagString-10] stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        }
        
    }
    
    for (int i=0; i<titleArray.count; i++) {
        UIButton * button=(UIButton *)[self.tabBarBgImageView viewWithTag:10+i];
        UILabel * label=(UILabel *)[button viewWithTag:20001];
        label.text=titleArray[i];
    }
}
#pragma mark 是否显示分享按钮
//
-(void)isShowShareBtn:(NSNotification *)notification
{
    self.charityString=@"charity";
    [self changeShareUI:YES];
    id sendValue=[notification object];
    if (sendValue||[sendValue isKindOfClass:[NSString class]]) {
        self.shareType = sendValue;
    }
    
    if (notification.userInfo!=nil) {
        self.shareDic=notification.userInfo;
    }
}
-(void)isNotShowShareBtn:(NSNotification *)notification
{
    self.charityString=@"";
    [self changeShareUI:NO];
}
-(void)changeShareUI:(BOOL)isShow{

    if (self.tagString == 16) {
        self.shareType = HKLocalizedString(@"DonationInfo_foreshowButton");
    }
    if ([EGLoginTool loginSingleton].isLoggedIn) {
        CGRect frame = [self.donationsLabel.attributedText boundingRectWithSize:CGSizeMake(MAXFLOAT, 44) options:NSStringDrawingUsesFontLeading context:nil];
        CGFloat width = frame.size.width+10 + 10 + 50 +([Language getLanguage] == 3?20:0);//10间距 10误差 50图标 20语言英语
        if (isShow) {
            self.memberButton.frame = CGRectMake(screenWidth -20-34-width-10-34, 20, width, 44);
            self.shareButton.hidden=NO;
        }
        else
        {
            self.shareButton.hidden=YES;
            self.memberButton.frame=CGRectMake(screenWidth -20-34-width-10, 20, width, 44);
        }
       
        self.butLabel.frame = CGRectMake(5, 2, width-50, 20);
        self.donationsLabel.frame = CGRectMake(5, 22, width-50, 20);
        self.butImage.frame =CGRectMake(width-30, (44-30)/2, 30, 30);
    }else{
        if (isShow) {
            self.memberButton.frame = CGRectMake(screenWidth -20-34-200-34, 20, 200, 44);
            self.shareButton.hidden=NO;
        }
        else
        {
            self.shareButton.hidden=YES;
            self.memberButton.frame=CGRectMake(screenWidth -20-34-210, 20, 200, 44);
        }
        self.donationsLabel.frame = CGRectMake(5, 22, self.memberButton.frame.size.width-50, 20);
        self.butLabel.frame = CGRectMake(5, (44-20)/2, self.memberButton.frame.size.width-50, 20);
        self.butImage.frame = CGRectMake(self.memberButton.frame.size.width-30, (44-30)/2, 30, 30);
    }
    
    
}

#pragma mark 改变登录的usename UI
//by kevin
-(void)changeLoginNameAndDonationUI{
    if (self.tagString==11||self.tagString==12||self.tagString==13||self.shareIndex==14||self.tagString == 16) {
        [self changeShareUI:YES];
    }
    else
    {
        [self changeShareUI:NO];
    }
    if ([EGLoginTool loginSingleton].isLoggedIn) {
        
        self.butLabel.frame = CGRectMake(5, 2, self.memberButton.frame.size.width-50, 20);
        self.butLabel.textColor = [UIColor blackColor];
        self.donationsLabel.hidden = NO;
        EGUserModel * model = [[EGLoginTool loginSingleton] currentUser];
        
        self.butLabel.text = model.LoginName;
//        if ([model.MemberType isEqualToString:@"P"]) {
//            
//            self.donationsLabel.text = HKLocalizedString(@"个人累积捐款");
//        }else{
//            self.donationsLabel.text = HKLocalizedString(@"企业累积捐款");
//        }
        
        [self GetMemberTotalDonationAmountData:model.MemberID :model.MemberType];
        self.butImage.image=[UIImage imageNamed:@"common_header_account_sel"];
        
    }else{
        
        self.butLabel.text=HKLocalizedString(@"MenuView_topTitle");
        self.butLabel.textColor = MemberZoneTextColor;
        self.donationsLabel.hidden = YES;
        self.butImage.image=[UIImage imageNamed:@"common_header_account"];
    }
    //[self GetMemberTotalDonationAmount:_item.MemberID];
    //DLOG(@"self.tagString===%d",self.tagString);
}
#pragma mark - 请求登录后用户状态信息(会员的捐款总额)
- (void)GetMemberTotalDonationAmountData:(NSString *)memberId :(NSString *)memberType {
    NSLog(@"memberId ===== %@",memberId);
    NSString * soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><GetMemberTotalDonationAmount xmlns=\"egive.appservices\"><MemberID>%@</MemberID></GetMemberTotalDonationAmount></soap:Body></soap:Envelope>",memberId];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/appservices/webservice.asmx?wsdl", SITE_URL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    [request addValue: @"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
       
        
        NSString *dataString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary * dict = [NSString parseJSONStringToNSDictionary:dataString];
        
        NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
        [standardUserDefaults setObject:dict forKey:@"EGIVE_DonationAmountData"];
        [standardUserDefaults synchronize];
        
        NSString* donaStr = [NSString stringWithFormat:@" HKD$ %@",[dict[@"Amt"] stringByReplacingOccurrencesOfString:@"(null) " withString:@"0"]];
        NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:14],NSFontAttributeName,nil];
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:donaStr attributes:attributeDict];
        NSString* str = @"";
        if ([memberType isEqualToString:@"P"]) {
            str = HKLocalizedString(@"个人累积捐款");
        }else{
            str = HKLocalizedString(@"企业累积捐款");
        }
        NSMutableAttributedString *donationsLabelStr = [[NSMutableAttributedString alloc] initWithString:str];
        [donationsLabelStr appendAttributedString:AttributedStr];
        self.donationsLabel.attributedText = donationsLabelStr;
        if (self.tagString==11||self.tagString==12||self.tagString==13||self.shareIndex==14||self.tagString == 16) {
            [self changeShareUI:YES];
        }
        else
        {
            [self changeShareUI:NO];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
        NSLog(@"success = %@", error);
    }];
    
    [operation start];
}

-(void)NEWS:(NSNotification *)notification
{
    self.newsLabel.backgroundColor=tabarColor;
    self.newsLabel.textColor=[UIColor whiteColor];
    self.newsLabel.text=notification.userInfo[@"news"];
    
    if ([notification.userInfo[@"news"] intValue]==0) {
        self.newsLabel.backgroundColor=[UIColor clearColor];
        self.newsLabel.textColor=[UIColor clearColor];
    }
}

-(void)addV//添加tab模糊视图
{
    UIImageView * UIV=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 64)];
    UIV.backgroundColor=[UIColor blackColor];
    UIV.userInteractionEnabled=YES;
    UIV.tag=1000;
    UIV.alpha=0.5;
    [self.view addSubview:UIV];
    
    UIImageView * UIV1=[[UIImageView alloc] initWithFrame:CGRectMake(0, 64, 64, screenHeight-64)];
    UIV1.backgroundColor=[UIColor blackColor];
    UIV1.userInteractionEnabled=YES;
    UIV1.tag=1001;
    UIV1.alpha=0.5;
    [self.view addSubview:UIV1];
}

-(void)removeV//删除tab模糊视图
{
    UIImageView * IV=(UIImageView *)[self.view viewWithTag:1000];
    [IV removeFromSuperview];
    UIImageView * IV1=(UIImageView *)[self.view viewWithTag:1001];
    [IV1 removeFromSuperview];
}

-(void)setTabBarControllerWithVCArray:(NSArray *)vcArray andPhotoArray:(NSArray *)photoArray selectedPhotoArray:(NSArray *)selectedPhotoArray titleArray:(NSArray *)titleArray{
    
    UIViewController *fVC = [[[vcArray objectAtIndex:0]alloc]init];
    fVC.view.frame = CGRectMake(64, 64, screenWidth-64, self.view.frame.size.height-64);
    //将fVC设置为当前控制器
    self.currentViewController = fVC;
    [self.view addSubview:fVC.view];
    [self addChildViewController:fVC];
    
    self.photoArray = photoArray;
    self.titleArray = titleArray;
    self.vcArray = vcArray;
    self.selectedPhotoArray = selectedPhotoArray;
    
    //必须要都有值
    if (!(self.photoArray.count > 0 && self.titleArray.count > 0 && self.vcArray.count > 0)) {
        return;
    }
    
    [self setNavigationBar];
    [self setTabBar];
}

-(void)setNavigationBar{
    self.mainView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 64)];
    self.mainView.userInteractionEnabled = YES;
    self.mainView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mainView];
    
    UILabel * lane1=[[UILabel alloc] initWithFrame:CGRectMake(0, 63, screenWidth, 1)];
    lane1.backgroundColor=[UIColor grayColor];
    lane1.alpha=0.4;
    [self.mainView addSubview:lane1];
    
    //设置title
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, screenWidth-100, 44)];
    self.titleLabel.textColor=tabarColor;
    self.titleLabel.userInteractionEnabled=YES;
    self.titleLabel.numberOfLines=0;
    self.titleLabel.textAlignment=NSTextAlignmentCenter;
    [self.mainView addSubview:self.titleLabel];
    
    //设置中间give图片
    self.giveView = [[UIImageView alloc] initWithFrame:CGRectMake((screenWidth-(44*83.000)/60.000)/2, 20, (44*75)/45, 44)];
    //self.giveView.backgroundColor=[UIColor redColor];
    [self.mainView addSubview:self.giveView];
    
    //创建左按钮
    self.leftButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, (44*75)/45, 44)];
    //self.leftButton.backgroundColor=[UIColor orangeColor];
    [self.leftButton addTarget:self action:@selector(dismVC) forControlEvents:UIControlEventTouchUpInside];
    [self.mainView addSubview:self.leftButton];
    
    //创建右按钮
    self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth - 20 - 34, 25, 34, 44 - 5*2)];
    //self.rightButton.backgroundColor=[UIColor greenColor];
    [self.rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton setImage:[UIImage imageNamed:@"common_header_cart"] forState:UIControlStateNormal];
    [self.mainView addSubview:self.rightButton];
    
    self.newsLabel=[[UILabel alloc] init];
    self.newsLabel.frame=CGRectMake(20, 15, 15, 15);
    //self.newsLabel.backgroundColor=[UIColor redColor];
    self.newsLabel.textColor=[UIColor whiteColor];
    self.newsLabel.font=[UIFont systemFontOfSize:12];
    self.newsLabel.textAlignment=NSTextAlignmentCenter;
    self.newsLabel.layer.masksToBounds=YES;
    self.newsLabel.layer.cornerRadius =7.5;
    [self.rightButton addSubview:self.newsLabel];
    
    //创建会员按钮
    self.memberButton = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth -20-34-210, 20, 200, 44)];
//    self.memberButton.backgroundColor=[UIColor greenColor];
    [self.memberButton addTarget:self action:@selector(clickMemberButton) forControlEvents:UIControlEventTouchUpInside];
    [self.mainView addSubview:self.memberButton];
    
    //创建 loginName label
    self.butLabel=[[UILabel alloc] initWithFrame:CGRectMake(5, 2, self.memberButton.frame.size.width-50, 20)];
    self.butLabel.textAlignment=NSTextAlignmentRight;
    self.butLabel.tag=200;
    //self.butLabel.text=HKLocalizedString(@"MenuView_topTitle");
    self.butLabel.font=[UIFont systemFontOfSize:14];
//    self.butLabel.backgroundColor=[UIColor redColor];
    [self.memberButton addSubview:self.butLabel];
    
    //创建 捐款 label
    self.donationsLabel=[[UILabel alloc] initWithFrame:CGRectMake(5, 22, self.memberButton.frame.size.width-50, 20)];
    self.donationsLabel.textAlignment=NSTextAlignmentRight;
    self.donationsLabel.tag=201;
    self.donationsLabel.textColor = MemberZoneTextColor;
    self.donationsLabel.font=[UIFont systemFontOfSize:14];
//    self.donationsLabel.backgroundColor=[UIColor redColor];
    [self.memberButton addSubview:self.donationsLabel];
    
    
    self.butImage=[[UIImageView alloc] initWithFrame:CGRectMake(self.memberButton.frame.size.width-30, (44-30)/2, 30, 30)];
    //self.butImage.image=[UIImage imageNamed:@"common_header_account"];
    [self.memberButton addSubview:self.butImage];
    
    //创建分享按钮
    self.shareButton = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth - 20 - 34-34, 25, 34, 44 - 5*2)];
    self.shareButton.hidden=YES;
    //self.shareButton.backgroundColor=[UIColor redColor];
    [self.shareButton setImage:[UIImage imageNamed:@"common_header_share"] forState:UIControlStateNormal];
    [self.mainView addSubview:self.shareButton];
    [self.shareButton addTarget:self action:@selector(clickshareButton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.memberOneV=[[UIButton alloc] initWithFrame:self.memberButton.bounds];
    //button.backgroundColor=[UIColor redColor];
    [self.memberButton addSubview:self.memberOneV];
    [self.memberOneV addTarget:self action:@selector(clickMemberButton) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 顶部分享
-(void)clickshareButton:(UIButton *)button
{
    if (self.shareType.length == 0 && self.tagString == 16) {
        self.shareType = HKLocalizedString(@"DonationInfo_foreshowButton");
    }
    else if (self.tagString == 12){
        self.shareType = @"讯息中心";
    }
    if (self.shareType.length != 0) {
        if ([self.shareType isEqualToString:HKLocalizedString(@"DonationInfo_foreshowButton")]) {
            [self shareForeshowStr];
        }
        else if([self.shareType isEqualToString:HKLocalizedString(@"MenuView_FollowCase_title")]){
            NSString * urlStr=[NSString stringWithFormat:@"%@/CaseDetail.aspx?CaseID=%@&lang=%@",SITE_URL,[self.shareDic objectForKey:@"caseID"],[self.shareDic objectForKey:@"lang"]];
            
            [self showVCWithSubject:[self.shareDic objectForKey:@"title"] content:[self.shareDic objectForKey:@"content"] url:urlStr image:nil];
        }
        else if ([self.shareType isEqualToString:HKLocalizedString(@"DonationInfo_releaseButton")]) {
            [self shareReleaseCenterStr];
        }
        else if ([self.shareType isEqualToString:HKLocalizedString(@"MenuView_girdButton_title")]){
            NSString * urlStr=[NSString stringWithFormat:@"%@/CaseDetail.aspx?CaseID=%@&lang=%@",SITE_URL,[self.shareDic objectForKey:@"caseID"],[self.shareDic objectForKey:@"lang"]];

            [self showVCWithSubject:[self.shareDic objectForKey:@"title"] content:[self.shareDic objectForKey:@"content"] url:urlStr image:nil];
            //[UIImage imageNamed:[self.shareDic objectForKey:@"image"]]
        }
        else if ([self.shareType isEqualToString:HKLocalizedString(@"MenuView_aboutButton_title")]){
            NSString * urlStr=[NSString stringWithFormat:@"%@/%@.aspx?CaseID=%@&lang=%@",SITE_URL,[self.shareDic objectForKey:@"caseTitle"],[self.shareDic objectForKey:@"caseTitle"],[self.shareDic objectForKey:@"lang"]];
            
            [self showVCWithSubject:[self.shareDic objectForKey:@"title"] content:[self.shareDic objectForKey:@"content"] url:urlStr image:nil];
            //[UIImage imageNamed:[self.shareDic objectForKey:@"image"]]
        }
    }
    
}
// 意贈資訊版塊分享內容如下：
-(void)shareForeshowStr{//意赠资讯的内容
//    1. 意赠活动- Egive意贈活動- <活動名稱>
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];

    NSString* EventName =[standardUserDefaults objectForKey:@"EventName_GiveInfomation_foreshow"];
    UIImage* EventImage =[standardUserDefaults objectForKey:@"EventPic_GiveInfomation_foreshow"];
    NSString * content = @"";
    NSString * subject = @"";
    NSString * lang = @"";
    
    if ([Language getLanguage]==1) {
        NSString *str = [NSString stringWithFormat:@"Egive-意贈活動\n%@\n活動詳情，請瀏覽:%@EventPreview.aspx?lang=1 \n\n意贈慈善基金\nEgive For You Charity Foundation\n電話: (852) 2210 2600\n電郵: info@egive4u.org",EventName,SITE_URL];
        content = str;
        subject = [NSString stringWithFormat:@"Egive意贈活動 - %@",EventName];
        lang = @"?lang=1";
        
    }else if ([Language getLanguage]==2){
        NSString *str = [NSString stringWithFormat:@"Egive-意赠活动\n%@\n活动详情，请浏览:%@EventPreview.aspx?lang=2 \n\n意赠慈善基金\nEgive For You Charity Foundation\n电话: (852) 2210 2600\n电邮: info@egive4u.org",EventName,SITE_URL];
        content = str;
        subject = [NSString stringWithFormat:@"Egive意赠活动 - %@",EventName];
        lang = @"?lang=2";
    }else{
        
        NSString * str = [NSString stringWithFormat:@"Egive-Events\n%@\nPlease visit %@EventPreview.aspx?lang=3 for event details.\n\nEgive For You Charity Foundation\nTel: (852) 2210 2600\nEmail: info@egive4u.org",EventName,SITE_URL];
        content = str;
        subject = [NSString stringWithFormat:@"Egive - Events - %@",EventName];
        lang = @"?lang=3";
    }
    [self showVCWithSubject:subject content:content url:[NSString stringWithFormat:@"%@EventPreview.aspx%@",SITE_URL,lang] image:EventImage?EventImage:[UIImage imageNamed:@"dummy_case_related_default"]];
}
-(void)shareReleaseCenterStr{
//    3. 发布中心- Egive 發佈中心 - <文件名稱>
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString* TitleName = [standardUserDefaults objectForKey:@"EventName_GiveInfomation_center"];
    UIImage* EventImage =[standardUserDefaults objectForKey:@"EventPic_GiveInfomation_center"];
    NSString * content = @"";
    NSString * subject = @"";
    NSString * lang = @"";
    
    if ([Language getLanguage]==1) {
        NSString *str = [NSString stringWithFormat:@"Egive -  發佈中心\n%@已上載，請瀏覽:%@DownloadForm.aspx?type=A&lang=1 \n\n意贈慈善基金\nEgive For You Charity Foundation\n電話: (852) 2210 2600\n電郵: info@egive4u.org",TitleName,SITE_URL];
        content = str;
        subject = [NSString stringWithFormat:@"Egive 發佈中心 - %@",TitleName];
        lang = @"&lang=1";
        
    }else if ([Language getLanguage]==2){
        
        NSString *str = [NSString stringWithFormat:@"Egive -  发布中心\n%@已上载，请浏览:%@DownloadForm.aspx?type=A&lang=2 \n\n意赠慈善基金\nEgive For You Charity Foundation\n电話: (852) 2210 2600\n电邮: info@egive4u.org",TitleName,SITE_URL];
        content = str;
        subject = [NSString stringWithFormat:@"Egive 发布中心 - %@",TitleName];
        lang = @"&lang=2";
        
    }else{
        
        NSString * str = [NSString stringWithFormat:@"Egive - Publication\n%@ has been released, pelase visit %@DownloadForm.aspx?type=A&lang=3 for details.\n\nEgive For You Charity Foundation\nTel: (852) 2210 2600\nEmail: info@egive4u.org",TitleName,SITE_URL];
        content = str;
        subject = [NSString stringWithFormat:@"Egive - Publication - %@",TitleName];
        lang = @"&lang=3";
        
    }
    [self showVCWithSubject:subject content:content url:[NSString stringWithFormat:@"%@DownloadForm.aspx?type=A%@",SITE_URL,lang] image:EventImage?EventImage:[UIImage imageNamed:@"dummy_case_related_default"]];
}

-(void)showVCWithSubject:(NSString *)subject content:(NSString *)content url:(NSString *)url image:(UIImage *)image{
    EGShareViewController * shareVC= [[EGShareViewController alloc]initWithSubject:subject content:content url:url image:image Block:nil];
    [shareVC showShareUIWithPoint:CGPointMake(self.shareButton.frame.origin.x-45, 0) view:self.currentViewController.view permittedArrowDirections:UIPopoverArrowDirectionUp];
}


#pragma mark - 登陆
-(void)clickMemberButton
{
    if (self.tagString != 19) {
        [[NSUserDefaults standardUserDefaults] setInteger:self.tagString forKey:@"beforeLoginButtonTag_kevin"];
    }
    BOOL login = [EGLoginTool loginSingleton].isLoggedIn;
    if (login) {
        [self setMeberVC];
    }else{
        if (self.tagString != 19) {
            NSLog(@"会员登录");
            //        EGLoginByPushViewController* vc = [[EGLoginByPushViewController alloc]init];
            EGLoginViewController* vc = [[EGLoginViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    //[self setMeberVC];
    //[self setRegisterVC];
}
#pragma mark - 会员
-(void)setMeberVC
{
    self.currentSelectedButton.selected = NO;
    self.currentSelectedButton.backgroundColor = [UIColor clearColor];
    [self.currentViewController.view removeFromSuperview];
    [self.currentViewController removeFromParentViewController];
    
    UIViewController *fVC = nil;
    if ([EGLoginTool loginSingleton].isLoggedIn && [[EGLoginTool loginSingleton].currentUser.MemberType isEqualToString:@"C"]) {
        fVC = [[EGCompanyMemberZoneVC alloc] initWithNibName:@"EGCompanyMemberZoneVC" bundle:nil];
    }else{
        fVC = [[[self.vcArray objectAtIndex:9]alloc]init];
    }
    self.tagString = 19;
    //fVC.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    fVC.view.frame = CGRectMake(64, 64, screenWidth-64, self.view.frame.size.height-64);
    //将fVC设置为当前控制器
    self.currentViewController = fVC;
    [self.view addSubview:fVC.view];
    [self addChildViewController:fVC];
    [self.giveView setImage:[UIImage imageNamed:@""]];
    self.titleLabel.text=HKLocalizedString(@"会员专区");
    [self.leftButton setImage:[UIImage imageNamed:@"common_header_logo"] forState:UIControlStateNormal];
     self.memberButton.hidden = NO;
    
    [self changeShareUI:NO];
    [self setImageAndTitle:9];
}
#pragma mark - 注册
-(void)setRegisterVC
{
    [self.currentViewController.view removeFromSuperview];
    [self.currentViewController removeFromParentViewController];
    self.currentSelectedButton.selected = NO;
    self.currentSelectedButton.backgroundColor = [UIColor clearColor];
    UIViewController *fVC = [[[self.vcArray objectAtIndex:10]alloc]init];
    self.tagString = 20;
    
    //fVC.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    fVC.view.frame = CGRectMake(64, 64, screenWidth-64, self.view.frame.size.height-64);
    //将fVC设置为当前控制器
    self.currentViewController = fVC;
    [self.view addSubview:fVC.view];
    [self addChildViewController:fVC];
    [self.giveView setImage:[UIImage imageNamed:@""]];
    self.titleLabel.text=HKLocalizedString(@"意赠之友登记表格");
    [self.leftButton setImage:[UIImage imageNamed:@"ic_header_logo-1"] forState:UIControlStateNormal];
//    self.butLabel.text=@"";
//    self.butImage.image=[UIImage imageNamed:@""];
    self.memberButton.hidden = YES; //by Kevin
    self.shareButton.hidden=YES;
    [self setImageAndTitle:10];
   
}
//实现返回功能
-(void)dismRegisterVC{
    NSLog(@"返回功能");
    EGLoginViewController* vc = [[EGLoginViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    int beforeLoginButtonTag = [[[NSUserDefaults standardUserDefaults] objectForKey:@"beforeLoginButtonTag_kevin"] intValue];
    [self refreshVCViewByTag:beforeLoginButtonTag];
   
}

//刷新页面
-(void)refreshVCViewByTag:(int)tag{
    for (UIView* subView in self.tabBarBgImageView.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton* button = (UIButton*)subView;
            if (button.tag ==tag) {
                [self vcChangeButtonClick:button];
            }
        }
    }
   
}

//实现返回功能
-(void)dismVC{
    //[self.navigationController popViewControllerAnimated:YES];
    if (self.tagString == 20) {
        [self dismRegisterVC];
    }
}




#pragma mark 点击购物车
-(void)rightButtonClick:(UIButton *)button{
    //[self.navigationController pushViewController:IVC animated:YES];
    
    
    
    if (!_cartAlertVC) {
        
    }
    
    
    
    //
    
    EGMyDonationViewController *root = [[EGMyDonationViewController alloc] initWithNibName:@"EGMyDonationViewController" bundle:nil];
//    YQNavigationController *cartAlertVC = [[YQNavigationController alloc] initWithSize:CGSizeMake(WIDTH-200, HEIGHT-100) rootViewController:root];
//    _cartAlertVC = cartAlertVC;
//    cartAlertVC.touchSpaceHide = NO;//点击没有内容的地方消失
//    cartAlertVC.panPopView = YES;//滑动返回上一层视图
//    //nav.rootViewController = root;
//    root.title = [Language getStringByKey:@"MyDonation_Title"];
//    
//    [_cartAlertVC show:YES animated:NO];
    
    
    //保存弹起购物车标记
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setBool:YES forKey:kShowAlertDonation];
    [standardUserDefaults synchronize];
    
    //
    CGSize size = CGSizeMake(WIDTH-200, HEIGHT-100);//(410, 570)
    [root setContentSize:size  bgAction:NO animated:NO];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:root];
    navigationController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:navigationController animated:YES completion:nil];
}

-(void)setTabBar{
    
    //设置tabBar的背景颜色
    self.tabBarBgImageView = [[UIImageView alloc]init];
    self.tabBarBgImageView.frame = CGRectMake(0, 64, 64, screenHeight);
    self.tabBarBgImageView.userInteractionEnabled = YES;
    self.tabBarBgImageView.tag=2000;
    self.tabBarBgImageView.backgroundColor = [UIColor whiteColor];
    //self.tabBarBgImageView.image=[UIImage imageNamed:@"fgxx.png"];
    [self.view addSubview:self.tabBarBgImageView];
    
    UILabel * lane2=[[UILabel alloc] initWithFrame:CGRectMake(63, 0, 1, screenHeight-64)];
    lane2.backgroundColor=[UIColor grayColor];
    lane2.alpha=0.4;
    [self.tabBarBgImageView addSubview:lane2];
    
    //设置底部栏的按钮
    for (int i = 0; i < self.vcArray.count; i++) {
        if (i<9) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame  = CGRectMake(0, i*((screenHeight-64)/self.photoArray.count), 64, (screenHeight-64)/self.photoArray.count);
            button.tag = 10+i;
            
            if (button.tag == 10) {
                self.tagString = 10;
                button.selected = YES;
                self.currentSelectedButton = button;
                button.backgroundColor=tabarColor;
                [self.giveView setImage:[UIImage imageNamed:@"common_header_logo"]];
                //by kevin
                [self changeLoginNameAndDonationUI];
                
            }
            
            [button addTarget:self action:@selector(vcChangeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.tabBarBgImageView addSubview:button];

            [self setButton:button Image:self.photoArray[i] ImageS:self.selectedPhotoArray[i] AndTitle:[self.titleArray objectAtIndex:i]];
        }
    }
}


-(void)setButton:(UIButton *)but Image:(NSString *)photo ImageS:(NSString *)Sphoto AndTitle:(NSString *)text
{
    UIImageView * image=[[UIImageView alloc] initWithFrame:CGRectMake((64-45)/2, (but.frame.size.height-75)/2, 45, 45)];
    image.tag=20000;
    
    UILabel * title=[[UILabel alloc] initWithFrame:CGRectMake(0, image.frame.size.height+image.frame.origin.y-10, 64, 40)];
    title.numberOfLines=0;
    title.tag=20001;
    title.text=text;
    title.textAlignment=NSTextAlignmentCenter;
    title.font=[UIFont systemFontOfSize:13.5];
    if (but.selected) {
        title.textColor=[UIColor whiteColor];
        image.image=[UIImage imageNamed:Sphoto];
    }
    else
    {
        title.textColor=[UIColor grayColor];
        image.image=[UIImage imageNamed:photo];
    }
    
    [but addSubview:image];
    [but addSubview:title];
    
    if (but.tag==12) {
        self.myLabel=[[UILabel alloc] init];
        self.myLabel.frame=CGRectMake(but.frame.size.width-30, 20, 20, 20);
        self.myLabel.textAlignment=NSTextAlignmentCenter;
        self.myLabel.layer.masksToBounds=YES;
        self.myLabel.layer.cornerRadius =10;
        self.myLabel.font=[UIFont systemFontOfSize:13];
        [but addSubview:self.myLabel];
        self.myLabel.backgroundColor=tabarColor;
        self.myLabel.textColor=[UIColor whiteColor];
    }
}

-(void)newsInformation:(NSNotification *)notification
{
    self.myLabel.text=notification.userInfo[@"news"];
    if ([notification.userInfo[@"news"] intValue]==0) {
        self.myLabel.backgroundColor=[UIColor clearColor];
        self.myLabel.textColor=[UIColor clearColor];
    }
    
    if (self.tagString==12) {
        if ([notification.userInfo[@"index"] integerValue]>0) {
            self.titleLabel.text=[NSString stringWithFormat:@"%@(%lu)",[HKLocalizedString(@"MenuView_MessageCenter_title") stringByReplacingOccurrencesOfString:@"\n" withString:@" "],[notification.userInfo[@"index"] integerValue]];
        }
        else{
            self.titleLabel.text=[HKLocalizedString(@"MenuView_MessageCenter_title") stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        }
    }
}

#pragma mark - 响应点击button切换视图事件
-(void)vcChangeButtonClick:(UIButton *)button{
    DLOG(@"tagString:%d",self.tagString);
    self.currentSelectedButton.selected = NO;
    self.currentSelectedButton.backgroundColor = [UIColor clearColor];/////

    if (button.tag == 17) {//分享
        
        if (self.tagString != 17) {
            [[NSUserDefaults standardUserDefaults] setInteger:self.tagString forKey:@"beforeButtonTag_kevin"];
            self.tagString=(int)button.tag;
            
            button.selected = YES;
            self.currentSelectedButton = button;
            button.backgroundColor=tabarColor;
            
            [self showShareVC];
            
            [self setImageAndTitle:7];
        }
        return;
    }
    else if (button.tag == 18) {//设置
        
        if (self.tagString != 17) {
            [[NSUserDefaults standardUserDefaults] setInteger:self.tagString forKey:@"beforeButtonTag_kevin"];
            self.tagString=(int)button.tag;
            
            button.selected = YES;
            self.currentSelectedButton = button;
            button.backgroundColor=tabarColor;
            
            [self showSettingVC];

            [self setImageAndTitle:8];
        }
        return;
    }
    [[NSUserDefaults standardUserDefaults] setInteger:button.tag forKey:@"beforeButtonTag_kevin"];
    BOOL showSettingVC = [[[NSUserDefaults standardUserDefaults] objectForKey:@"showSettingVC_kevin"] boolValue];
    BOOL showShareVC = [[[NSUserDefaults standardUserDefaults] objectForKey:@"showShareVC_kevin"] boolValue];
    
    if (self.mylang!=[Language getLanguage]) {
        if ((!showSettingVC||!showShareVC)&&(self.tagString!=17)) {
            //先把当前的vc释放掉
            [self.currentViewController.view removeFromSuperview];
            [self.currentViewController removeFromParentViewController];
        }
    }
    else
    {
        if ((!showSettingVC||!showShareVC)&&(self.tagString!=17)&&(self.tagString!=18)) {
            //先把当前的vc释放掉
            [self.currentViewController.view removeFromSuperview];
            [self.currentViewController removeFromParentViewController];
        }
    }
   
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"showShareVC_kevin"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"showSettingVC_kevin"];
    self.memberButton.hidden = NO;//by kevin
    
    for (int i = 0; i < self.vcArray.count; i++) {
        if (i<9) {
            UIButton * butto=(UIButton *)[self.tabBarBgImageView viewWithTag:10+i];
            UIImageView * image=(UIImageView *)[butto viewWithTag:20000];
            UILabel * label=(UILabel *)[butto viewWithTag:20001];
            if (i+10 == button.tag) {
                label.textColor=[UIColor whiteColor];
                image.image=[UIImage imageNamed:self.selectedPhotoArray[i]];
                if (self.mylang!=[Language getLanguage]) {
                    if ((!showSettingVC||!showShareVC)&&(self.tagString!=17)) {
                        UIViewController *fVC = [[[self.vcArray objectAtIndex:i]alloc]init];
                        fVC.view.frame = CGRectMake(64, 64, screenWidth-64, self.view.frame.size.height-64);
                        //将fVC设置为当前控制器
                        self.currentViewController = fVC;
                        [self.view addSubview:fVC.view];
                        [self addChildViewController:fVC];
                    }
                    
                    if (i==4&&self.tagString!=17) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"clickChari" object:nil];
                    }
                    
                    //self.mylang=[Language getLanguage];
                }
                else
                {
                    if ((!showSettingVC||!showShareVC)&&(self.tagString!=17)&&(self.tagString!=18)) {
                        UIViewController *fVC = [[[self.vcArray objectAtIndex:i]alloc]init];
                        fVC.view.frame = CGRectMake(64, 64, screenWidth-64, self.view.frame.size.height-64);
                        //将fVC设置为当前控制器
                        self.currentViewController = fVC;
                        [self.view addSubview:fVC.view];
                        [self addChildViewController:fVC];
                    }
                    
                    if (i==4&&self.tagString!=17&&self.tagString!=18) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"clickChari" object:nil];
                    }
                }
                
                button.selected = YES;
                self.currentSelectedButton = button;
                button.backgroundColor=tabarColor;
                //[self.giveView setImage:[UIImage imageNamed:@"header_logo"]];
                if (i==1) {
                    if (![EGLoginTool loginSingleton].isLoggedIn) {
                        EGLoginViewController* vc = [[EGLoginViewController alloc]init];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                }
                if (i==0) {
                    [self.giveView setImage:[UIImage imageNamed:@"common_header_logo"]];
                    self.titleLabel.text=@"";
                    [self.leftButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                }
                else
                {
                    [self.giveView setImage:[UIImage imageNamed:@""]];
                    //self.titleLabel.text=self.titleArray[i];
                    self.titleLabel.text = [self.titleArray[i] stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
                    [self.leftButton setImage:[UIImage imageNamed:@"common_header_logo"] forState:UIControlStateNormal];
                }
                self.tagString=(int)button.tag;
                
                if (!([self.charityString isEqualToString:@"charity"]&&(i==4)&&(self.mylang==[Language getLanguage]))) {
                    //by kevin
                    [self changeLoginNameAndDonationUI];
                    self.mylang=[Language getLanguage];
                }
            }
            else
            {
                label.textColor=[UIColor grayColor];
                image.image=[UIImage imageNamed:self.photoArray[i]];
            }
            if (self.tagString==12) {
                self.myLabel.backgroundColor=[UIColor whiteColor];
                self.myLabel.textColor=tabarColor;
                if (self.myArray.count>0) {
                    self.titleLabel.text=[NSString stringWithFormat:@"%@(%lu)",[HKLocalizedString(@"MenuView_MessageCenter_title") stringByReplacingOccurrencesOfString:@"\n" withString:@" "],self.myArray.count];
                }
                else{
                    self.titleLabel.text=[HKLocalizedString(@"MenuView_MessageCenter_title") stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
                }
            }
            else{
                if ([self.myLabel.text isEqualToString:@"0"]) {
                    self.myLabel.backgroundColor=[UIColor clearColor];
                    self.myLabel.textColor=[UIColor clearColor];
                }
                else{
                    self.myLabel.backgroundColor=tabarColor;
                    self.myLabel.textColor=[UIColor whiteColor];
                }
            }
        }
    }
}
#pragma mark - by kevin 分享+设置
//分享
-(void)showShareVC{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"showShareVC_kevin"];
    
    NSString * content = @"";
    NSString * subject = @"";
    NSString * lang = @"";
    if ([Language getLanguage]==1) {

        lang = @"?lang=1";
        NSString *string = [NSString stringWithFormat:@"Egive 意贈「嶄新慈善募捐平台」\n善心體現「網絡相連．善心相傳」\n\n官方網頁\n%@\n\n手機應用程式\nhttp://www.egive4u.org/mobileappinstall.html\n\n意贈慈善基金\nEgive For You Charity Foundation\n電話: (852) 2210 2600\n電郵: info@egive4u.org",[SITE_URL stringByAppendingString:lang]];
        content = string;
        subject = @"Egive 意贈「嶄新慈善募捐平台」";
        
        
    }else if ([Language getLanguage] ==2){

        lang = @"?lang=2";
        NSString *string = [NSString stringWithFormat:@"Egive 意赠「崭新慈善募捐平台」\n善心体现「网络相连．善心相传」\n\n官方网页\n%@\n\n手机应用程序\nhttp://www.egive4u.org/mobileappinstall.html\n\n意赠慈善基金\nEgive For You Charity Foundation\n电话: (852) 2210 2600\n电邮: info@egive4u.org",[SITE_URL stringByAppendingString:lang]];
        content = string;
        subject = @"Egive 意赠「崭新慈善募捐平台」";
        
        
    }else{
        lang = @"?lang=3";
        NSString *string = [NSString stringWithFormat:@"Egive - O2O Charity Platform.\n\"Be Link Up Net with Love\"\n\nOfficial Website:\n%@\n\nMobile App:\nhttp://www.egive4u.org/mobileappinstall.html\n\nEgive For You Charity Foundation\nTel: (852) 2210 2600\nEmail: info@egive4u.org",[SITE_URL stringByAppendingString:lang]];
        content = string;
        subject = @"Egive - O2O Charity Platform";
        
    }

    EGShareViewController * shareVC= [[EGShareViewController alloc]initWithSubject:subject content:content url:[SITE_URL stringByAppendingString:lang] image:nil Block:^(id result) {
        //popview dismaiss
         [self reloadTabarUI];
    }];
    [shareVC showShareUIWithPoint:CGPointMake(0, self.currentSelectedButton.center.y) view:self.currentViewController.view permittedArrowDirections:UIPopoverArrowDirectionLeft];
}
//设置
-(void)showSettingVC{
    
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    [myDelegate setMyTabarViewController:self];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"showSettingVC_kevin"];
    
    CGSize size = CGSizeMake(WIDTH/2.5, HEIGHT/4*3);//(410, 570)
    SettingViewController *root = [[SettingViewController alloc]init];
    root.size = size;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:root];
    navigationController.preferredContentSize = size; //内容大小
    _popover = [[UIPopoverController alloc] initWithContentViewController:navigationController];
    _popover.delegate = self;

    // 在view这个视图point点，在0＊0区域显示这个Popover
    [_popover presentPopoverFromRect:CGRectMake(0, self.currentSelectedButton.center.y, 5, 1) inView:self.currentViewController.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
}

#pragma mark -popoverController消失的时候调用
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    [self reloadTabarUI];
}

-(void)reloadTabarUI{
    if (self.tagString==17||self.tagString==18) {
        UIButton* btn = (UIButton *)[self.tabBarBgImageView viewWithTag:self.tagString];
        btn.enabled = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            btn.enabled=YES;
        });
        
        int tag = [[[NSUserDefaults standardUserDefaults] objectForKey:@"beforeButtonTag_kevin"] intValue];
        [self refreshVCViewByTag:tag];
//        if (tag==10||tag==0) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshCellData" object:nil];
//        }
        if (tag >= 19) {
            self.tagString = tag;
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"showSettingVC_kevin"];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"showShareVC_kevin"];
            
            self.currentSelectedButton.selected = NO;
            self.currentSelectedButton.backgroundColor = [UIColor clearColor];
            if (tag == 19) {
                self.titleLabel.text=HKLocalizedString(@"会员专区");
                [self setImageAndTitle:9];
                
            }else if (tag == 20){
                self.titleLabel.text=HKLocalizedString(@"意赠之友登记表格");
                [self setImageAndTitle:10];
            }else{
                self.titleLabel.text=@"";
            }
        }
    }
}

-(void)clickCartAddCase
{
    UIButton * button=(UIButton *)[self.tabBarBgImageView viewWithTag:14];
    [self.currentViewController.view removeFromSuperview];
    [self.currentViewController removeFromParentViewController];
    self.currentSelectedButton.selected = NO;
    self.currentSelectedButton.backgroundColor = [UIColor clearColor];/////
    EGClickCharityViewController * EGCCC=[[EGClickCharityViewController alloc] init];
    EGCCC.view.frame = CGRectMake(64, 64, screenWidth-64, self.view.frame.size.height-64);
    self.currentViewController = EGCCC;
    [self.view addSubview:EGCCC.view];
    [self addChildViewController:EGCCC];
    button.selected = YES;
    self.currentSelectedButton = button;
    button.backgroundColor=tabarColor;
    [self setImageAndTitle:4];
    
    [self.giveView setImage:[UIImage imageNamed:@""]];
    //self.titleLabel.text=self.titleArray[4];
    self.titleLabel.text = [self.titleArray[4] stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    [self.leftButton setImage:[UIImage imageNamed:@"common_header_logo"] forState:UIControlStateNormal];
    
    NSDictionary * dic=@{@"CaseID":@"",
                         @"MemberID":@""};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddCase" object:nil userInfo:@{@"index" :dic}];
}

#pragma mark - VCgoVC信息中心
-(void)goGiveInformation:(NSNotification *)notification
{
    UIButton * button=(UIButton *)[self.tabBarBgImageView viewWithTag:16];
    [self.currentViewController.view removeFromSuperview];
    [self.currentViewController removeFromParentViewController];
    self.currentSelectedButton.selected = NO;
    self.currentSelectedButton.backgroundColor = [UIColor clearColor];/////
    EGGiveInformationViewController * EGCCC=[[EGGiveInformationViewController alloc] init];
    EGCCC.view.frame = CGRectMake(64, 64, screenWidth-64, self.view.frame.size.height-64);
    self.currentViewController = EGCCC;
    [self.view addSubview:EGCCC.view];
    [self addChildViewController:EGCCC];
    button.selected = YES;
    self.currentSelectedButton = button;
    button.backgroundColor=tabarColor;
    [self setImageAndTitle:6];
    self.tagString=16;
    
    [self.giveView setImage:[UIImage imageNamed:@""]];
    self.titleLabel.text=self.titleArray[6];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"informationDetail" object:nil userInfo:@{@"index" :notification.userInfo[@"index"]}];
    
    self.myLabel.backgroundColor=tabarColor;
    self.myLabel.textColor=[UIColor whiteColor];
}

#pragma mark - VCgoVC点击行善
-(void)VCgoVC:(NSNotification *)notification
{
    UIButton * button=(UIButton *)[self.tabBarBgImageView viewWithTag:14];
    [self.currentViewController.view removeFromSuperview];
    [self.currentViewController removeFromParentViewController];
    self.currentSelectedButton.selected = NO;
    self.currentSelectedButton.backgroundColor = [UIColor clearColor];/////
    EGClickCharityViewController * EGCCC=[[EGClickCharityViewController alloc] init];
    EGCCC.view.frame = CGRectMake(64, 64, screenWidth-64, self.view.frame.size.height-64);
    self.currentViewController = EGCCC;
    [self.view addSubview:EGCCC.view];
    [self addChildViewController:EGCCC];
    button.selected = YES;
    self.currentSelectedButton = button;
    button.backgroundColor=tabarColor;
    [self setImageAndTitle:4];
    self.tagString=14;
    
    [self.giveView setImage:[UIImage imageNamed:@""]];
    //self.titleLabel.text=self.titleArray[4];
    self.titleLabel.text = [self.titleArray[4]stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    [self.leftButton setImage:[UIImage imageNamed:@"common_header_logo"] forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Detail" object:nil userInfo:@{@"index" :notification.userInfo[@"index"]}];
}

-(void)lastView
{
    UIButton * button=(UIButton *)[self.tabBarBgImageView viewWithTag:14];
    [self.currentViewController.view removeFromSuperview];
    [self.currentViewController removeFromParentViewController];
    self.currentSelectedButton.selected = NO;
    self.currentSelectedButton.backgroundColor = [UIColor clearColor];/////
    EGClickCharityViewController * EGCCC=[[EGClickCharityViewController alloc] init];
    EGCCC.view.frame = CGRectMake(64, 64, screenWidth-64, self.view.frame.size.height-64);
    self.currentViewController = EGCCC;
    [self.view addSubview:EGCCC.view];
    [self addChildViewController:EGCCC];
    button.selected = YES;
    self.currentSelectedButton = button;
    button.backgroundColor=tabarColor;
    [self setImageAndTitle:4];
    self.tagString=14;
    [self.giveView setImage:[UIImage imageNamed:@""]];
    //self.titleLabel.text=self.titleArray[4];
    self.titleLabel.text = [self.titleArray[4] stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    [self.leftButton setImage:[UIImage imageNamed:@"common_header_logo"] forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"clickChari" object:nil];
}

-(void)GoToKindnessRanking
{
    UIButton * button=(UIButton *)[self.tabBarBgImageView viewWithTag:15];
    [self.currentViewController.view removeFromSuperview];
    [self.currentViewController removeFromParentViewController];
    self.currentSelectedButton.selected = NO;
    self.currentSelectedButton.backgroundColor = [UIColor clearColor];
    EGKindnessRankingViewController * EGCCC=[[EGKindnessRankingViewController alloc] init];
    EGCCC.view.frame = CGRectMake(64, 64, screenWidth-64, self.view.frame.size.height-64);
    self.currentViewController = EGCCC;
    [self.view addSubview:EGCCC.view];
    [self addChildViewController:EGCCC];
    button.selected = YES;
    self.currentSelectedButton = button;
    button.backgroundColor=tabarColor;
    [self setImageAndTitle:5];
    
    [self.giveView setImage:[UIImage imageNamed:@""]];
    self.titleLabel.text = [self.titleArray[5] stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    [self.leftButton setImage:[UIImage imageNamed:@"common_header_logo"] forState:UIControlStateNormal];
    self.memberButton.hidden = NO;
}

-(void)scrollTitleView:(NSNotification *)notification
{
    UIButton * button=(UIButton *)[self.tabBarBgImageView viewWithTag:14];
    [self.currentViewController.view removeFromSuperview];
    [self.currentViewController removeFromParentViewController];
    self.currentSelectedButton.selected = NO;
    self.currentSelectedButton.backgroundColor = [UIColor clearColor];/////
    EGClickCharityViewController * EGCCC=[[EGClickCharityViewController alloc] init];
    EGCCC.view.frame = CGRectMake(64, 64, screenWidth-64, self.view.frame.size.height-64);
    self.currentViewController = EGCCC;
    [self.view addSubview:EGCCC.view];
    [self addChildViewController:EGCCC];
    button.selected = YES;
    self.currentSelectedButton = button;
    button.backgroundColor=tabarColor;
    [self setImageAndTitle:4];
    self.tagString=14;
    [self.giveView setImage:[UIImage imageNamed:@""]];
    self.titleLabel.text = [self.titleArray[4] stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    [self.leftButton setImage:[UIImage imageNamed:@"common_header_logo"] forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollTitleView" object:nil userInfo:@{@"index" :notification.userInfo[@"index"]}];
    
    self.myLabel.backgroundColor=tabarColor;
    self.myLabel.textColor=[UIColor whiteColor];
}

-(void)setImageAndTitle:(int)index
{
    for (int i = 0; i < self.vcArray.count; i++) {
        if (i<9) {
            UIButton * butto=(UIButton *)[self.tabBarBgImageView viewWithTag:10+i];
            UIImageView * image=(UIImageView *)[butto viewWithTag:20000];
            UILabel * label=(UILabel *)[butto viewWithTag:20001];
            label.textColor=[UIColor grayColor];
            if (index<9&&i==index) {
                label.textColor=[UIColor whiteColor];
                image.image=[UIImage imageNamed:self.selectedPhotoArray[i]];
            }
            else
            {
                image.image=[UIImage imageNamed:self.photoArray[i]];
            }
        }
    }
}

-(void)DonationRecord:(NSNotification *)notification
{
    EGMyDonationViewController *root = [[EGMyDonationViewController alloc] initWithNibName:@"EGMyDonationViewController" bundle:nil];
    CGSize size = CGSizeMake(WIDTH-200, HEIGHT-100);
    [root setContentSize:size  bgAction:NO animated:NO];
    root.showType=1;
    root.caseId=[notification.userInfo[@"index"] objectForKey:@"CaseID"];
    
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:root];
    navigationController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:navigationController animated:YES completion:nil];
}

-(void)progressReport:(NSNotification *)notification
{
    [self requestXQData:[notification.userInfo[@"index"] objectForKey:@"CaseID"] andMemberID:[notification.userInfo[@"index"] objectForKey:@"MemberID"]];
}

-(void)setProReport
{
    EGProReportController * ProReport = [[EGProReportController alloc] init];
    CGSize size = CGSizeMake(screenWidth-400, screenHeight-50);
    [ProReport setContentSize:size  bgAction:NO animated:NO];
    ProReport.dataArray=self.model.UpdatesDetail;
    ProReport.nameString=self.model.Title;
    ProReport.caseId=self.model.CaseID;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:ProReport];
    navigationController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:navigationController animated:YES completion:nil];
}

-(void)clickCharityYesShare
{
    self.shareIndex=14;
    [self changeLoginNameAndDonationUI];
}

-(void)clickCharityNoShare
{
    self.shareIndex=10;
    [self changeLoginNameAndDonationUI];
}

-(void)clickCharityToNoShare
{
    self.shareIndex=10;
}

#pragma mark - 更新信息中心消息数量
-(void)UpdateNewsVolume:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UpdateNewsVolume" object:nil];
    [self loadData:@""];
}

-(void)Support:(NSNotification *)notification
{
    UIButton * button=(UIButton *)[self.tabBarBgImageView viewWithTag:12];
    [self.currentViewController.view removeFromSuperview];
    [self.currentViewController removeFromParentViewController];
    self.currentSelectedButton.selected = NO;
    self.currentSelectedButton.backgroundColor = [UIColor clearColor];/////
    EGMessageController * EGCCC=[[EGMessageController alloc] init];
    EGCCC.view.frame = CGRectMake(64, 64, screenWidth-64, self.view.frame.size.height-64);
    self.currentViewController = EGCCC;
    [self.view addSubview:EGCCC.view];
    [self addChildViewController:EGCCC];
    button.selected = YES;
    self.currentSelectedButton = button;
    button.backgroundColor=tabarColor;
    [self setImageAndTitle:2];
    self.tagString=12;
    
    [self.giveView setImage:[UIImage imageNamed:@""]];
    if (self.myArray.count>0) {
        self.titleLabel.text=[NSString stringWithFormat:@"%@(%lu)",[HKLocalizedString(@"MenuView_MessageCenter_title") stringByReplacingOccurrencesOfString:@"\n" withString:@" "],self.myArray.count+1];
    }
    
    self.myLabel.backgroundColor=tabarColor;
    self.myLabel.textColor=[UIColor whiteColor];
}

#pragma mark - 请求消息数据
-(void)loadData:(NSString *)MsgTp
{
    self.myArray=[[NSMutableArray alloc] init];
    LanguageKey lang = [Language getLanguage];
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppToken_Dict"];
    NSString *token =  dict[@"AppToken"];
    NSString * soapMessage =
    [NSString stringWithFormat:
     @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
     "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
     "<soap:Body>"
     "<GetMailBoxMsg xmlns=\"egive.appservices\">"
     "<Lang>%ld</Lang>"
     "<AppToken>%@</AppToken>"
     "<MsgTp>%@</MsgTp>"
     "<maxOccurs>30</maxOccurs>"
     "<minOccurs>0</minOccurs>"
     "</GetMailBoxMsg>"
     "</soap:Body>"
     "</soap:Envelope>",lang,token,MsgTp
     ];
    
    [EGHomeModel postWithSoapMsg:soapMessage success:^(id responseObj) {
        self.myArray=[responseObj objectForKey:@"MsgList"];
        if (self.myArray) {
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            NSArray * arr=[user objectForKey:@"HaveReadID"];
            if (((int)(self.myArray.count)-(int)(arr.count))>0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NEWNotification" object:nil userInfo:@{@"news" : [NSString stringWithFormat:@"%lu",self.myArray.count-arr.count]}];
            }
            else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NEWNotification" object:nil userInfo:@{@"news" : [NSString stringWithFormat:@"%d",0]}];
            }
        }
        
    } failure:^(NSError *error) {
    }];
}

#pragma mark - 请求进度报告数据
-(void)requestXQData:(NSString *)caseID andMemberID:(NSString *)memberID{
    LanguageKey lang = [Language getLanguage];
    NSString * soapMessage =
    [NSString stringWithFormat:
     @"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><GetCaseDtl xmlns=\"egive.appservices\"><Lang>%ld</Lang><CaseID>%@</CaseID><MemberID>%@</MemberID></GetCaseDtl></soap:Body></soap:Envelope>",lang,caseID,memberID];
    //DLOG(@"lang==%ld\ncaseID==%@\nmemberID==%@",lang,caseID,memberID);
    [EGHomeModel postClickCharitytWithParams:soapMessage block:^(NSDictionary *data, NSError *error) {
        if (data.count>0) {
            self.model = [[EGClickCharityModel alloc] init];
            [self.model setValuesForKeysWithDictionary:data];
            
            [self setProReport];
        }
    }];
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
