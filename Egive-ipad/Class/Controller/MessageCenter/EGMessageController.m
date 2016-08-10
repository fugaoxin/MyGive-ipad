//
//  EGMessageController.m
//  Egive-ipad
//
//  Created by 123 on 16/3/4.
//  Copyright © 2016年 Sino. All rights reserved.
//

#import "EGMessageController.h"
#import "EGMessageCell.h"
#import "EGtextLabelCell.h"
#import "EGHomeModel.h"


@interface EGMessageController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UIButton * messageButton;
@property (nonatomic,strong) UITableView * MCtableView;
@property (nonatomic,strong) UITableView * mgtableView;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,strong) NSArray * titleArray;
@property (nonatomic,strong) NSArray * MsgTpArray;
@property (nonatomic,strong) NSString * memberString;//MemberID表示符
@property (nonatomic,strong) EGLoginTool * EGLT;
@property (nonatomic,strong) NSMutableArray * CaseIDArray;
@property (nonatomic,strong) NSMutableArray * HaveReadIDArray;//已读ID数组

@end

@implementation EGMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor colorWithHexString:@"#EBEAEB"];
    self.view.backgroundColor=[UIColor whiteColor];
    [self setModel];
    [self loadData:@""];
    [self contentView];
}

#pragma mark - 初始化数据
-(void)setModel
{
    self.dataArray=[[NSMutableArray alloc] init];
    self.CaseIDArray=[[NSMutableArray alloc] init];
    self.HaveReadIDArray=[[NSMutableArray alloc] init];
    self.titleArray=@[HKLocalizedString(@"全部"),
                      HKLocalizedString(@"意赠活动"),
                      HKLocalizedString(@"新增个案"),
                      HKLocalizedString(@"进度报告"),
                      HKLocalizedString(@"成功筹募"),
                      HKLocalizedString(@"捐款记录")];
    self.MsgTpArray=@[@"",
                      @"EVENT",
                      @"CASE",
                      @"CASEUPDATE",
                      @"SUCCESS",
                      @"DONATION"];
    self.EGLT=[EGLoginTool loginSingleton];
    EGUserModel * UModel=[self.EGLT currentUser];
    if (UModel.MemberID == nil) {
        self.memberString=@"";
    }
    else
    {
        self.memberString=UModel.MemberID;
    }
}

#pragma mark - 消除通知
-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"scrollTitle" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GiveInformation" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"progressReport" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NEWNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DonationRecord" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Support" object:nil];
}

