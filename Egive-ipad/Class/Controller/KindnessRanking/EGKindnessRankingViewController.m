//
//  EGKindnessRankingViewController.m
//  Egive-ipad
//
//  Created by User01 on 15/11/19.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGKindnessRankingViewController.h"
#import "CZPickerView.h"
#import <MXSegmentedPager/MXSegmentedPager.h>
#import "EGRankMenuView.h"
#import "EGRankLeftViewCell.h"
#import "EGRankRightViewCell.h"
#import "EGRankRightFirstViewCell.h"
#import "EGLoginTool.h"
#import "EGRankModel.h"
#import "UIAlertView+addtion.h"
#import "UIView+line.h"
#import <MediaPlayer/MediaPlayer.h>
#import "EGShareViewController.h"
#import "EGDonationModel.h"
#import "NSString+Helper.h"
#import "UIImage+addtion.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>

#define kLeftTableViewTag 1
#define kRightTableViewTag 2

@interface EGKindnessRankingViewController ()<MXSegmentedPagerDelegate, MXSegmentedPagerDataSource, UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>{
    NSInteger _currentMenuIndex;
    
    NSInteger _selectedRow;
    
    EGRankMenuView *_menu;
}


@property (nonatomic, strong) MXSegmentedPager  * segmentedPager;

@property (weak, nonatomic) IBOutlet UIView *tableTopView;

@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
//@property (strong, nonatomic)  UITableView *leftTableView;

@property (weak, nonatomic) IBOutlet UITableView *rightTableView;

@property (weak, nonatomic) IBOutlet UILabel *personRankLabel;

@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (weak, nonatomic) IBOutlet UILabel *ranknumLabel;

@property (weak, nonatomic) IBOutlet UILabel *personMoneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *moneynumLabel;

@property (weak, nonatomic) IBOutlet UILabel *endLabel;

@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *rightTopLabel;

@property (weak, nonatomic) IBOutlet UIView *rightTopView;


@property (copy, nonatomic) NSArray *categoryArray;


//排名数据
@property (strong, nonatomic) NSMutableArray *rankArray;

//右边table顶部标题
@property (copy, nonatomic) NSArray *titleArray;


@end

@implementation EGKindnessRankingViewController



#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
   
    
    //
    [self setupUI];
    
    //
    _categoryArray = @[@"AC",@"S_C",@"E_C",@"M_C",@"P_C",@"U_C",@"A_C",@"O_C"]; //post数据参数
    
    
    
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChangeChange) name:@"LanguageChange" object:nil];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    //
    [self getOtherInfo];
    
    //获取个人累积捐款
    [self loadCart];
    
    //
    [self loadData:0];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - private method
