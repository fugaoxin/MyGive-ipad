//
//  EGCaseConfirmViewController.m
//  Egive-ipad
//
//  Created by vincentmac on 15/12/15.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGCaseConfirmViewController.h"
#import <TPKeyboardAvoiding/TPKeyboardAvoidingScrollView.h>
#import "UIView+line.h"
#import <YYText.h>
#import "EGNoticeViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "EGDonationModel.h"
#import "EGConfirmCaseCell.h"
#import "EGLoginViewController.h"
#import "CZPickerView.h"
#import "TestViewController.h"
#import "NSString+RegexKitLite.h"
#import "EGLoginByPushViewController.h"
#import "EGAlertEmailViewController.h"
#import "EGRegisterAlertViewController.h"
#import "YQViewController.h"
#import "NSString+Helper.h"


#define kComfirmInfoTag 100
#define kComfirmStatementTag 101

#define kReceiptSegment 1000
#define kThanksSegment 1001

#define RowHeight 35

@interface EGCaseConfirmViewController ()<UITableViewDelegate,UITableViewDataSource>{

    UIView *_loginTipsView;
    
    UIView *_container;
    
    UITextField *_receiptField;
    
    UILabel *_receiptDetailLabel;
    
    YYLabel *_statementLabel;
    
    YYLabel *_loginLabel;
    
    UIButton *_loginBtn;
    
    NSString *_disclaimer;//捐款须知
    
    CGFloat _tableHeight;
    
    NSInteger _totalPrice;
    
    UITextField *_emailTextField;
    
    UITextField *_thanksNameField;//网上鸣谢
    
    UILabel *_nameLabel;
    
    UILabel *_emailLabel;
    
    UILabel *_caseTitleLabel;
    
    NSInteger showActionType;
}

//@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrollView;

@property (strong, nonatomic)  TPKeyboardAvoidingScrollView *scrollView;

@property (strong, nonatomic)  UITableView *tableView;


//@property (weak, nonatomic) IBOutlet UIButton *continueBtn;
@property (strong, nonatomic)  UIButton *continueBtn;

@property (nonatomic,strong) UILabel *caseNameLabel;

@property (nonatomic,strong) UILabel *donationPriceLabel;

@property (nonatomic,strong) UILabel *donationTotalPriceLabel;

@property (nonatomic,strong) UISegmentedControl *receiptSegment;//是否需要收据

@property (nonatomic,strong) UIView *receiptBgView;//收据

@property (nonatomic,strong) UISegmentedControl *thanksSegment;//是否需要网上鸣谢

@property (nonatomic,strong) UIView *thanksBgView;

@property (nonatomic,strong) UIButton *confirmStatementCheckBox;//确认声明

@property (nonatomic,strong) UIButton *confirmInfoCheckBox;//确认资料

@property (nonatomic,strong) NSMutableArray *data;

@end

@implementation EGCaseConfirmViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //
    [self setupUI];
    
    //
    [self getDisclaimer];
    
    
    [self loadData];
    
//    [self receiverPaySuccessful];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiverPaySuccessful) name:@"isPaySuccessful" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissConfirm) name:@"DismissConfirm" object:nil];
}


-(void)dismissConfirm{
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [[EGLoginTool loginSingleton] saveAlertDonation:NO];
}


-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DismissConfirm" object:nil];
}


