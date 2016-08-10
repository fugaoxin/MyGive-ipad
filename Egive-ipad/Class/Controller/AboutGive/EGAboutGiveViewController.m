//
//  EGAboutGiveViewController.m
//  Egive-ipad
//
//  Created by User01 on 15/11/19.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGAboutGiveViewController.h"
#import "EGAboutGiveCell.h"
#import "EGHomeModel.h"
#import "TFHpple.h"
#import "EGFAQPageController.h"
#import "EGAboutUsPageController.h"
#import "EGChairmanPageController.h"

@interface EGAboutGiveViewController ()<UITableViewDelegate,UITableViewDataSource,EGChairmanPageDelegate,EGAboutUsPageDelegate>

@property (nonatomic,strong) UITableView * ABtableView;
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) NSArray * titleArray;
@property (nonatomic,strong) NSArray * imageArray;
@property (nonatomic,strong) NSArray * imagebgArray;
@property (nonatomic,strong) NSDictionary * dataDic;//数据
@property (nonatomic,assign) int cellIndex;//记录点击cell
@property (nonatomic,strong) NSString * AboutImage;
@property (nonatomic,strong) NSString * ChairmanImage;

@end

@implementation EGAboutGiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setModel];
    [self SetTableView];
}

#pragma mark - 初始化储存器
-(void)setModel
{
    self.dataDic=[[NSDictionary alloc] init];
    self.titleArray=@[HKLocalizedString(@"AboutGird_label_title1"),
                      HKLocalizedString(@"AboutGird_label_title2"),
                      HKLocalizedString(@"AboutGird_label_title3"),
                      HKLocalizedString(@"AboutGird_label_title4"),
                      HKLocalizedString(@"AboutGird_label_title5"),
                      HKLocalizedString(@"AboutGird_label_title6"),];
    self.imagebgArray=@[@"about_us_idea_bg",
                      @"about_us_speech_bg",
                      @"about_us_structure_bg",
                      @"about_us_sponsor_bg",
                      @"about_us_method_bg",
                      @"about_us_q_a_bg"];
    self.imageArray=@[@"about_us_idea",
                      @"about_us_speech",
                      @"about_us_structure",
                      @"about_us_sponsor",
                      @"about_us_method",
                      @"about_us_q_a"];
}