-(IBAction)shareClick:(id)sender{
    
    
    EGUserModel *item = [EGLoginTool loginSingleton].currentUser;
    
    NSString * string = @"";
    NSString * subject = @"";
    if (item != nil) {
        
//        NSArray *ranks = [_ranknumLabel.text componentsSeparatedByString:@"/"];
//        NSString *rank = ranks[1];
        NSString *rank = _ranknumLabel.text;
        if ([item.MemberType isEqualToString:@"P" ]) {
            if ([Language getLanguage]==1) {
                NSString *str = [NSString stringWithFormat:@"Egive - 排名榜\n%@支持了Egive的慈善工作, 於%@名列第%@位，你也來支持！\n%@/Ranking.aspx?Tp=AC&lang=%ld\n\n意贈慈善基金\nEgive For You Charity Foundation\n電話: (852) 2210 2600\n電郵:info@egive4u.org",item.LoginName,HKLocalizedString(@"个人累积捐款"),rank,SITE_URL,[Language getLanguage]];
                string = str;
                subject = @"Egive - 排名榜";
            }else if ([Language getLanguage]==2){
                
                NSString *str = [NSString stringWithFormat:@"Egive - 排名榜\n%@支持了Egive的慈善工作, 于%@名列第%@位，你也来支持！\n%@/Ranking.aspx?Tp=AC&lang=%ld \n\n意赠慈善基金\nEgive For You Charity Foundation\n电話: (852) 2210 2600\n电邮: info@egive4u.org",item.LoginName,HKLocalizedString(@"个人累积捐款"),rank,SITE_URL,[Language getLanguage]];
                string = str;
                subject = @"Egive - 排名榜";
            }else{

                
                NSString * str = [NSString stringWithFormat:@"Egive - Top Individual Fundraiser Awards\n%@ just donated to support Egive and ranked %@ at Top Individual Fundraiser Awards, let's support Egive Now!\n%@/Ranking.aspx?Tp=A&lang=%ld C\n\nVisit us at www.egive4u.org\n\nEgive For You Charity Foundation\nTel: (852) 2210 2600\nEmail: info@egive4u.org",item.LoginName,rank,SITE_URL,[Language getLanguage]];
                string = str;
                
                subject = @"Egive - Top Individual Fundraiser Awards";
            }
        }else{
            if ([Language getLanguage]==1) {
                NSString *str = [NSString stringWithFormat:@"Egive - 排名榜\n%@支持了Egive的慈善工作, 於%@名列第%@位，你也來支持！\n%@/Ranking.aspx?Tp=AC&lang=%ld \n\n意贈慈善基金\nEgive For You Charity Foundation\n電話: (852) 2210 2600\n電郵:info@egive4u.org",item.LoginName,HKLocalizedString(@"企业累积捐款"),rank,SITE_URL,[Language getLanguage]];
                string = str;
                subject = @"Egive - 排名榜";
            }else if ([Language getLanguage]==2){
                
                NSString *str = [NSString stringWithFormat:@"Egive - 排名榜\n%@支持了Egive的慈善工作, 于%@名列第%@位，你也来支持！\n%@/Ranking.aspx?Tp=AC&lang=%ld \n\n意赠慈善基金\nEgive For You Charity Foundation\n电話: (852) 2210 2600\n电邮: info@egive4u.org",item.LoginName,HKLocalizedString(@"企业累积捐款"),rank,SITE_URL,[Language getLanguage]];
                string = str;
                subject = @"Egive - 排名榜";
            }else{
                
                NSString * str = [NSString stringWithFormat:@"Egive - Top Corporate Fundraiser Awards\n%@ just donated to support Egive and ranked %@ at Top Corporate Fundraiser Awards, let's support Egive Now!\n%@/Ranking.aspx?Tp=AC&lang=%ld \n\nVisit us at www.egive4u.org\n\nEgive For You Charity Foundation\nTel: (852) 2210 2600\nEmail: info@egive4u.org",item.LoginName,rank,SITE_URL,[Language getLanguage]];
                string = str;
                
                subject = @"Egive - Top Corporate Fundraiser Awards";
            }
        }
        
        
        
        
    }else{
        
        if ([Language getLanguage]==1) {
            NSString *str = [NSString stringWithFormat:@"Egive - 排名榜\n%@/Ranking.aspx?Tp=AC&lang=%ld \n\n意贈慈善基金\nEgive For You Charity Foundation\n電話: (852) 2210 2600\n電郵: info@egive4u.org",SITE_URL,[Language getLanguage]];
            string = str;
            subject = @"Egive - 排名榜";
        }else if ([Language getLanguage]==2){
            NSString *str = [NSString stringWithFormat:@"Egive - 排名榜\n%@/Ranking.aspx?Tp=AC&lang=%ld \n\n意赠慈善基金\nEgive For You Charity Foundation\n电話: (852) 2210 2600\n电邮: info@egive4u.org",SITE_URL,[Language getLanguage]];
            string = str;
            subject = @"Egive - 排名榜";
        }else{
            
            NSString * str = [NSString stringWithFormat:@"Egive - Awards \n%@/Ranking.aspx?Tp=AC&lang=%ld \n\nVisit us at www.egive4u.org\n\nEgive For You Charity Foundation\nTel: (852) 2210 2600\nEmail: info@egive4u.org",SITE_URL,[Language getLanguage]];
            string = str;
            
            subject = @"Egive - Awards";
        }
        
    }
    
    
    
    EGShareViewController * shareVC= [[EGShareViewController alloc] initWithSubject:subject content:string url:[SITE_URL stringByAppendingString:[NSString stringWithFormat:@"Ranking.aspx?Tp=AC&lang=%ld",[Language getLanguage]]] image:nil Block:^(id result) {
        //[self reloadTabarUI];
    }];
    [shareVC showShareUIWithPoint:CGPointMake(self.shareButton.center.x, self.shareButton.center.y+50) view:self.view permittedArrowDirections:UIPopoverArrowDirectionAny];
    
}