-(void)viewWillAppear:(BOOL)animated{
    if ([EGLoginTool loginSingleton].isLoggedIn) {
        [self hiddenloginTipsView];
        
        
        //
        EGUserModel *model = [EGLoginTool loginSingleton].currentUser;
        
        if([model.MemberType isEqualToString:@"C"]){
            if (model.CorporationChiName.length>0) {
                _receiptField.text = [NSString stringWithFormat:@"%@",model.CorporationChiName];
            }else{
                _receiptField.text = [NSString stringWithFormat:@"%@",model.CorporationEngName];
            }
            _receiptDetailLabel.text = HKLocalizedString(@"receipt_should_match");
            _receiptField.userInteractionEnabled = NO;
            _receiptField.enabled = NO;
            _receiptSegment.userInteractionEnabled = NO;
            _receiptSegment.enabled = NO;
            _thanksSegment.userInteractionEnabled = NO;
            _thanksSegment.enabled = NO;
            _thanksNameField.userInteractionEnabled = NO;
            _thanksNameField.enabled = NO;
        }else{
            if (model.ChiFirstName.length>0) {
                _receiptField.text = [NSString stringWithFormat:@"%@%@",model.ChiFirstName,model.ChiLastName];
            }else{
                _receiptField.text = [NSString stringWithFormat:@"%@%@",model.EngFirstName,model.EngLastName];
            }
             _receiptDetailLabel.text = HKLocalizedString(@"ConfirmView_receiptNoteLabel");
        }
        
        _thanksNameField.text = model.LoginName;
       
        
        //
        [_receiptSegment setSelectedSegmentIndex:0];
        [_receiptBgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(65);
        }];
        _receiptField.hidden = NO;
        _receiptDetailLabel.hidden = NO;
        
        //
        _emailTextField.hidden = YES;
        _emailLabel.hidden = YES;
    }else{

        
        //
        [_receiptSegment setSelectedSegmentIndex:1];
        [_receiptBgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.5);
        }];
        _receiptField.hidden = YES;
        _receiptDetailLabel.hidden = YES;
        
        //
        _emailTextField.hidden = NO;
        _emailLabel.hidden = NO;
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"isPaySuccessful" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Notification
#pragma mark 支付成功后的回调
-(void)receiverPaySuccessful{
//    [self dismissViewControllerAnimated:YES completion:^{
//       
//    }];
    
    
//    CZPickerView *cz = [[CZPickerView alloc] initWithHeaderTitle:HKLocalizedString(@"呼籲募捐") singleButtonTitle:HKLocalizedString(@"MenuView_shareButton_title") singleTapAction:^{
//        
//      
//        
//    }];
//    cz.headerBackgroundColor = [UIColor colorWithHexString:@"#F4F5F6"];
//    cz.headerTitleColor = [UIColor colorWithHexString:@"#673291"];
//    cz.cancelButtonBackgroundColor = [UIColor colorWithHexString:@"#6CB92C"];
//    cz.cancelButtonNormalColor = [UIColor whiteColor];
//    cz.showCloseButton = YES;
//    [cz setContent:HKLocalizedString(@"感激你的慷慨捐输，请呼吁身边的朋友共襄善举，发扬大爱精神！")];
//    cz.needFooterView = YES;
//    [cz show];
    
    
    //
    DLOG(@"%@",_data);
    
    NSMutableArray *tempArray = [NSMutableArray array];
    
    
    for (EGCartItem *item in _data) {
        NSDictionary *dict = @{@"CaseID":item.CaseID,@"CaseTitle":item.Title};
        [tempArray addObject:dict];
    }
    
    
    NSUserDefaults *donDefaults = [NSUserDefaults standardUserDefaults];
    [donDefaults setObject:tempArray forKey:kDonationCaseList];
    [donDefaults synchronize];
    
    showActionType = 3;
    
    [self showMessageVCWithTitle:HKLocalizedString(@"呼籲募捐") type:@"message_registerSuccess" message:HKLocalizedString(@"感激你的慷慨捐输，请呼吁身边的朋友共襄善举，发扬大爱精神！") messageButton:HKLocalizedString(@"MenuView_shareButton_title")];
    
    
    
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
    root.messageAction = ^(EGRegisterAlertViewController *vc){
//        [vc.yqNavigationController show:NO animated:YES];
        
        
        if (showActionType==2) {
            EGLoginByPushViewController *login = [[EGLoginByPushViewController alloc] init];
            [login setContentSize:self.size bgAction:NO animated:NO];
            [self.navigationController pushViewController:login animated:YES];
            
        }else if (showActionType==3){
            [self showEmail];
        }
    };
    
    
    if (showActionType==2) {
        root.CloseAction = ^(){
            [_receiptSegment setSelectedSegmentIndex:1];
        };
    }else if (showActionType==3){
        root.CloseAction = ^(){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DismissConfirm" object:nil];
        };
    }
    
   
    
    
    YQNavigationController *nav = [[YQNavigationController alloc] initWithSize:size rootViewController:root];
    nav.touchSpaceHide = YES;//点击没有内容的地方消失
    nav.panPopView = YES;//滑动返回上一层视图
    if ([type isEqualToString:@"message_registerSuccess"]){
        root.notShowLeftItem = NO;
        nav.touchSpaceHide = NO;//点击没有内容的地方消失
    }
    
    
    [nav show:YES animated:YES];
}

-(void)showEmail{
    
    
    EGAlertEmailViewController *root = [[EGAlertEmailViewController alloc] initWithNibName:@"EGAlertEmailViewController" bundle:nil];
    
    root.dismissBlock = ^(){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DismissConfirm" object:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DismissDonation" object:nil];
        
        
        
//        [self performSelector:@selector(test) withObject:nil afterDelay:2];
        
        //[_vc dismissViewControllerAnimated:YES completion:nil];
    };
    
    [self presentViewController:root animated:YES completion:^{
        
    }];
    
    
   
    
//    CGSize size = CGSizeMake(WIDTH-200, HEIGHT-100);//(410, 570)
//    [root setContentSize:size  bgAction:NO animated:NO];
//    
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:root];
//    navigationController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//    [self presentViewController:navigationController animated:YES completion:nil];
}



#pragma mark - touch event
-(void)checkboxClick:(UIButton *)btn{
    NSInteger tag = btn.tag;

    if (tag==kComfirmInfoTag) {
        _confirmInfoCheckBox.selected = _confirmInfoCheckBox.selected ? NO :YES;
        
        
    }else if (tag==kComfirmStatementTag){
    
        _confirmStatementCheckBox.selected = _confirmStatementCheckBox.selected ? NO :YES;
    }
    
}


