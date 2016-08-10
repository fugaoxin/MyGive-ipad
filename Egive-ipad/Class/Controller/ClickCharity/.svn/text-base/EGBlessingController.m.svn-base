//
//  EGBlessingController.m
//  Egive-ipad
//
//  Created by 123 on 15/12/8.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGBlessingController.h"
#import "EGBlessingCell.h"
#import "EGEditBlessingController.h"
#import "EGLoginViewController.h"
#import "SendBlessingsViewController.h"

#import "EGLoginByPushViewController.h"

#define ScreenSize screenWidth-400

@interface EGBlessingController ()<UITableViewDataSource,UITableViewDelegate,EGBlessingDelegate>

@property (strong, nonatomic) UITableView * FRtableView;
@property (nonatomic,strong) NSString * memberString;//MemberID表示符
@property (nonatomic,strong) EGLoginTool * EGLT;
@property (nonatomic,strong) UIAlertView * delectAlertView;
@property (nonatomic,strong) UIAlertView * alertView;

@property (strong, nonatomic) NSMutableArray * dataArray;
@property (nonatomic, assign) int deleteIndex;//删除标志

@end

@implementation EGBlessingController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setModel];
    [self SetTableView];
}

-(void)setNavigationBut
{
    self.title = [NSString stringWithFormat:@"%@(%lu)",HKLocalizedString(@"送祝福"),self.dataArray.count];
    UIView *barView=[self createNaviTopBarWithShowBackBtn:YES showTitle:YES];
    UIButton * shareBut=[[UIButton alloc] initWithFrame:CGRectMake(barView.frame.size.width-44, 0, 44, 44)];
    [shareBut setImage:[UIImage imageNamed:@"header_bless"] forState:UIControlStateNormal];
    [barView addSubview:shareBut];
    [shareBut addTarget:self action:@selector(clickRightButton) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBackButton setBackgroundImage:[UIImage imageNamed:@"common_close"] forState:UIControlStateNormal];
}