-(void)setupUI{

    //
    _tableTopView.backgroundColor = [UIColor colorWithHexString:@"#5CAF21"];
    _rightTopView.backgroundColor = [UIColor colorWithHexString:@"#E9EAEC"];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#E9EAEC"];
    _rightTopLabel.font = [UIFont boldSystemFontOfSize:16];
    _rightTopLabel.textColor = [UIColor colorWithHexString:@"#673291"];
    _personRankLabel.textColor = [UIColor colorWithHexString:@"#C5E2B5"];
    _personMoneyLabel.textColor = [UIColor colorWithHexString:@"#C5E2B5"];
    _endTimeLabel.textColor = [UIColor colorWithHexString:@"#C5E2B5"];
    self.endLabel.textColor = [UIColor colorWithHexString:@"#C5E2B5"];
    
    //
    [self refreshUI:_currentMenuIndex];
    
    
    //
    self.rightTableView.emptyDataSetSource = self;
    self.rightTableView.emptyDataSetDelegate = self;
    
    
    
    //
    _leftTableView.tag = kLeftTableViewTag;
    _rightTableView.tag = kRightTableViewTag;


    
    //
//    NSDictionary *head1 = @{@"title":[Language getStringByKey:@"累积最高捐款企业"],@"icon":@"ranking_donate_business_icon",@"normalImage":@"comment_input",@"selectedImage":@"record_line"};
//    NSDictionary *head2 = @{@"title":[Language getStringByKey:@"最热心参与企业"],@"icon":@"ranking_participate_business_icon-1",@"normalImage":@"comment_input",@"selectedImage":@"record_line"};
//    NSDictionary *head3 = @{@"title":[Language getStringByKey:@"每月最高个人捐款"],@"icon":@"ranking_monthly_personal_icon",@"normalImage":@"comment_input",@"selectedImage":@"record_line"};
//    NSDictionary *head4 = @{@"title":[Language getStringByKey:@"累积最高个人捐款"],@"icon":@"ranking_participate_business_icon",@"normalImage":@"comment_input",@"selectedImage":@"record_line"};
//    
//    EGRankMenuView *menu = [[EGRankMenuView alloc] initWithArray:[NSArray arrayWithObjects:head1,head2,head3,head4, nil]];
//    _menu = menu;
//    menu.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:menu];
//    [menu mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.view).offset(0);
//        make.top.equalTo(self.view);
//        make.width.equalTo(self.view);
//        make.height.mas_equalTo(44);
//    }];
//    
//    menu.headClick = ^(NSInteger index){
//        
//        if (_currentMenuIndex==index) {
//            return ;
//        }
//        _currentMenuIndex = index;
//        
//        switch (index) {
//            case 0:
//                _categoryArray = @[@"AC",@"S_C",@"E_C",@"M_C",@"P_C",@"U_C",@"A_C",@"O_C"]; //post数据参数
//                
//                self.personRankLabel.text = HKLocalizedString(@"企业捐款排名");
//                self.personMoneyLabel.text = HKLocalizedString(@"企业累积捐款");;
//                break;
//                
//            case 1:
//                _categoryArray = @[@"AP",@"S",@"E",@"M",@"P",@"U",@"A",@"O"];
//                self.personRankLabel.text = HKLocalizedString(@"企业捐款排名");
//                self.personMoneyLabel.text = HKLocalizedString(@"企业累积捐款");;
//                break;
//                
//            case 2:
//                _categoryArray = @[@"MP",@"S_M",@"E_M",@"M_M",@"P_M",@"U_M",@"A_M",@"O_M"];
//                self.personRankLabel.text = HKLocalizedString(@"个人捐款排名");
//                self.personMoneyLabel.text = HKLocalizedString(@"个人累积捐款");;
//                break;
//                
//            case 3:
//                _categoryArray = @[@"AP",@"S",@"E",@"M",@"P",@"U",@"A",@"O"];
//                self.personRankLabel.text = HKLocalizedString(@"个人捐款排名");
//                self.personMoneyLabel.text = HKLocalizedString(@"个人累积捐款");;
//                break;
//                
//            default:
//                break;
//        }
//        
//        [self loadData:0];
//        
//        [self refreshUI:_currentMenuIndex];
//    };
    
}

