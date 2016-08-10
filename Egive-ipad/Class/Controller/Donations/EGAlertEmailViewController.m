//
//  EGAlertEmailViewController.m
//  Egive-ipad
//
//  Created by vincentmac on 16/1/14.
//  Copyright © 2016年 Sino. All rights reserved.
//

#import "EGAlertEmailViewController.h"
#import "EGAlertContactViewController.h"
#import "EGContactModel.h"
#import "EGSelectEmailCell.h"
#import "EGVerifyTool.h"
#import "YQViewController.h"
#import "EGRegisterAlertViewController.h"
#import "TPKeyboardAvoidingTableView.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "EGDonationModel.h"

@interface EGAlertEmailViewController ()<UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate>{

    NSMutableString *recodString;
}

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *blackView;

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingTableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (weak, nonatomic) IBOutlet UIButton *contactButton;

@property (strong,nonatomic) NSMutableArray *selectedArray;

@property (strong,nonatomic) NSMutableArray *currentArray;

@property (nonatomic,copy) NSArray *recordArray;

@end

@implementation EGAlertEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.blackView.layer.opacity = 0.8;
    _confirmBtn.layer.cornerRadius = 6;
    
    //
    [self loadData];
    
    
    //
    if (!_currentArray) {
        _currentArray = [NSMutableArray array];
        EGContactModel *model = [EGContactModel new] ;
        [_currentArray addObject:model];
        
        [self.tableView reloadData];
    }
    
    //
    UIView *footView = [UIView new];
    footView.frame = (CGRect){0,0,_tableView.frame.size.width,40};
    footView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = footView;
    
    //
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.backgroundColor = [UIColor colorWithHexString:@"#704896"];
    [addBtn setTitle:HKLocalizedString(@"增加呼吁对象") forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addBtn.layer.cornerRadius = 6;
    [footView addSubview:addBtn];
    
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(footView);
        make.centerY.equalTo(footView);
//        make.width.equalTo(footView).multipliedBy(0.8);
        make.left.equalTo(footView).offset(28);
        make.right.equalTo(footView).offset(-28);
        make.height.mas_equalTo(35);
    }];
    
    
    [addBtn bk_addEventHandler:^(id sender) {
        
        EGContactModel *model = [EGContactModel new];
        
        [_currentArray addObject:model];
        [self.tableView reloadData];
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    
    [_confirmBtn setTitle:HKLocalizedString(@"Dontiton_Confirm") forState:UIControlStateNormal];
    _titleLabel.text = HKLocalizedString(@"呼吁募捐");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (IBAction)contactAction:(id)sender {
    
    EGAlertContactViewController *contact = [[EGAlertContactViewController alloc] initWithNibName:@"EGAlertContactViewController" bundle:nil];
    
    contact.dismissBlock = ^(NSMutableArray *array){
        
        _selectedArray = [NSMutableArray array];
        for (EGContactModel *model in array) {
            if(model.isChecked){
                [_selectedArray addObject:model];
            }
        }
        
        [self refreshContact];
    };
    
    [self presentViewController:contact animated:YES completion:^{
        
    }];
}


- (IBAction)closeAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
       [[NSNotificationCenter defaultCenter] postNotificationName:@"DismissDonation" object:nil];
    }];
    
   
}


- (IBAction)confirmAction:(id)sender {
    [self displaySystemEmail:_currentArray];
}