-(IBAction)continueClick:(UIButton *)btn{
    
    
    
    NSString *errorMsg = nil;
    // 1.
    if (!_confirmInfoCheckBox.selected) {
        errorMsg = HKLocalizedString(@"請選擇[本人確認以上捐款資料準確無誤。]");
    }else if (!_confirmStatementCheckBox.selected) {
        errorMsg = HKLocalizedString(@"請選擇[本人已閱讀及清楚明白以上捐款聲明，並同意有關善款安排及不獲發捐款收據。]");
    }
//    else if ( _thanksSegment.selectedSegmentIndex==0 && (_emailTextField.text.length<=0 || ![NSString isEmail:_emailTextField.text])) {
//        errorMsg = HKLocalizedString(@"無效的[電郵地址]!");
//    }
    if (errorMsg) {
        
        CZPickerView *pv = [[CZPickerView alloc] initWithHeaderTitle:HKLocalizedString(@"Common_button_confirm") cancelButtonTitle:nil confirmButtonTitle:nil];
        pv.headerBackgroundColor = [UIColor colorWithHexString:@"#F4F5F6"];
        pv.headerTitleColor = [UIColor colorWithHexString:@"#673291"];
        pv.showCloseButton = YES;
        [pv setContent:errorMsg];
        [pv show];
        
        
        return;
    }

    //
    NSString *memberId = @"";
    if ([EGLoginTool loginSingleton].isLoggedIn) {
        memberId = [EGLoginTool loginSingleton].currentUser.MemberID;
    }
    
    NSString *CookieID = @"";
    if (memberId.length<=0) {
        CookieID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }
    
    //需要收据
    NSString *receiptStr = @"";
    if (_receiptSegment.selectedSegmentIndex==0) {
        receiptStr = _receiptField.text.length>0 ? _receiptField.text : @"";
    }else{
    
    }
    
    NSString *email = _emailTextField.text;
    if (email.length<=0) {
        email = @"";
    }
    
    //网上鸣谢
    NSString *displayName = @"";
    if (_thanksSegment.selectedSegmentIndex==0) {
        displayName = _thanksNameField.text.length > 0 ? _thanksNameField.text : @"";
    }else{
        
    }
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppToken_Dict"];
    NSString *token =  dict[@"AppToken"];
    if (!token || token.length<=0) {
        token = [OpenUDID value];//27ad23ca874f2c97aa918df4ba6d2ce652c2ba65
    }

//    NSString * soapMsg =[NSString stringWithFormat:
//                         @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
//                         "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
//                         "<soap:Body>"
//                         "<CheckOutShoppingCart xmlns=\"egive.appservices\">"
//                         "<MemberID>%@</MemberID>"
//                         "<CookieID>%@</CookieID>"
//                         "<DisplayName>%@</DisplayName>"
//                         "<NameOnReceipt>%@</NameOnReceipt>"
//                         "<Email>%@</Email>"
//                         "<AppToken>%@</AppToken>"
//                         "</CheckOutShoppingCart>"
//                         "</soap:Body>"
//                         "</soap:Envelope>",memberId, CookieID, displayName, receiptStr, email,token];
    
    NSString * soapMsg =[NSString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                         "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                         "<soap:Body>"
                         "<CheckOutShoppingCartWithAppToken xmlns=\"egive.appservices\">"
                         "<MemberID>%@</MemberID>"
                         "<CookieID>%@</CookieID>"
                         "<DisplayName>%@</DisplayName>"
                         "<NameOnReceipt>%@</NameOnReceipt>"
                         "<Email>%@</Email>"
                         "<AppToken>%@</AppToken>"
                         "</CheckOutShoppingCartWithAppToken>"
                         "</soap:Body>"
                         "</soap:Envelope>",memberId, CookieID, displayName, receiptStr, email,token];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [EGDonationModel checkOutShoppingCartWithParams:soapMsg block:^(NSDictionary *dict, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (!error) {
            if (dict) {
                NSUserDefaults *Defaults = [[NSUserDefaults alloc] init];
                NSString *CustomParameter = dict[@"CustomParameter"];
                [Defaults setObject:CustomParameter forKey:@"DonationID"];
                NSString *url = [NSString stringWithFormat:@"%@/SendDataToPaypal.aspx?CustomParameter=%@&lang=1", SITE_URL, CustomParameter];
                url =[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                
            } else {
               
            }
            DLOG(@"result:%@",dict);
        }else{
            DLOG(@"error:%@",error);
        }
        
        
    }];
    
   
//    CZPickerView *pv = [[CZPickerView alloc] initWithHeaderTitle:@"利用OC的消息转发机制实现多重代理" cancelButtonTitle:nil confirmButtonTitle:nil];
//    CZPickerView *pv = [[CZPickerView alloc] initWithHeaderTitle:@"title" singleButtonTitle:HKLocalizedString(@"取消") singleTapAction:^{
//        NSLog(@"click...");
//    }];
//    pv.headerBackgroundColor = [UIColor colorWithHexString:@"#F4F5F6"];
//    pv.headerTitleColor = [UIColor colorWithHexString:@"#673291"];
//    pv.cancelButtonBackgroundColor = [UIColor colorWithHexString:@"#6CB92C"];
//    pv.cancelButtonNormalColor = [UIColor whiteColor];
    
//    pv.confirmButtonBackgroundColor = [UIColor colorWithHexString:@"#6CB92C"];
//    pv.needFooterView = YES;
//    pv.showCloseButton = YES;
//    [pv setContent:@"在Objective-C中，在Objective-C中，经常使用delegate来在对象之间通信，但是delegate一般是对象间一对一的通信，有时候我们希望delegate方法由多个不同的对象来处理，比如UITableView继承于UIScrollView,我们希望他的delegate中UIScrollViewDelegate的方法由一个独立的类来处理，以便实现一些效果，比如像下图这样的头部图片滚动拉伸效果，只需要实现UIScrolViewDelegate的scrollViewDidScroll方法，这样做的好处是可以降低代码耦合度，将实现不同功能的方法封装在独立的delegate中，便于复用和维护管理态添加的方法。例如,下面的例子"];
//    [pv show];
}


-(void)segmentValueChange:(UISegmentedControl *)seg{
    NSInteger tag = seg.tag;
    
    if (tag==kReceiptSegment) {
        
        if (seg.selectedSegmentIndex==1) {
            
            [_receiptBgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0.5);
            }];
            _receiptField.hidden = YES;
            _receiptDetailLabel.hidden = YES;
        }else{

            if ([EGLoginTool loginSingleton].isLoggedIn) {
                [_receiptBgView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(65);
                }];
                _receiptField.hidden = NO;
                _receiptDetailLabel.hidden = NO;
            }else{
                showActionType = 2;
                [self showMessageVCWithTitle:HKLocalizedString(@"捐款收据") type:@"message_registerSuccess" message:HKLocalizedString(@"如需收据请先注册成为会员") messageButton:HKLocalizedString(@"登入/注册")];
            }

        }
        
        
        
    }else if (tag==kThanksSegment){
        if (seg.selectedSegmentIndex==1) {
            
            [self hiddenThanksContentView:YES];
            
//            [_confirmInfoCheckBox mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.leading.equalTo(_container).offset(25);
//                make.top.equalTo(_thanksSegment.mas_bottom).offset(10);
//            }];
        }else{
            [self hiddenThanksContentView:NO];
//            [_confirmInfoCheckBox mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.leading.equalTo(_container).offset(25);
//                make.top.equalTo(_thanksBgView.mas_bottom).offset(20);
//            }];
            
            [_thanksBgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(65);
            }];
        }
    }
    
    
}