-(void)resetMenu{
    
    if (_menu) {
        [_menu removeFromSuperview];
    }
    
    
    //
    NSDictionary *head1 = @{@"title":[Language getStringByKey:@"累积最高捐款企业"],@"icon":@"ranking_donate_business_icon",@"normalImage":@"comment_input",@"selectedImage":@"record_line"};
    NSDictionary *head2 = @{@"title":[Language getStringByKey:@"最热心参与企业"],@"icon":@"ranking_participate_threebusiness_icon",@"normalImage":@"comment_input",@"selectedImage":@"record_line"};
    NSDictionary *head3 = @{@"title":[Language getStringByKey:@"每月最高个人捐款"],@"icon":@"ranking_monthly_personal_icon",@"normalImage":@"comment_input",@"selectedImage":@"record_line"};
    NSDictionary *head4 = @{@"title":[Language getStringByKey:@"累积最高个人捐款"],@"icon":@"ranking_participate_business_icon",@"normalImage":@"comment_input",@"selectedImage":@"record_line"};
    
    
    EGRankMenuView *menu = [[EGRankMenuView alloc] initWithArray:[NSArray arrayWithObjects:head1,head2,head3,head4, nil]];
    [menu scrollToIndex:_currentMenuIndex];
    _menu = menu;
    menu.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:menu];
    [menu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(0);
        make.top.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    
    menu.headClick = ^(NSInteger index){
        
        if (_currentMenuIndex==index) {
            return ;
        }
        _currentMenuIndex = index;
        
       
        
        self.rightTopLabel.text = _titleArray[0];
        
        
        switch (index) {
            case 0:
                _categoryArray = @[@"AC",@"S_C",@"E_C",@"M_C",@"P_C",@"U_C",@"A_C",@"O_C"]; //post数据参数
                
//                self.personRankLabel.text = HKLocalizedString(@"企业捐款排名");
//                self.personMoneyLabel.text = HKLocalizedString(@"企业累积捐款");;
                break;
                
            case 1:
                _categoryArray = @[@"AP",@"S",@"E",@"M",@"P",@"U",@"A",@"O"];
//                self.personRankLabel.text = HKLocalizedString(@"企业捐款排名");
//                self.personMoneyLabel.text = HKLocalizedString(@"企业累积捐款");;
                _rightTopLabel.text = HKLocalizedString(@"最热心参与企业");
                break;
                
            case 2:
                _categoryArray = @[@"MP",@"S_M",@"E_M",@"M_M",@"P_M",@"U_M",@"A_M",@"O_M"];
//                self.personRankLabel.text = HKLocalizedString(@"个人捐款排名");
//                self.personMoneyLabel.text = HKLocalizedString(@"个人累积捐款");;
                break;
                
            case 3:
                _categoryArray = @[@"AP",@"S",@"E",@"M",@"P",@"U",@"A",@"O"];
//                self.personRankLabel.text = HKLocalizedString(@"个人捐款排名");
//                self.personMoneyLabel.text = HKLocalizedString(@"个人累积捐款");;
                break;
                
            default:
                break;
        }
        
        
        if([EGLoginTool loginSingleton].isLoggedIn){
            if ([[EGLoginTool loginSingleton].currentUser.MemberType isEqualToString:@"C"]) {
                self.personRankLabel.text = HKLocalizedString(@"企业捐款排名");
                self.personMoneyLabel.text = HKLocalizedString(@"企业累积捐款");;
            }else{
                self.personRankLabel.text = HKLocalizedString(@"个人捐款排名");
                self.personMoneyLabel.text = HKLocalizedString(@"个人累积捐款");;
            }
        }else{
            self.personRankLabel.text = HKLocalizedString(@"个人捐款排名");
            self.personMoneyLabel.text = HKLocalizedString(@"个人累积捐款");;
        }
        
        _selectedRow = 0;
        
        if (![AFNetworkReachabilityManager sharedManager].isReachable) {
            [self refreshUI:_currentMenuIndex];
        }
        
        //切换时每次选中第一行
        [self loadData:0];
        [_leftTableView reloadData];
//        [_leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
//        [self refreshUI:_currentMenuIndex];
    };
}