-(void)refreshContact{
    
    if (_selectedArray.count<=0) {
        return;
    }
    
    NSMutableArray *temp = [_currentArray copy];

    //
    for (EGContactModel *model in _selectedArray) {
        
        
        NSString *email = model.email;
        
        BOOL isExist = NO;
        
        for (EGContactModel *e in temp) {
            if ([email isEqualToString:e.email]) {
                isExist = YES;
            }
        }
        
        if (!isExist) {
            [_currentArray addObject:model];
        }
    }
    
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _currentArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EGContactModel *item = _currentArray[indexPath.row];
    EGSelectEmailCell *cell = [EGSelectEmailCell cellWithTableView:tableView atIndexPath:indexPath item:item];
    
    
    [cell.emailField bk_addEventHandler:^(UITextField* sender) {
//        DLOG(@"emaile:%@",sender.text);
        if (![EGVerifyTool isEmail:sender.text]) {
            [self showMessageVCWithTitle:HKLocalizedString(@"输入错误") type:@"message_registerSuccess"  message:HKLocalizedString(@"[电邮地址]错误") messageButton:HKLocalizedString(@"Common_button_confirm")];
        }else{
            item.email = sender.text;
        }
        
    } forControlEvents:UIControlEventEditingDidEnd];
  
    
    [cell.closeButton bk_addEventHandler:^(id sender) {
        
        if (_currentArray.count<=1) {
            return ;
        }
        
        [_currentArray removeObject:item];
        [_tableView reloadData];
    } forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(void)showMessageVCWithTitle:(NSString*)title type:(NSString*)type message:(NSString*)message messageButton:(NSString*)btnTitle
{
    CGSize size = CGSizeMake(WIDTH-450, HEIGHT-350);
    if (message) {
        size = CGSizeMake(WIDTH-500, 200);
        if (btnTitle) {
            size = CGSizeMake(WIDTH-500, 200+60);//60 btnView高度
        }
    }
    EGRegisterAlertViewController* root = [[EGRegisterAlertViewController alloc]init];
    root.size = size;
    root.title = title;
    root.message = message;
    root.btnTitle = btnTitle;
    
    YQNavigationController *nav = [[YQNavigationController alloc] initWithSize:size rootViewController:root];
    nav.touchSpaceHide = YES;//点击没有内容的地方消失
    nav.panPopView = YES;//滑动返回上一层视图
    if ([type isEqualToString:@"message_registerSuccess"]){
        root.notShowLeftItem = YES;
        nav.touchSpaceHide = YES;//点击没有内容的地方消失
    }
    [nav show:YES animated:YES];
}


-(void)loadData{
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *memberID;
    EGUserModel *model = [EGLoginTool loginSingleton].currentUser;
    if (model.MemberID && [model.MemberID rangeOfString:@"null"].length<=0) {
        memberID = model.MemberID;
    }
    
    LanguageKey lang = [Language getLanguage];
    
    NSString *DonationID = @"";
    NSUserDefaults *Defaults = [[NSUserDefaults alloc] init];
    DonationID = [Defaults objectForKey:@"DonationID"];//5139a3a1-f476-4aba-a76a-7febc5f10589|cecb37cd-94ba-4249-bccc-e869d208faa6

    NSString * soapMsg =[NSString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                         "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                         "<soap:Body>"
                         "<GetDonationRecord xmlns=\"egive.appservices\">"
                         "<Lang>%ld</Lang>"
                         "<MemberID>%@</MemberID>"
                         "<DonationID>%@</DonationID>"
                         "<StartRowNo>1</StartRowNo>"
                         "<NumberOfRows>999</NumberOfRows>"
                         "</GetDonationRecord>"
                         "</soap:Body>"
                         "</soap:Envelope>",lang, memberID,DonationID];
    
    [EGDonationModel getDonationRecordWithParams:soapMsg block:^(NSArray *array, NSError *error) {
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error) {
            
            if (array.count>0) {
                self.recordArray = array;
            }
           
        }else{
            [UIAlertView alertWithText:@"Unknow error"];
        }
    }];
    
}


- (void)displaySystemEmail:(NSMutableArray *)emailArray{
    
    MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
    if (!mailViewController) {
        // 在设备还没有添加邮件账户的时候mailViewController为空，下面的present view controller会导致程序崩溃，这里要作出判断
        
        NSLog(@"设备还没有添加邮件账户");
        return;
    }
    mailViewController.mailComposeDelegate = self;
    NSMutableArray * arr = [[NSMutableArray alloc] init];
    for (int i = 0; i < emailArray.count; i ++) {
        EGContactModel *obj = emailArray[i];
        
        if(obj.email ){
            [arr addObject:obj.email];
        }
        
    }
    //    NSArray *toRecipients = [NSArray arrayWithObjects:@"info@egive4u.org",@"",nil];
    [mailViewController setToRecipients: arr];
    
    // 2.设置邮件主题
    [mailViewController setSubject:@""];
    if ([Language getLanguage]==1) {
        [mailViewController setSubject:@"請支持Eigve專案"];
    }else if ([Language getLanguage]==2){
        [mailViewController setSubject:@"请支持Eigve专案"];
    }else{
        [mailViewController setSubject:@"Please Support Eigve Project"];
    }

    recodString = [[NSMutableString alloc] init];
    NSString *tempRecord;
    
    // 3.设置邮件主体内容
    for (EGRecordItem *record in _recordArray) {
        tempRecord = nil;
        tempRecord  = [NSString stringWithFormat:@"\n%@ - %@CaseDetail.aspx?CaseID=%@",record.CaseTitle,SITE_URL,record.CaseID];
//        tempRecord  = [NSString stringWithFormat:@"%@\n",recodString];
        
        [recodString appendString:tempRecord];
    }
    
    
    
    if (recodString.length<=0) {
        NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
        
        NSArray *array =  [standardUserDefaults objectForKey:kDonationCaseList];
        for (NSDictionary *dict in array) {
            //EGCartItem *item = [EGCartItem mj_objectWithKeyValues:dict];
            tempRecord = nil;
            tempRecord  = [NSString stringWithFormat:@"\n%@ - %@CaseDetail.aspx?CaseID=%@",dict[@"CaseTitle"],SITE_URL,dict[@"CaseID"]];

            [recodString appendString:tempRecord];
        }
    }
    
    
//    if (!recodString || [recodString rangeOfString:@"null"].length>0) {
//        recodString = @"";
//    }
    
    if ([Language getLanguage]==1) {
        [mailViewController setMessageBody:[NSString stringWithFormat:@"我剛剛在Egive上贊助了以下項目:\n\n%@\n您也来支持！\n\n請瀏覽: %@\n\n意贈慈善基金\nEgive For You Charity Foundation\n電話: (852) 2210 2600\n電郵: info@egive4u.org",recodString,SITE_URL] isHTML:NO];
    }else if ([Language getLanguage]==2){
        
        [mailViewController setMessageBody:[NSString stringWithFormat:@"我刚刚在Egive上赞助了以下项目:\n\n%@\n您也来支持！\n\n请浏览: %@\n\n意赠慈善基金\nEgive For You Charity Foundation\n电话: (852) 2210 2600\n电邮: info@egive4u.org",recodString,SITE_URL] isHTML:NO];
    }else{
        [mailViewController setMessageBody:[NSString stringWithFormat:@"I have just made a donation on the following case(s) in Egive:\n\n%@\n Let's join me and support Egive! \n\nVisit us at %@\n\nEgive For You Charity Foundation\nTel: (852) 2210 2600\nEmail: info@egive4u.org",recodString,SITE_URL] isHTML:NO];
    }
    

    // 5.呼出发送视图
    [self presentViewController:mailViewController animated:YES completion:^{
        
    }];
    
}



#pragma mark - 实现 MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    //关闭邮件发送窗口
    //    [self dismissModalViewControllerAnimated:YES];
    
   
    
    [self dismissViewControllerAnimated:YES completion:^{
        NSString *msg;
        switch (result) {
            case MFMailComposeResultCancelled:
                msg = HKLocalizedString(@"用户取消编辑邮件");
                
                break;
            case MFMailComposeResultSaved:
                msg = HKLocalizedString(@"用户成功保存邮件");
                break;
            case MFMailComposeResultSent:
                msg = HKLocalizedString(@"用户点击发送，将邮件放到队列中，还没发送");
                
                
                
                if (_dismissBlock) {
                    _dismissBlock();
                }
                break;
            case MFMailComposeResultFailed:
                msg = HKLocalizedString(@"用户试图保存或者发送邮件失败");
                break;
            default:
                msg = @"";
                
                
                break;
        }
    }];
    
   
   
    
    //    [self alertWithMessage:msg];
    
}

@end