#pragma mark - 主界面
-(void)contentView
{
    self.messageButton=[[UIButton alloc] initWithFrame:CGRectMake(5, 5, screenWidth-64-10, 40)];
    self.messageButton.backgroundColor=[UIColor whiteColor];
    [self.messageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.messageButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.messageButton.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    [self.view addSubview:self.messageButton];
    [self.messageButton.layer setMasksToBounds:YES];
    [self.messageButton.layer setCornerRadius:5.0];
    [self.messageButton.layer setBorderWidth:0.5];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0, 0, 0, 0.5 });
    [self.messageButton.layer setBorderColor:colorref];
    
    UIImage * imag=[UIImage imageNamed:@"comment_picker"];
    imag=[imag stretchableImageWithLeftCapWidth:imag.size.width/2 topCapHeight:0];
    [self.messageButton setBackgroundImage:imag forState:UIControlStateNormal];
    [self.messageButton setTitle:HKLocalizedString(@"全部") forState:UIControlStateNormal];
    [self.messageButton addTarget:self action:@selector(messagebuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.MCtableView=[[UITableView alloc] initWithFrame:CGRectMake(0, self.messageButton.frame.size.height+5, screenWidth-64, screenHeight-64-50)];
    self.MCtableView.delegate=self;
    self.MCtableView.dataSource=self;
    self.MCtableView.separatorStyle = NO;
    //self.MCtableView.backgroundColor=[UIColor greenColor];
    [self.view addSubview:self.MCtableView];
    
    self.mgtableView=[[UITableView alloc] initWithFrame:CGRectMake(5, self.messageButton.frame.size.height+5, screenWidth-64-10, 40*self.titleArray.count)];
    self.mgtableView.delegate=self;
    self.mgtableView.dataSource=self;
    self.mgtableView.separatorStyle = NO;
    [self.view addSubview:self.mgtableView];
    self.mgtableView.hidden=YES;
}

#pragma mark 点击信息按钮
-(void)messagebuttonClick:(UIButton *)button
{
    button.selected=!button.selected;
    if (button.selected) {
        self.mgtableView.hidden=NO;
    }
    else
    {
        self.mgtableView.hidden=YES;
    }
}

#pragma mark - tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.MCtableView]) {
        return self.dataArray.count;
    }
    if ([tableView isEqual:self.mgtableView]) {
        return self.titleArray.count;
    }
    
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.MCtableView]) {
        return 125;
    }
    if ([tableView isEqual:self.mgtableView]) {
        return 40;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.MCtableView]) {
        static NSString * str=@"cell";
        EGMessageCell * cell=[tableView dequeueReusableCellWithIdentifier:str];
        if (cell==nil) {
            cell=[[EGMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [cell setData:self.dataArray[indexPath.row] andIDArray:[user objectForKey:@"HaveReadID"]];
        
        return cell;
    }
    if ([tableView isEqual:self.mgtableView]) {
        static NSString * str=@"mgCell";
        EGtextLabelCell * cell=[tableView dequeueReusableCellWithIdentifier:str];
        if (cell==nil) {
            cell=[[EGtextLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        cell.EGLabel.text=self.titleArray[indexPath.row];
        return cell;
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.MCtableView]) {
        //DLOG(@"dic===%@",self.dataArray[indexPath.row]);
        NSString * MsgTp=[self.dataArray[indexPath.row] objectForKey:@"MsgTp"];
        [self.MCtableView reloadData];
        if(([[self.dataArray[indexPath.row] objectForKey:@"Title"] rangeOfString:@"支持意赠"].location==NSNotFound)&&([[self.dataArray[indexPath.row] objectForKey:@"Title"] rangeOfString:@"支持意贈"].location==NSNotFound)&&([[self.dataArray[indexPath.row] objectForKey:@"Title"] rangeOfString:@"Donate Egive"].location==NSNotFound))
        {
            if ([MsgTp isEqualToString:@"EVENT"]) {
                NSDictionary * dic=@{@"CaseID":[self.dataArray[indexPath.row] objectForKey:@"RefID"],
                                     @"MemberID":self.memberString};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"GiveInformation" object:nil userInfo:@{@"index" : dic}];
            }
            else if([MsgTp isEqualToString:@"CASE"])
            {
                NSDictionary * dic=@{@"CaseID":[self.dataArray[indexPath.row] objectForKey:@"RefID"],
                                     @"MemberID":self.memberString};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollTitle" object:nil userInfo:@{@"index" : dic}];
            }
            else if([MsgTp isEqualToString:@"CASEUPDATE"])
            {
                NSDictionary * dic=@{@"CaseID":[self.dataArray[indexPath.row] objectForKey:@"RefID"],
                                     @"MemberID":self.memberString};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"progressReport" object:nil userInfo:@{@"index" : dic}];
            }
            else if([MsgTp isEqualToString:@"SUCCESS"])
            {
                NSDictionary * dic=@{@"CaseID":[self.dataArray[indexPath.row] objectForKey:@"RefID"],
                                     @"MemberID":self.memberString};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollTitle" object:nil userInfo:@{@"index" : dic}];
            }
            else if([MsgTp isEqualToString:@"DONATION"])
            {
                NSDictionary * dic=@{@"CaseID":[self.dataArray[indexPath.row] objectForKey:@"RefID"],
                                     @"MemberID":self.memberString};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollTitle" object:nil userInfo:@{@"index" : dic}];
            }
            else
            {
            }
        }
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        //[user removeObjectForKey:@"HaveReadID"];
        if ([user objectForKey:@"HaveReadID"]) {
            if (self.HaveReadIDArray) {
                [self.HaveReadIDArray removeAllObjects];
            }
            for(NSString * ID in [user objectForKey:@"HaveReadID"]){
                [self.HaveReadIDArray addObject:ID];
            }
        }
        
        if (self.HaveReadIDArray.count==0) {
            [self.HaveReadIDArray addObject:[self.dataArray[indexPath.row] objectForKey:@"MsgID"]];
        }
        else
        {
            for(int i=0; i<self.HaveReadIDArray.count; i++)
            {
                if (![[self.dataArray[indexPath.row] objectForKey:@"MsgID"] isEqualToString:self.HaveReadIDArray[i]]) {
                    if (self.HaveReadIDArray.count-1==i) {
                        [self.HaveReadIDArray addObject:[self.dataArray[indexPath.row] objectForKey:@"MsgID"]];
                    }
                }
                else
                {
                    break;
                }
            }
        }
        //DLOG(@"HaveReadIDArray====%@",self.HaveReadIDArray);
        [user setObject:self.HaveReadIDArray forKey:@"HaveReadID"];
//        DLOG(@"%@",[self.dataArray[indexPath.row] objectForKey:@"MsgID"]);
//        DLOG(@"RefID=====HaveReadIDArray===%@",[user objectForKey:@"HaveReadID"]);
        if (((int)(self.dataArray.count)-(int)(self.HaveReadIDArray.count))>0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NEWNotification" object:nil userInfo:@{@"news" : [NSString stringWithFormat:@"%lu",self.dataArray.count-self.HaveReadIDArray.count],@"index" :[NSString stringWithFormat:@"%lu",self.dataArray.count]}];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NEWNotification" object:nil userInfo:@{@"news" : [NSString stringWithFormat:@"%d",0],@"index" :[NSString stringWithFormat:@"%lu",self.dataArray.count]}];
        }
    }
    else
    {
        [self.messageButton setTitle:self.titleArray[indexPath.row] forState:UIControlStateNormal];
        [self loadData:self.MsgTpArray[indexPath.row]];
    }
    self.mgtableView.hidden=YES;
    self.messageButton.selected=!self.messageButton.selected;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.MCtableView]) {
        return  UITableViewCellEditingStyleDelete;
    }
    
    return UITableViewCellEditingStyleNone;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.MCtableView]) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            if ([[user objectForKey:@"HaveReadID"] count]>0) {
                if (self.HaveReadIDArray) {
                    [self.HaveReadIDArray removeAllObjects];
                }
                for(NSString * ID in [user objectForKey:@"HaveReadID"]){
                    [self.HaveReadIDArray addObject:ID];
                }
                
                for(int i=0; i<self.HaveReadIDArray.count; i++)
                {
                    if ([[self.dataArray[indexPath.row] objectForKey:@"MsgID"] isEqualToString:self.HaveReadIDArray[i]]) {
                        [self.HaveReadIDArray removeObjectAtIndex:i];
                        [user setObject:self.HaveReadIDArray forKey:@"HaveReadID"];
                        //DLOG(@"user>>>>%@",[user objectForKey:@"HaveReadID"]);
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"NEWNotification" object:nil userInfo:@{@"news" : [NSString stringWithFormat:@"%lu",self.dataArray.count-self.HaveReadIDArray.count-1],@"index" :[NSString stringWithFormat:@"%lu",self.dataArray.count-1]}];
                        break;
                    }
                    else
                    {
                        if (self.HaveReadIDArray.count-1==i) {
                            if (((int)(self.dataArray.count)-(int)(self.HaveReadIDArray.count))>0) {
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"NEWNotification" object:nil userInfo:@{@"news" : [NSString stringWithFormat:@"%lu",self.dataArray.count-self.HaveReadIDArray.count-1],@"index" :[NSString stringWithFormat:@"%lu",self.dataArray.count-1]}];
                            }
                            else{
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"NEWNotification" object:nil userInfo:@{@"news" : [NSString stringWithFormat:@"%d",0],@"index" :[NSString stringWithFormat:@"%lu",self.dataArray.count-1]}];
                            }
                            break;
                        }
                    }
                }
            }
            else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NEWNotification" object:nil userInfo:@{@"news" : [NSString stringWithFormat:@"%lu",self.dataArray.count-1],@"index" :[NSString stringWithFormat:@"%lu",self.dataArray.count-1]}];
            }
            
            [self deleteData:[self.dataArray[indexPath.row] objectForKey:@"MsgID"]];
            [self.dataArray removeObjectAtIndex:indexPath.row];
            [self.MCtableView reloadData];
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return HKLocalizedString(@"Delete");
}