#pragma mark 重置国际化文字
-(void)refreshUI:(NSInteger)index{
    
    
    [self resetMenu];
    
   
    
    if(_currentMenuIndex==0){
        _titleArray = @[[Language getStringByKey:@"综合－累积最高捐款企业"],[Language getStringByKey:@"助学－累积最高捐款企业"],[Language getStringByKey:@"安老－累积最高捐款企业"],[Language getStringByKey:@"助医－累积最高捐款企业"],[Language getStringByKey:@"扶贫－累积最高捐款企业"],[Language getStringByKey:@"紧急援助－累积最高捐款企业"],[Language getStringByKey:@"意赠行动－累积最高捐款企业"],[Language getStringByKey:@"其他－累积最高捐款企业"]];
        
    }else if(_currentMenuIndex==1){
    
        _titleArray = @[[Language getStringByKey:@"最热心参与企业"]];
    }else if(_currentMenuIndex==2){
        
        _titleArray = @[[Language getStringByKey:@"综合－每月最高个人捐款"],[Language getStringByKey:@"助学－每月最高个人捐款"],[Language getStringByKey:@"安老－每月最高个人捐款"],[Language getStringByKey:@"助医－每月最高个人捐款"],[Language getStringByKey:@"扶贫－每月最高个人捐款"],[Language getStringByKey:@"紧急援助－每月最高个人捐款"],[Language getStringByKey:@"意赠行动－每月最高个人捐款"],[Language getStringByKey:@"其他－每月最高个人捐款"]];
        
        
       
    }else if(_currentMenuIndex==3){
        
        _titleArray = @[[Language getStringByKey:@"综合－累积最高个人捐款"],[Language getStringByKey:@"助学－累积最高个人捐款"],[Language getStringByKey:@"安老－累积最高个人捐款"],[Language getStringByKey:@"助医－累积最高个人捐款"],[Language getStringByKey:@"扶贫－累积最高个人捐款"], [Language getStringByKey:@"紧急援助－累积最高个人捐款"],[Language getStringByKey:@"意赠行动－累积最高个人捐款"],[Language getStringByKey:@"其他－累积最高个人捐款"]];
        
    
    }
    
    
    if (_currentMenuIndex!=1) {
        self.rightTopLabel.text = _titleArray[_selectedRow];
    }
    
    
    BOOL login = [EGLoginTool loginSingleton].isLoggedIn;
    if (login) {
//        EGUserModel *model = [EGLoginTool loginSingleton].currentUser;
        //DLOG(@"model:%@",model);
        
        self.ranknumLabel.hidden = NO;
        self.moneynumLabel.hidden = NO;
        self.endLabel.hidden = NO;
        self.endTimeLabel.hidden = NO;
        
//        if (model.donationAmount) {
//            self.moneynumLabel.text = [NSString stringWithFormat:@"HK$ %@",model.donationAmount];
//        }else{
//            self.moneynumLabel.text = [NSString stringWithFormat:@"HK$ 0"];
//        }
//        self.moneynumLabel.text = [NSString stringWithFormat:@"HK$ %@",model.donationAmount];
//        self.endLabel.text = HKLocalizedString(@"截至:");
        self.endLabel.text = @"";
        self.endTimeLabel.text = HKLocalizedString(@"截至昨天");
        
        //
//        NSDate *nowDate = [NSDate date];
//        NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
//        
//        NSDate *theDate = [nowDate initWithTimeIntervalSinceNow: -oneDay];
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateFormat:@"yyyy-MM-dd"];
//        NSString *dateStr = [formatter stringFromDate:theDate];
//        //DLOG(@"%@",dateStr);
//        self.endTimeLabel.text = dateStr;
    }else{
        
        self.ranknumLabel.hidden = YES;
        self.moneynumLabel.hidden = YES;
        self.endLabel.hidden = YES;
        self.endTimeLabel.hidden = YES;
    }
    
    
    if([EGLoginTool loginSingleton].isLoggedIn){
        if ([[EGLoginTool loginSingleton].currentUser.MemberType isEqualToString:@"C"]) {
            self.personRankLabel.text = HKLocalizedString(@"企业捐款排名");
            self.personMoneyLabel.text = HKLocalizedString(@"企业累积捐款");;
        }else{
            self.personRankLabel.text = HKLocalizedString(@"个人捐款排名");
            self.personMoneyLabel.text = HKLocalizedString(@"个人累积捐款");;
        }
    }else{
        self.personRankLabel.text = HKLocalizedString(@"个人捐款排名");
        self.personMoneyLabel.text = HKLocalizedString(@"个人累积捐款");;
    }
}