-(void)hiddenloginTipsView{

    [_loginTipsView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.1);
    }];
    
    _loginBtn.hidden = YES;
    _loginLabel.hidden = YES;
}


-(void)hiddenReceiptContentView:(BOOL)show{
    
    //_thanksBgView.hidden = show;
    
    [_receiptBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.1);
    }];
    _emailTextField.hidden = show;
    _thanksNameField.hidden = show;
    _nameLabel.hidden = show;
    _emailLabel.hidden = show;
}

-(void)hiddenThanksContentView:(BOOL)show{
    
    //_thanksBgView.hidden = show;
    
    [_thanksBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.1);
    }];
    _emailTextField.hidden = show;
    _thanksNameField.hidden = show;
    _nameLabel.hidden = show;
    _emailLabel.hidden = show;
}


#pragma mark - private method

-(void)setupUI{
    //
//    [self.navigationBar showLeftItemWithImage:@"common_header_back"];
//    self.navigationBar.barTintColor = [UIColor colorWithHexString:@"#F1F2F3"];
//    self.navigationBar.title = [Language getStringByKey:@"mydonation_comfirm_title"];
    
    
    
   
    self.view.backgroundColor = [UIColor clearColor];
    self.title = [Language getStringByKey:@"mydonation_comfirm_title"];
    [self createNaviTopBarWithShowBackBtn:YES showTitle:YES];
    _scrollView = [TPKeyboardAvoidingScrollView new];
    //_scrollView.frame = (CGRect){0,0,WIDTH-200,HEIGHT-200-44};
    [self.contentView addSubview:self.scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(0);
        make.leading.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-60);
    }];

    
    
    
    _continueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _continueBtn.layer.cornerRadius = 6;
    _continueBtn.backgroundColor = [UIColor colorWithHexString:@"#6AB62A"];
    [self.contentView addSubview:_continueBtn];
    
    //_continueBtn.frame = (CGRect){15,_scrollView.frame.size.height-50,WIDTH-200-30,40};
    [_continueBtn addTarget:self action:@selector(continueClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_continueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_scrollView.mas_bottom).offset(10);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.mas_equalTo(40);
    }];
    