-(void)baseBackAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)clickRightButton
{
    if (self.EGLT.isLoggedIn) {
        EGEditBlessingController * EGED=[[EGEditBlessingController alloc] init];
        CGSize size = CGSizeMake(screenWidth-400, screenHeight-50);
        [EGED setContentSize:size  bgAction:NO animated:NO];
        EGED.model=self.model;
        [self.navigationController pushViewController:EGED animated:YES];
    }
    else
    {
        EGLoginViewController* vc = [[EGLoginViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [self requestXQData:self.caseID andMemberID:self.memberString];
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
    self.dataArray=[[NSMutableArray alloc] init];
}

#pragma mark - TableView
-(void)SetTableView
{
    self.FRtableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth-400, screenHeight-110) style:UITableViewStylePlain];
    self.FRtableView.delegate=self;
    self.FRtableView.dataSource=self;
    self.FRtableView.separatorStyle = NO;
    [self.contentView addSubview:self.FRtableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    long numOfLine = [self getNumOfLines:[self.dataArray[indexPath.row] objectForKey:@"Comment"]];
    //NSLog(@"numOfLine = %ld", numOfLine);
    long extraLine = numOfLine - 3;
    if (extraLine < 0) extraLine = 0;
    
    return 170.0f + extraLine * 13;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * str=@"cell";
    EGBlessingCell * cell=[tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        cell=[[EGBlessingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        cell.delegate=self;
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;//cell的选中风格
    
    EGBlessingModel * egbm=[[EGBlessingModel alloc] init];
    [egbm setDictionary:self.dataArray[indexPath.row]];
    [cell setModel:egbm andIndex:(int)indexPath.row];
    
    if ([self.memberString isEqualToString:egbm.MemberID]) {
        cell.deleteButton.hidden = NO;
    }else{
        cell.deleteButton.hidden = YES;
    }
    
    long numOfLine = [self getNumOfLines:egbm.Comment];
    long extraLine = numOfLine - 3;
    if (extraLine < 0) extraLine = 0;
    
    cell.bgImageView.frame = CGRectMake(20, 50, ScreenSize-40, 120+extraLine*13);
    cell.commentWv.frame = CGRectMake(22, 60, ScreenSize-44, 110+extraLine*13);
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"indexPath.row==%lu",(long)indexPath.row);
}

- (long)getNumOfLines:(NSString*)content {
    NSString *stripped = [content stringByReplacingOccurrencesOfRegex:@"<[^>]*>" withString:@""];
    long imgCount = [[content componentsSeparatedByString:@"<img "] count] -1;
    long strCount = [content length] - [[content stringByReplacingOccurrencesOfString:@"img " withString:@""] length];
    strCount /= [content length];
    
    long numOfLine = ([stripped length] + imgCount*5) / 15;
    if (numOfLine < 1) numOfLine = 0;
    if (imgCount > 0) numOfLine += 2;
    if (imgCount > 5) numOfLine += (imgCount % 3)*3;
    if (imgCount > 20) numOfLine += 3;
    if (imgCount > 30) numOfLine += 10;
    if (numOfLine > 5) numOfLine += 2;
    return numOfLine+1;
}

-(void)deleteBlessing:(int)index
{
    //DLOG(@"index====%d",index);
    self.deleteIndex=index;
    _delectAlertView = [[UIAlertView alloc] init];
    _delectAlertView.delegate = self;
    _delectAlertView.message =HKLocalizedString(@"确定要删除该祝福吗?") ;
    [_delectAlertView addButtonWithTitle:HKLocalizedString(@"取消")];
    [_delectAlertView addButtonWithTitle:HKLocalizedString(@"Common_button_confirm")];
    [_delectAlertView show];
}

#pragma mark - 请求cell数据
-(void)requestXQData:(NSString *)caseID andMemberID:(NSString *)memberID{
    [SVProgressHUD show];
    LanguageKey lang = [Language getLanguage];
    NSString * soapMessage =
    [NSString stringWithFormat:
     @"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><GetCaseDtl xmlns=\"egive.appservices\"><Lang>%ld</Lang><CaseID>%@</CaseID><MemberID>%@</MemberID></GetCaseDtl></soap:Body></soap:Envelope>",lang,caseID,memberID];
    //DLOG(@"lang==%ld\ncaseID==%@\nmemberID==%@",lang,caseID,memberID);
    [EGHomeModel postClickCharitytWithParams:soapMessage block:^(NSDictionary *data, NSError *error) {
        [SVProgressHUD dismiss];
        //DLOG(@"data===%@",data);
        self.dataArray=[data objectForKey:@"Comments"];
        [self setNavigationBut];
        [self.FRtableView reloadData];
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


- (void)DeleteCaseComment:(NSString *)caseCommentId andIndex:(int)index{
    
    NSString * soapMessage = [NSString stringWithFormat:
                              @"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><DeleteCaseComment xmlns=\"egive.appservices\"><CaseCommentID>%@</CaseCommentID></DeleteCaseComment></soap:Body></soap:Envelope>",caseCommentId];
    
    [EGHomeModel postWithHttpsConnection:YES soapMsg:soapMessage success:^(id result) {
        
        NSString *dataString = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        result = [EGHomeModel captureData:dataString];
        
        if ([[EGHomeModel captureData:dataString] isEqualToString:@"\"\""]) {
//            _alertView = [[UIAlertView alloc] init];
//            _alertView.message =HKLocalizedString(@"删除成功!");
//            [_alertView addButtonWithTitle:HKLocalizedString(@"Common_button_confirm")];
//            [_alertView show];
            [self requestXQData:self.caseID andMemberID:self.memberString];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] init];
            alertView.message = result;
            [alertView addButtonWithTitle:HKLocalizedString(@"Common_button_confirm")];
            [alertView show];
        }
    } failure:^(NSError * error) {
        
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == _delectAlertView) {
        if (buttonIndex == 1) {
            [self DeleteCaseComment:[self.dataArray[self.deleteIndex] objectForKey:@"CaseCommentID"] andIndex:self.deleteIndex];
        }
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