#pragma mark - 请求数据
-(void)loadData:(NSString *)MsgTp
{
    [SVProgressHUD show];
    LanguageKey lang = [Language getLanguage];
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppToken_Dict"];
    NSString *token =  dict[@"AppToken"];
    //DLOG(@"token===%@",token);
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
        //DLOG(@"responseObj==%@",responseObj);
        [SVProgressHUD dismiss];
        if (self.dataArray.count>0) {
            [self.dataArray removeAllObjects];
        }
        for(NSDictionary * dic in [responseObj objectForKey:@"MsgList"])
        {
            [self.dataArray addObject:dic];
        }
        [self.MCtableView reloadData];
        
//        if (self.dataArray) {
//            for(NSDictionary * dic in self.dataArray)
//            {
//                if (self.CaseIDArray.count==0) {
//                    [self.CaseIDArray addObject:[dic objectForKey:@"MsgID"]];
//                }
//                else{
//                    for(int i=0; i<self.CaseIDArray.count; i++)
//                    {
//                        if (![[dic objectForKey:@"Msg"] isEqualToString:self.CaseIDArray[i]]) {
//                            if (self.CaseIDArray.count-1==i) {
//                                [self.CaseIDArray addObject:[dic objectForKey:@"MsgID"]];
//                            }
//                        }
//                        else
//                        {
//                            break;
//                        }
//                    }
//                }
//            }
//        }
        
//        DLOG(@"CaseIDArray>>>>>>>>>>>%@,\ncount===%lu",self.CaseIDArray,self.CaseIDArray.count);
        if ([MsgTp isEqualToString:@""]) {
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            NSArray * arr=[user objectForKey:@"HaveReadID"];
            if (arr.count>0) {
                if (self.HaveReadIDArray) {
                    [self.HaveReadIDArray removeAllObjects];
                }
                for (NSDictionary * dic in self.dataArray) {
                    for (NSString * str in arr) {
                        if ([dic[@"MsgID"] isEqualToString:str]) {
                            [self.HaveReadIDArray addObject:str];
                        }
                    }
                }
            }
            [user setObject:self.HaveReadIDArray forKey:@"HaveReadID"];
            if (((int)(self.dataArray.count)-(int)(self.HaveReadIDArray.count))>0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NEWNotification" object:nil userInfo:@{@"news" : [NSString stringWithFormat:@"%lu",self.dataArray.count-arr.count],@"index" :[NSString stringWithFormat:@"%lu",self.dataArray.count]}];
            }
            else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NEWNotification" object:nil userInfo:@{@"news" : [NSString stringWithFormat:@"%d",0],@"index" :[NSString stringWithFormat:@"%lu",self.dataArray.count]}];
            }
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
            [SVProgressHUD dismiss];
        }
    }];
    [manager.reachabilityManager startMonitoring];
}


#pragma mark 删除数据
-(void)deleteData:(NSString *)MsgID
{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppToken_Dict"];
    NSString *token =  dict[@"AppToken"];
    NSString * soapMessage =
    [NSString stringWithFormat:
     @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
     "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
     "<soap:Body>"
     "<DeleteMailBoxMsg xmlns=\"egive.appservices\">"
     "<AppToken>%@</AppToken>"
     "<MsgID>%@</MsgID>"
     "</DeleteMailBoxMsg>"
     "</soap:Body>"
     "</soap:Envelope>",token,MsgID
     ];
    [EGHomeModel postWithSoapMsg:soapMessage success:^(id responseObj) {
        //DLOG(@"DeleteMailBoxMsg==%@",responseObj);
    } failure:^(NSError *error) {
    }];
}

@end