//    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F6F8"];
    
    [self.continueBtn setTitle:HKLocalizedString(@"MyDonation_ContinueButton") forState:UIControlStateNormal];
    _scrollView.backgroundColor = [UIColor whiteColor];
    

    //
    UIView *container = [UIView new];
    _container = container;
    [_scrollView addSubview:container];
    
    
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.width.equalTo(_scrollView);
    }];
    
    
    
    //
    _loginTipsView = [UIView new];
    _loginTipsView.backgroundColor = [UIColor colorWithHexString:@"#EDEEEE"];
    [container addSubview:_loginTipsView];
    
    [_loginTipsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(container);
        make.top.equalTo(container);
        make.width.equalTo(container);
        make.height.mas_equalTo(44);
    }];

    
    //
    NSString *tipStr = HKLocalizedString(@"如需捐款收据及储存捐款记录,请先注册为意赠之友,或现为意赠之友,请按此登入");
    NSRange loginrange = [tipStr rangeOfString:HKLocalizedString(@"登入")];
    
    NSMutableAttributedString *tip = [[NSMutableAttributedString alloc] initWithString:tipStr];
    tip.yy_font = [UIFont boldSystemFontOfSize:NormalFontSize];
    tip.yy_color = [UIColor colorWithHexString:@"#000000"];
    tip.yy_underlineColor = [UIColor colorWithHexString:@"#6CB92C"];
    [tip yy_setUnderlineStyle:NSUnderlineStyleSingle range:loginrange];
    [tip yy_setColor:[UIColor colorWithHexString:@"#6CB92C"] range:loginrange];
    
    YYTextBorder *tipborder = [YYTextBorder new];
    tipborder.cornerRadius = 3;
    tipborder.insets = UIEdgeInsetsMake(0, -4, 0, -4);
    tipborder.fillColor = [UIColor greenColor];
    
    YYTextHighlight *loginHighlight = [YYTextHighlight new];
    [loginHighlight setBorder:tipborder];
    
    
    YYLabel *tipsLabel = [YYLabel new];
    _loginLabel = tipsLabel;
    tipsLabel.frame = (CGRect){5,4,700,40};
    tipsLabel.numberOfLines = 0;
    //tipsLabel.text = HKLocalizedString(@"如需捐款收据及储存捐款记录,请先注册为意赠之友,或现为意赠之友,请按此登入");
    [_loginTipsView addSubview:tipsLabel];
    
    loginHighlight.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        EGLoginByPushViewController *login = [[EGLoginByPushViewController alloc] init];
        [login setContentSize:self.size bgAction:NO animated:NO];
        [self.navigationController pushViewController:login animated:YES];
    };

    [tip yy_setTextHighlight:loginHighlight range:loginrange];
    tipsLabel.textColor = [UIColor blackColor];
    tipsLabel.attributedText = tip;
    tipsLabel.backgroundColor = [UIColor clearColor];
    
    if ([Language getLanguage]!=3) {
        tipsLabel.frame = (CGRect){5,4,530,40};
        
//        [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(_loginTipsView);
//            make.leading.equalTo(_loginTipsView).offset(15);
////            make.width.equalTo(_loginTipsView).multipliedBy(0.8);
////            make.width.mas_equalTo(600);
//        }];
    }
    
    
    
    

    
    //
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn = loginBtn;
    UIImage *loginImage = [UIImage imageNamed:@"login_btn"];
    [loginBtn setBackgroundImage:loginImage forState:UIControlStateNormal];
    [_loginTipsView addSubview:loginBtn];
    
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_loginTipsView);
        make.left.equalTo(tipsLabel.mas_right).offset(10);
    }];
    
    [loginBtn bk_addEventHandler:^(id sender) {
        
//        EGLoginViewController *login = [[EGLoginViewController alloc] initWithNibName:@"EGLoginViewController" bundle:nil];
//        UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:login];
        
        
//        [self presentViewController:nav animated:YES completion:nil];
        
//        TestViewController *test = [[TestViewController alloc] initWithNibName:@"TestViewController" bundle:nil];
//        [self.yqNavigationController pushYQViewController:test animated:YES];
       
        
//        [self.navigationController pushViewController:login animated:YES];
        
        
        EGLoginByPushViewController *login = [[EGLoginByPushViewController alloc] init];
        [login setContentSize:self.size bgAction:NO animated:NO];
        [self.navigationController pushViewController:login animated:YES];
        
        
//        TestViewController *test = [[TestViewController alloc] initWithNibName:@"TestViewController" bundle:nil];
//        [self presentViewController:test animated:YES completion:^{
//            
//        }];
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat margin = 25.0;
    
    //
    UILabel *caseTitleLabel = [UILabel createWithSize:NormalFontSize];
    _caseTitleLabel = caseTitleLabel;
    caseTitleLabel.font = [UIFont boldSystemFontOfSize:NormalFontSize+1];
    caseTitleLabel.text = HKLocalizedString(@"专案标题");
    caseTitleLabel.textColor = [UIColor colorWithHexString:@"#9B9C9D"];
    [container addSubview:caseTitleLabel];
    
    
    [caseTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(container).offset(margin);
        make.top.equalTo(_loginTipsView.mas_bottom).offset(5);
    }];
   
    
    
    //
    UILabel *casePriceLabel = [UILabel createWithSize:NormalFontSize];
    casePriceLabel.font = [UIFont boldSystemFontOfSize:NormalFontSize+1];
    casePriceLabel.textColor = [UIColor colorWithHexString:@"#9B9C9D"];
    casePriceLabel.text = HKLocalizedString(@"捐助金额");
    caseTitleLabel.textAlignment = NSTextAlignmentRight;
    [container addSubview:casePriceLabel];
    
    [casePriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(caseTitleLabel);
        make.right.equalTo(container).offset(-margin);
    }];
    
    //
    UIView *line = [UIView createLineWithColor:[UIColor colorWithHexString:@"#9B9C9D"]];
    [container addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(container).offset(margin);
        make.right.equalTo(container).offset(-margin);
        make.top.equalTo(caseTitleLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(1.0);
    }];
    

    
    _tableHeight = _caseCount * RowHeight;
    _tableView = [UITableView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.scrollEnabled = NO;
    [container addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line).offset(2);
        make.left.equalTo(container);
        make.width.equalTo(container);
        make.height.mas_equalTo(_tableHeight);
    }];
    
    //
    UIView *allPriceBgView = [UIView new];
    allPriceBgView.backgroundColor = [UIColor colorWithHexString:@"#EEF9EA"];
    [container addSubview:allPriceBgView];
    
    [allPriceBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(container);
        make.top.equalTo(_tableView.mas_bottom).offset(0);
        make.width.equalTo(container);
        make.height.mas_equalTo(35);
    }];
    
    
    //
    UILabel *allLabel = ({
        UILabel *label = [UILabel createWithSize:18];
        label.text = HKLocalizedString(@"捐款总额");
        label;
    });
    
    [allPriceBgView addSubview:allLabel];
    
    [allLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(allPriceBgView).offset(margin);
        make.centerY.equalTo(allPriceBgView);
    }];
    
    //
    self.donationTotalPriceLabel = ({
        UILabel *label = [UILabel createWithSize:18];
        label.text = @"HK$ 0";
        label.textAlignment = NSTextAlignmentRight;
        label;
    
    });
    
    [allPriceBgView addSubview:_donationTotalPriceLabel];
    
    [_donationTotalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(allPriceBgView).offset(-margin);
        make.centerY.equalTo(allPriceBgView);
    }];
    
    
    
    //@[HKLocalizedString(@"需要捐款收据"),HKLocalizedString(@"不需要捐款收据")]
    self.receiptSegment = [[UISegmentedControl alloc] initWithItems:@[HKLocalizedString(@"需要捐款收据"),HKLocalizedString(@"不需要捐款收据")]];
    [_receiptSegment setBackgroundImage:[UIImage imageNamed:@"comment_segment_middle_sel"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    self.receiptSegment.tintColor = [UIColor colorWithHexString:@"#6CB92C"];
    [_receiptSegment addTarget:self action:@selector(segmentValueChange:) forControlEvents:UIControlEventValueChanged];
    _receiptSegment.momentary = NO;
    _receiptSegment.tag = kReceiptSegment;
    [_receiptSegment setSelectedSegmentIndex:1];

    [container addSubview:_receiptSegment];
    
    [_receiptSegment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(allPriceBgView.mas_bottom).offset(15);
        make.left.equalTo(container).offset(25);
        make.right.equalTo(container).offset(-25);
        make.height.mas_equalTo(35);
    }];
    
    
    //收据内容，不需要时候隐藏
    _receiptBgView = [UIView new] ;
    _receiptBgView.backgroundColor = [UIColor whiteColor];
    [container addSubview:_receiptBgView];
    
    [_receiptBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_receiptSegment.mas_bottom).offset(20);
        make.left.equalTo(container);
        make.width.equalTo(container);
        make.height.mas_equalTo(65);
    }];
    
    
    UITextField *receiptTextField = [[UITextField alloc] init];
    _receiptField = receiptTextField;
    receiptTextField.placeholder = HKLocalizedString(@"ConfirmView_receiptTextFile");
    receiptTextField.borderStyle = UITextBorderStyleRoundedRect;
    [_receiptBgView addSubview:receiptTextField];
    
    [receiptTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_receiptBgView).offset(5);
        make.left.equalTo(_receiptBgView).offset(25);
        make.right.equalTo(_receiptBgView).offset(-25);
    }];
    
    UILabel *receiptDetailLabel = [UILabel createWithSize:NormalFontSize];
    _receiptDetailLabel = receiptDetailLabel;
    receiptDetailLabel.text = HKLocalizedString(@"ConfirmView_receiptNoteLabel");
    
    receiptDetailLabel.textColor = [UIColor colorWithHexString:@"#666768"];
    [_receiptBgView addSubview:receiptDetailLabel];
    
    [receiptDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(receiptTextField);
        make.top.equalTo(receiptTextField.mas_bottom).offset(5);
    }];
    
    //网上鸣谢
    self.thanksSegment = [[UISegmentedControl alloc] initWithItems:@[HKLocalizedString(@"网上鸣谢"),HKLocalizedString(@"无需鸣谢")]];
    self.thanksSegment.tintColor = [UIColor colorWithHexString:@"#6CB92C"];
    [self.thanksSegment setSelectedSegmentIndex:0];
    _thanksSegment.tag = kThanksSegment;
    [_thanksSegment addTarget:self action:@selector(segmentValueChange:) forControlEvents:UIControlEventValueChanged];
    [container addSubview:_thanksSegment];
    
    [_thanksSegment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_receiptBgView.mas_bottom).offset(15);
        make.left.equalTo(container).offset(25);
        make.right.equalTo(container).offset(-25);
        make.height.mas_equalTo(35);
    }];
    
   
    
    //
    _thanksBgView = [UIView new];
    _thanksBgView.backgroundColor = [UIColor whiteColor];
    [container addSubview:_thanksBgView];
    
    
    [_thanksBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(container);
        make.top.equalTo(_thanksSegment.mas_bottom).offset(20);
        make.width.equalTo(container);
        make.height.mas_equalTo(65);
    }];
    
    //
    UITextField *thanksNameField = [UITextField new];
    _thanksNameField = thanksNameField;
    thanksNameField.placeholder = HKLocalizedString(@"网上鸣谢名称");
    thanksNameField.borderStyle = UITextBorderStyleRoundedRect;
    [_thanksBgView addSubview:thanksNameField];
    
    [thanksNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_thanksBgView).offset(5);
        make.left.equalTo(_thanksBgView).offset(25);
        make.width.equalTo(_thanksSegment).multipliedBy(0.45);
    }];
    
    if([EGLoginTool loginSingleton].isLoggedIn && [[EGLoginTool loginSingleton].currentUser.MemberType isEqualToString:@"C"]){//企业用户
        _thanksSegment.userInteractionEnabled = NO;
        _thanksSegment.enabled = NO;
        
        _thanksNameField.text = [EGLoginTool loginSingleton].currentUser.LoginName;
        _thanksNameField.enabled = NO;
        
        NSString *receiptName = [EGLoginTool loginSingleton].currentUser.CorporationChiName;
        if (receiptName.length<=0 ) {
            receiptName = [EGLoginTool loginSingleton].currentUser.CorporationEngName;
        }
        _receiptField.text = receiptName;
    }else if ([EGLoginTool loginSingleton].isLoggedIn && [[EGLoginTool loginSingleton].currentUser.MemberType isEqualToString:@"P"]){
        _thanksNameField.text = [EGLoginTool loginSingleton].currentUser.LoginName;
        
        NSString *receiptName = [EGLoginTool loginSingleton].currentUser.CorporationChiName;
        if (receiptName.length<=0 ) {
            receiptName = [EGLoginTool loginSingleton].currentUser.CorporationEngName;
        }
        _receiptField.text = receiptName;
    }
    
    //
    UILabel *nameLabel = [UILabel createWithSize:NormalFontSize];
    _nameLabel = nameLabel;
    nameLabel.text = [NSString stringWithFormat:@"(%@)",HKLocalizedString(@"将用作计算累计捐款之用")];
    nameLabel.textColor = [UIColor colorWithHexString:@"#666768"];
    [_thanksBgView addSubview:nameLabel];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(thanksNameField);
        make.top.equalTo(thanksNameField.mas_bottom).offset(5);
    }];
    
    //
    UITextField *thanksEmailField = [UITextField new];
    thanksEmailField.placeholder = HKLocalizedString(@"Register_email");
    thanksEmailField.borderStyle = UITextBorderStyleRoundedRect;
    _emailTextField = thanksEmailField;
    [_thanksBgView addSubview:thanksEmailField];
    
    [thanksEmailField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_thanksBgView).offset(5);
        make.right.equalTo(_thanksBgView).offset(-25);
        make.width.equalTo(_thanksSegment).multipliedBy(0.45);
    }];
    
    //
    UILabel *emailLabel = [UILabel createWithSize:NormalFontSize];
    emailLabel.text = [NSString stringWithFormat:@"(%@)",HKLocalizedString(@"将用作日后联络之用")];
    _emailLabel = emailLabel;
    emailLabel.textColor = [UIColor colorWithHexString:@"#666768"];
    [_thanksBgView addSubview:emailLabel];
    
    [emailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(thanksEmailField);
        make.top.equalTo(thanksEmailField.mas_bottom).offset(5);
    }];
    
    //checkbox
    _confirmInfoCheckBox = [UIButton buttonWithType:UIButtonTypeCustom];
    _confirmInfoCheckBox.selected = NO;
    _confirmInfoCheckBox.tag = kComfirmInfoTag;
    [_confirmInfoCheckBox addTarget:self action:@selector(checkboxClick:) forControlEvents:UIControlEventTouchUpInside];
    [_confirmInfoCheckBox setImage:[UIImage imageNamed:@"cart_checkbox_sel"] forState:UIControlStateSelected];
    [_confirmInfoCheckBox setImage:[UIImage imageNamed:@"cart_checkbox_nor"] forState:UIControlStateNormal];
    [container addSubview:_confirmInfoCheckBox];
    
    
    [_confirmInfoCheckBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(container).offset(25);
        make.top.equalTo(_thanksBgView.mas_bottom).offset(20);
    }];
    
    
    //
    UILabel *infoLabel = [UILabel createWithSize:NormalFontSize];
    infoLabel.text = HKLocalizedString(@"本人确认以上捐款资料准确无误");
    [container addSubview:infoLabel];
    
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_confirmInfoCheckBox.mas_right).offset(10);
        make.centerY.equalTo(_confirmInfoCheckBox);
    }];
    
    
    //
    _confirmStatementCheckBox = [UIButton buttonWithType:UIButtonTypeCustom];
    _confirmStatementCheckBox.selected = NO;
    _confirmStatementCheckBox.tag = kComfirmStatementTag;
    [_confirmStatementCheckBox setImage:[UIImage imageNamed:@"cart_checkbox_sel"] forState:UIControlStateSelected];
    [_confirmStatementCheckBox setImage:[UIImage imageNamed:@"cart_checkbox_nor"] forState:UIControlStateNormal];
    [_confirmStatementCheckBox addTarget:self action:@selector(checkboxClick:) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:_confirmStatementCheckBox];
    
    
    [_confirmStatementCheckBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(container).offset(25);
        make.top.equalTo(_confirmInfoCheckBox.mas_bottom).offset(10);
    }];
    
    //
    NSString *linkStr = HKLocalizedString(@"本人已阅读及清楚明白以上捐款声明,并同意有关善款安排");
    NSRange range = [linkStr rangeOfString:HKLocalizedString(@"donation_remarks")];
    
    NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:linkStr];
    one.yy_font = [UIFont systemFontOfSize:NormalFontSize];
    one.yy_color = [UIColor colorWithHexString:@"#000000"];
    one.yy_underlineColor = [UIColor colorWithHexString:@"#6CB92C"];
    [one yy_setUnderlineStyle:NSUnderlineStyleSingle range:range];
    [one yy_setColor:[UIColor colorWithHexString:@"#6CB92C"] range:range];
    
    YYTextBorder *border = [YYTextBorder new];
    border.cornerRadius = 3;
    border.insets = UIEdgeInsetsMake(0, -4, 0, -4);
    border.fillColor = [UIColor greenColor];
    
    YYTextHighlight *highlight = [YYTextHighlight new];
    [highlight setBorder:border];
    
    
    YYLabel *statementLabel = [YYLabel new];
    _statementLabel = statementLabel;
    statementLabel.frame = (CGRect){55,480+_tableHeight,700,30};
    
    highlight.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {

        EGNoticeViewController *notic = [[EGNoticeViewController alloc] initWithNibName:@"EGNoticeViewController" bundle:nil];
        notic.content = _disclaimer;
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:notic];
        popover.popoverContentSize = CGSizeMake(350, 450);
        
        
        LanguageKey lang = [Language getLanguage];
        if (lang==EN) {
            //[popover presentPopoverFromRect:(CGRect){620,statementLabel.center.y,5,3} inView:self.contentView permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
            
            
            [popover presentPopoverFromRect:(CGRect){360,statementLabel.center.y-_scrollView.contentOffset.y,5,3} inView:self.contentView permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
        }else{
            
            
            [popover presentPopoverFromRect:(CGRect){255,statementLabel.center.y-_scrollView.contentOffset.y,5,3} inView:self.contentView permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
        }
    };
    
    
    
    [one yy_setTextHighlight:highlight range:range];
    
    
    statementLabel.textColor = [UIColor blackColor];
    statementLabel.attributedText = one;
    statementLabel.backgroundColor = [UIColor clearColor];
    [container addSubview:statementLabel];
    
    
    
    [statementLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_confirmStatementCheckBox.mas_right).offset(10);
        make.centerY.equalTo(_confirmStatementCheckBox);
        make.width.mas_equalTo(700);
        make.height.mas_equalTo(30);
    }];
    
    