-(void)loadData:(NSString *)formID
{
    [SVProgressHUD show];
    LanguageKey lang = [Language getLanguage];
    NSString * soapMessage =
    [NSString stringWithFormat:
     @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
     "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
     "<soap:Body>"
     "<GetStaticPageContent xmlns=\"egive.appservices\">"
     "<Lang>%ld</Lang>"
     "<FormID>%@</FormID>"
     "</GetStaticPageContent>"
     "</soap:Body>"
     "</soap:Envelope>",lang,formID
     ];
    
    [EGHomeModel postWithSoapMsg:soapMessage success:^(id responseObj) {
        //DLOG(@"responseObj==%@",responseObj);
        [SVProgressHUD dismiss];
        self.dataDic=responseObj;
        if ([formID isEqualToString:@"AboutUs"]) {
            EGAboutUsPageController * abu=[[EGAboutUsPageController alloc] init];//0
            abu.delegate=self;
            abu.ContentText=[self.dataDic objectForKey:@"ContentText"];
            [self addChildViewController:abu];
            abu.view.frame = CGRectMake(screenWidth/3, 0, screenWidth-screenWidth/3, screenHeight-64);
            abu.view.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:abu.view];
        }
        else if ([formID isEqualToString:@"Chairman"]){
            EGChairmanPageController * cha=[[EGChairmanPageController alloc] init];//1
            cha.delegate=self;
            cha.ContentText=[self.dataDic objectForKey:@"ContentText"];
            [self addChildViewController:cha];
            cha.view.frame = CGRectMake(screenWidth/3, 0, screenWidth-screenWidth/3, screenHeight-64);
            cha.view.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:cha.view];
        }
        else{
            EGFAQPageController * ega=[[EGFAQPageController alloc] init];//2345
            ega.ContentText=[self.dataDic objectForKey:@"ContentText"];
            //ega.ContentText=@"";
            [self addChildViewController:ega];
            ega.view.frame = CGRectMake(screenWidth/3, 0, screenWidth-screenWidth/3, screenHeight-64);
            ega.view.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:ega.view];
        }
        
        if ([formID isEqualToString:@"Public_HowToJoin"]) {
            [self clickLastShare:formID];
        }
        else
        {
            [self clickShare:formID];
        }

    } failure:^(NSError *error) {
        
        
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


#pragma mark - 左边TableView
-(void)SetTableView
{
    self.ABtableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth/3, screenHeight-64) style:UITableViewStylePlain];
    self.ABtableView.delegate=self;
    self.ABtableView.dataSource=self;
    self.ABtableView.separatorStyle = NO;
    [self.view addSubview:self.ABtableView];
    [self loadData:@"AboutUs"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * str=@"cell";
    EGAboutGiveCell * cell=[tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        cell=[[EGAboutGiveCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    if (self.cellIndex==indexPath.row) {
        cell.FImageView.hidden=NO;
        [cell setTitle:self.titleArray[indexPath.row] andImage:self.imageArray[indexPath.row]];
        cell.backgroundColor=[UIColor colorWithRed:233/255.0 green:234/255.0 blue:236/255.0 alpha:1];
        //[UIColor colorWithRed:233/255.0 green:234/255.0 blue:236/255.0 alpha:1];
    }
    else
    {
        cell.FImageView.hidden=YES;
        [cell setTitle:self.titleArray[indexPath.row] andImage:self.imagebgArray[indexPath.row]];
        cell.backgroundColor=[UIColor clearColor];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"indexPath.row==%lu",indexPath.row);
    self.cellIndex=(int)indexPath.row;
    [self.ABtableView reloadData];
    
    switch (indexPath.row) {
        case 0:
            [self loadData:@"AboutUs"];
            break;
        case 1:
            [self loadData:@"Chairman"];
            break;
        case 2:
            [self loadData:@"Public_OrganizationStructure"];
            break;
        case 3:
            [self loadData:@"Public_Egiver"];
            break;
        case 4:
            [self loadData:@"Public_DonationFlow"];
            break;
        case 5:
            [self loadData:@"Public_HowToJoin"];
            break;
        default:
            break;
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AboutUs" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Chairman" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Public_OrganizationStructure" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Public_Egiver" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Public_DonationFlow" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Public_HowToJoin" object:nil];
}

#pragma mark - 分享内容
-(void)clickShare:(NSString *)name
{//意赠使命、主席的話、愛心贊助
    LanguageKey lang = [Language getLanguage];
    NSString * string = @"";
    NSString * subject = @"";
    if (lang==1) {
        NSString * content=@"Egive 意贈慈善基金由一群熱心公益的社會賢達創辦，旨在團結個人力量，以生命影響生命的方法，透過互聯網募捐平台不分地域、文化、族裔和語言，將受惠者、捐款者及公眾緊密連繫起來，宣揚關懷互愛的訊息，共建關懷互助的社群，以達致「網絡相連．善心相傳」之效。";
        
        NSString *str = [NSString stringWithFormat:@"%@\n\n請瀏覽: %@?lang=%lu\n\n意贈慈善基金\nEgive For You Charity Foundation\n電話: (852) 2210 2600\n電郵: info@egive4u.org",content,SITE_URL,lang];
        string = str;
        subject = [NSString stringWithFormat:@"Egive 意贈慈善基金"];
        
    }else if (lang==2){
        NSString * content=@"Egive 意赠慈善基金由一群热心公益的社会贤达创办，旨在团结个人力量，以生命影响生命的方法，透过互联网募捐平台不分地域、文化、族裔和语言，将受惠者、捐款者及公众紧密连系起来，宣扬关怀互爱的讯息，共建关怀互助的社群，以达致「网络相连．善心相传」之效。";
        
        NSString *str = [NSString stringWithFormat:@"%@\n\n请浏览: %@?lang=%lu\n\n意赠慈善基金\nEgive For You Charity Foundation\n电话: (852) 2210 2600\n电邮: info@egive4u.org",content,SITE_URL,lang];
        string = str;
        subject = [NSString stringWithFormat:@"Egive 意赠慈善基金"];
    }else{
        NSString * content=@"Egive For You Charity Foundation was founded by a group of public-spirited community leaders who aim to gather everyone to touch the lives of each other. Through Egive's crowd funding donation platform, beneficiaries, donors and the public across all regions, cultures, races and languages are connected and may share warmth and love with one another to build a closely-knit community.";
        
        NSString * str = [NSString stringWithFormat:@"%@\n\nVisit us at %@?lang=%lu\n\nEgive For You Charity Foundation\nTel: (852) 2210 2600\nEmail: info@egive4u.org",content,SITE_URL,lang];
        string = str;
        subject = [NSString stringWithFormat:@"Egive For You Charity Foundation"];
    }
    NSString * image;
    if ([name isEqualToString:@"AboutUs"]) {
        //DLOG(@"AboutImage==%@",self.AboutImage);
        image=self.AboutImage;
    }
    else if ([name isEqualToString:@"Chairman"])
    {
        image=self.ChairmanImage;
    }
    else
    {
        image=@"dummy_case_related_default";
    }
    //,@"image":image
    NSString * caseTitle;
    if ([name isEqualToString:@"Public_Egiver"]) {
        caseTitle=@"Egiver";
    }
    else
    {
        caseTitle=name;
    }
    NSDictionary * dic=@{@"title":subject,
                         @"content":string,
                         @"lang":[NSString stringWithFormat:@"%lu",lang],
                         @"caseTitle":caseTitle};
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:HKLocalizedString(@"MenuView_aboutButton_title") userInfo:dic];
}

-(void)clickLastShare:(NSString *)name
{//如何參與
    LanguageKey lang = [Language getLanguage];
    NSString * string = @"";
    NSString * subject = @"";
    if (lang==1) {
        NSString * content=[NSString stringWithFormat:@"Egive - 常見問題 %@/FAQ.aspx?lang=%lu",SITE_URL,lang];
        NSString *str = [NSString stringWithFormat:@"%@\n\n請瀏覽: %@?lang=%lu\n\n意贈慈善基金\nEgive For You Charity Foundation\n電話: (852) 2210 2600\n電郵: info@egive4u.org",content,SITE_URL,lang];
        string = str;
        subject = [NSString stringWithFormat:@"Egive - 常見問題"];
        
    }else if (lang==2){
        NSString * content=[NSString stringWithFormat:@"Egive - 常见问题 %@/FAQ.aspx?lang=%lu",SITE_URL,lang];
        NSString *str = [NSString stringWithFormat:@"%@\n\n请浏览: %@?lang=%lu\n\n意赠慈善基金\nEgive For You Charity Foundation\n电话: (852) 2210 2600\n电邮: info@egive4u.org",content,SITE_URL,lang];
        string = str;
        subject = [NSString stringWithFormat:@"Egive - 常见问题"];
    }else{
        NSString * content=[NSString stringWithFormat:@"Egive - FAQ %@/FAQ.aspx?lang=%lu",SITE_URL,lang];
        NSString * str = [NSString stringWithFormat:@"%@\n\nVisit us at %@?lang=%lu\n\nEgive For You Charity Foundation\nTel: (852) 2210 2600\nEmail: info@egive4u.org",content,SITE_URL,lang];
        string = str;
        subject = [NSString stringWithFormat:@"Egive - FAQ"];
    }
    NSDictionary * dic=@{@"title":subject,
                         @"content":string,
                         @"lang":[NSString stringWithFormat:@"%lu",lang],
                         @"caseTitle":@"HowToJoin"};//.aspx
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:HKLocalizedString(@"MenuView_aboutButton_title") userInfo:dic];
}

-(void)obtainImage:(NSString *)image
{
    self.ChairmanImage=[NSString stringWithFormat:@"%@",image];
    [self clickShare:@"Chairman"];
}

-(void)obtainAboutImage:(NSString *)image
{
    self.AboutImage=[NSString stringWithFormat:@"%@",image];
    [self clickShare:@"AboutUs"];
}

@end