#pragma mark 获取排名等其他信息
-(void)getOtherInfo{
    
    BOOL login = [EGLoginTool loginSingleton].isLoggedIn;
    if (!login) {
        return;
    }
    
    NSString *memberId = [EGLoginTool loginSingleton].currentUser.MemberID;
    
    NSString * soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><GetGlobalRanking xmlns=\"egive.appservices\"><MemberID>%@</MemberID></GetGlobalRanking></soap:Body></soap:Envelope>",memberId];
    
    
    [EGRankModel getOtherRankInfoWithParams:soapMessage block:^(NSDictionary *dict, NSError *error) {
        
        self.ranknumLabel.text = [NSString stringWithFormat:@"%@",dict[@"Rank"]];
        
        if ([dict[@"Rank"] description].length>0) {
            if ([[_ranknumLabel.text substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"/"]) {
                _ranknumLabel.text = [NSString stringWithFormat:@"0%@", _ranknumLabel.text];
            }
        }else{
            self.ranknumLabel.text = @"0/0";
        }
    }];

}


-(void)loadCart{

   
    
    NSString *cookieId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    EGUserModel *user = [EGLoginTool loginSingleton].currentUser;
    NSString *memberID = @"";
    if (user.MemberID && user.MemberID.length>0) {
        memberID = user.MemberID;
        cookieId = @"";
    }
    
    NSString * soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><GetMemberTotalDonationAmount xmlns=\"egive.appservices\"><MemberID>%@</MemberID></GetMemberTotalDonationAmount></soap:Body></soap:Envelope>",memberID];
    
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
        NSString* donaStr = [NSString stringWithFormat:@"%@",[dict[@"Amt"] stringByReplacingOccurrencesOfString:@"(null) " withString:@"0"]];
        
        self.moneynumLabel.text = [NSString stringWithFormat:@"HK$ %@",donaStr];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"success = %@", error);
    }];
    
    [operation start];
}


-(void)loadData:(NSInteger)index{
    [SVProgressHUD show];
    
    NSInteger lang = [Language getLanguage];
    
    NSString *category = _categoryArray[index];
    
    
    //最热心参与企业
    if (_currentMenuIndex==1) {
        category = @"MC";
    }
    
    
    DLOG(@"_category=%@",category);
    
    NSString * soapMessage =
    [NSString stringWithFormat:
     @"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body> <GetRankingList xmlns=\"egive.appservices\"><Lang>%ld</Lang><Category>%@</Category><StartRowNo>1</StartRowNo><NumberOfRows>10</NumberOfRows></GetRankingList></soap:Body></soap:Envelope>",(long)lang,category
     ];
    
   [EGRankModel getRankWithParams:soapMessage block:^(NSArray *array, NSError *error) {
       [SVProgressHUD dismiss];
       if (!error) {
           
           if (array.count>0) {
               self.rankArray = [NSMutableArray arrayWithArray:array];
               [self refreshUI:_currentMenuIndex];
           }else{
               self.rankArray = nil;
//               [UIAlertView alertWithText:@"No Data"];
           }
       }else{
           self.rankArray = nil;
//           [UIAlertView alertWithText:@"Unknow error"];
       }
       
       [_rightTableView reloadData];
   }];
    
    
}

#pragma mark 接受国际化文字改变通知
-(void)languageChangeChange{

    [self refreshUI:_currentMenuIndex];
    
    [self loadData:_selectedRow];
    
    [_leftTableView reloadData];
}