//    UIView *Redview = [UIView new];
//    Redview.backgroundColor = [UIColor redColor];
//    [container addSubview:Redview];
//    
//    [Redview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(container).offset(25);
//        make.top.equalTo(_confirmStatementCheckBox.mas_bottom).offset(20);
//        make.width.mas_equalTo(200);
//        make.height.mas_equalTo(100);
//    }];
    
    
    //
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(statementLabel.mas_bottom);
    }];
    
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:NormalFontSize],NSFontAttributeName ,nil];
    [_receiptSegment setTitleTextAttributes:dic forState:UIControlStateNormal];
    [_thanksSegment setTitleTextAttributes:dic forState:UIControlStateNormal];
}



#pragma mark 获取购物车数据
-(void)loadData{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    LanguageKey lang = [Language getLanguage];
    
    NSString *cookieId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    EGUserModel *user = [EGLoginTool loginSingleton].currentUser;
    NSString *memberID = @"";
    if (user.MemberID && user.MemberID.length>0) {
        memberID = user.MemberID;
        cookieId = @"";
    }
    
    //是否需要手续费
    BOOL DonateWithCharge = [[NSUserDefaults standardUserDefaults] boolForKey:@"DonateWithCharge"];
    
    
    NSString * soapMsg =[NSString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                         "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                         "<soap:Body>"
                         "<GetAndSaveShoppingCart xmlns=\"egive.appservices\">"
                         "<Lang>%ld</Lang>"
                         "<LocationCode>%@</LocationCode>"
                         "<DonateWithCharge>%d</DonateWithCharge>"
                         "<MemberID>%@</MemberID>"
                         "<CookieID>%@</CookieID>"
                         "<StartRowNo>%i</StartRowNo>"
                         "<NumberOfRows>%i</NumberOfRows>"
                         "</GetAndSaveShoppingCart>"
                         "</soap:Body>"
                         "</soap:Envelope>",lang, @"HK",DonateWithCharge,memberID,cookieId,1,20];
    
    
    [EGDonationModel getCartListWithParams:soapMsg block:^(NSDictionary *dict, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error) {
            
            NSArray *array = dict[@"ItemList"];

            if (![array isEqual: [NSNull null]] && array.count>0) {
                _data = [NSMutableArray array];
                int count = 0;
                _totalPrice = 0;
                for (NSDictionary *dict in array) {
                    EGCartItem *item = [EGCartItem mj_objectWithKeyValues:dict];
                    // update 20160519 add item.DonateAmt>0
                    if (item.IsChecked && item.DonateAmt>0) {
                        count++;
                        _totalPrice = _totalPrice + item.DonateAmt;
                        [_data addObject:item];
                    }
                }
                
                NSString *s = [NSString countNumAndChangeformat:[NSString stringWithFormat:@"%ld",_totalPrice]];
                self.donationTotalPriceLabel.text = [NSString stringWithFormat:@"HK$ %@",s];
                
                self.donationTotalPriceLabel.textColor = [UIColor colorWithHexString:@"#531E7E"];
                _caseCount = count;
                _tableHeight = _caseCount * RowHeight;
                [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(_tableHeight);
                }];
                [_tableView reloadData];
            }
            
        }else{
            
        }
    }];
}


#pragma mark 捐款须知
- (void)getDisclaimer{
    
    
    
    BOOL login = [EGLoginTool loginSingleton].isLoggedIn;
    
    
    NSString *memberID = @"";
    if (login) {
        memberID = [EGLoginTool loginSingleton].currentUser.MemberID;
    }
    
    
    NSString * soapMsg =[NSString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                         "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">"
                         "<soap12:Body>"
                         "<GetShoppingCartDisclaimer xmlns=\"egive.appservices\">"
                         "<Lang>%ld</Lang>"
                         "<LocationCode>%@</LocationCode>"
                         "<MemberID>%@</MemberID>"
                         "</GetShoppingCartDisclaimer>"
                         "</soap12:Body>"
                         "</soap12:Envelope>",[Language getLanguage], @"HK", memberID];
    
    [EGDonationModel getDisclaimerWithParams:soapMsg block:^(NSString *content, NSError *error) {
        
        //
        if (!error) {
            _disclaimer = content;
        }else{
        
        
        }
        
        
    }];
}

#pragma mark - tableview

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return RowHeight;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _data.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EGConfirmCaseCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"EGConfirmCaseCell" owner:self options:nil] lastObject];
    
    EGCartItem *item = _data[indexPath.row];
    
    if (item.IsChecked) {
        cell.leftLabel.text = item.Title;
        NSString *s = [NSString countNumAndChangeformat:[ NSString stringWithFormat:@"%ld",item.DonateAmt]];
        cell.rightLabel.text = [NSString stringWithFormat:@"HK$ %@",s];
    }
   
    
    return cell;
}

@end