#pragma mark - tableview

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger tag = tableView.tag;
    if (tag==kLeftTableViewTag) {
        return tableView.frame.size.height / 8;
    }else{
    
        if (indexPath.row==0) {
            return 135;
        }
        
    }
    
    return 80;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger tag = tableView.tag;
    if (tag==kLeftTableViewTag) {
        if(_currentMenuIndex==1){
            return 1;
        }
        return 8;
    }else{
        return self.rankArray.count;
    }
    return 0;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    
    NSInteger tag = tableView.tag;
    
    if (tag==kLeftTableViewTag) {
        
        EGRankLeftViewCell *leftCell = [EGRankLeftViewCell cellWithTableView:tableView atIndexPath:indexPath currentIndexMenu:_currentMenuIndex];
        
        //
        UIView *bview = [[UIView alloc] initWithFrame:leftCell.frame] ;
        bview.backgroundColor = [UIColor colorWithHexString:@"#E9EAEC"];
        leftCell.selectedBackgroundView = bview;
        
        UIImage *image = [UIImage imageNamed:@"menu_arrow"];
        UIImageView *arrowView = [[UIImageView alloc] initWithImage:image];
        [bview addSubview:arrowView];
        
        [arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bview);
            make.right.equalTo(bview).offset(-20);
        }];
        
        //
        leftCell.currentIndexMenu = _currentMenuIndex;
        UIView *line = [UIView normalLine];
        line.frame = (CGRect){0,tableView.frame.size.height / 8 -1,WIDTH,1.5};
        [leftCell.contentView addSubview:line];
        
        return leftCell;
    }else{
        
        //
        EGRankItem *item = _rankArray[indexPath.row];
        NSURL *url = [NSURL URLWithString:SITE_URL];
        url = [url URLByAppendingPathComponent:item.ProfilePicFilePath];
        
        //
        if (indexPath.row==0) {
            EGRankRightFirstViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"first"];
           
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"EGRankRightFirstViewCell" owner:self options:nil] lastObject];
                [cell addSubview:[UIView normalLine]];
            }
            //
            cell.nameLabel.textColor = [UIColor colorWithHexString:@"#531E7D"];
            cell.moneyLabel.textColor = [UIColor colorWithHexString:@"#531E7D"];
            
            //
            cell.nameLabel.text = item.MemberName;
            if(_currentMenuIndex==1){
                cell.moneyLabel.text = [NSString stringWithFormat:@"%@: %@",HKLocalizedString(@"參與人數"),item.Amt];
            }else{
                
                NSString *money = [self countNumAndChangeformat:[item.Amt description]];
                cell.moneyLabel.text = [NSString stringWithFormat:@"HK$ %@",money];
            }
           
            //
            
//            [cell.icon sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"ranking_photo_others"]];
            
            [cell.icon sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"ranking_photo_others"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                UIImage *new = [image circleImage:image withParam:0];
                
                
                
                [cell.icon setImage: new];
            }];
            
            //
            if(_currentMenuIndex!=1 && _selectedRow!=0){
                cell.moneyLabel.hidden = YES;
            }else{
                 cell.moneyLabel.hidden = NO;
            }
            
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
        
        
        EGRankRightViewCell *rightCell = [EGRankRightViewCell cellWithTableView:tableView atIndexPath:indexPath];
        
        rightCell.selectionStyle = UITableViewCellSelectionStyleNone;
        rightCell.nameLabel.text = item.MemberName;
        
        if(_currentMenuIndex==1){
            rightCell.moneyLabel.text = [NSString stringWithFormat:@"%@: %@",HKLocalizedString(@"參與人數"),item.Amt];
        }else{
            NSString *money = [self countNumAndChangeformat:[item.Amt description]];
            rightCell.moneyLabel.text = [NSString stringWithFormat:@"HK$ %@",money];
        }

        [rightCell.icon sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"ranking_photo_others"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            UIImage *new = [image circleImage:image withParam:0];
            [rightCell.icon setImage: new];
        }];
        
        //
        if(_currentMenuIndex!=1 && _selectedRow!=0){
            rightCell.moneyLabel.hidden = YES;
        }else{
            rightCell.moneyLabel.hidden = NO;
        }
        
        

//        [rightCell.icon sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"ranking_photo_others"]];
        return rightCell;
    }
    
    
//    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (tableView.tag == kLeftTableViewTag) {
        
        if (_currentMenuIndex!=1) {
            [self loadData:indexPath.row];
            _selectedRow = indexPath.row;
            self.rightTopLabel.text = _titleArray[indexPath.row];
        }
        
    }

//    MPMoviePlayerViewController *mp = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:@"http://www.egive4u.org//AppBannerAd//E1C7ED67-C887-43CA-A39A-20C27A810DA1.mp4"]];
//    [self presentMoviePlayerViewControllerAnimated:mp];
}



-(NSString *)countNumAndChangeformat:(NSString *)num{
    int count = 0;
    long long int a = num.longLongValue;
    while (a != 0)    {
        count++;
        a /= 10;
    }
    NSMutableString *string = [NSMutableString stringWithString:num];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 3) {
        count -= 3;
        NSRange rang = NSMakeRange(string.length - 3, 3);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@"," atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    return newstring;

}


@end
