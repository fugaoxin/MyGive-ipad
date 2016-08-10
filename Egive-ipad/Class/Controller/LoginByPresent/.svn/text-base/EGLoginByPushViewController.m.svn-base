//
//  EGLoginByPushViewController.m
//  Egive-ipad
//
//  Created by sino on 15/11/24.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGLoginByPushViewController.h"

#import "EGRegisterAllViewController.h"
#import "EGForgotPWByPushViewController.h"
#import "AFNetworking.h"
#import "YQNavigationController.h"
#import "EGPrentAlertViewController.h"
#import "NSString+Helper.h"
#import "NSString+RegexKitLite.h"
#import "EGUserModel.h"
#import <MJExtension/MJExtension.h>
#import "AppDelegate.h"
#import "EGRegisterAlertViewController.h"
#import "MemberFormModel.h"
#import "EGLoginModel.h"
#import "CZPickerView.h"
#import "EGRegisterAllByPushViewController.h"
#import "EGAgreeStatementViewController.h"


#define TermsOfUse @"TermsOfUse"
#define Privacy @"Privacy"
#define Copyright @"Copyright"

@interface EGLoginByPushViewController ()<UITextFieldDelegate>
{
    NSString *wbtoken;
    NSString *wbCurrentUserID;
    NSString *wbRefreshToken;
    
    int offset;
}

@property (copy, nonatomic) NSString * memberId;

@end

@implementation EGLoginByPushViewController


-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
//    [self.navigationBar showLeftItemWithImage:@"common_header_back"];
//    self.title = HKLocalizedString(@"找回密码");
    self.loginTextField.placeholder = HKLocalizedString(@"Login_userName_textFile");
    self.passWordTextField.placeholder = HKLocalizedString(@"Login_passWord_textFile");
    [self.loginBtn setTitle:HKLocalizedString(@"Login_loginButton_title") forState:UIControlStateNormal];
    [self.registerBtn setTitle:HKLocalizedString(@"Login_registerButton_title") forState:UIControlStateNormal];
    [self.facebookBtn setTitle:HKLocalizedString(@"Login_faceBookButton_title") forState:UIControlStateNormal];
    [self.weiboBtn setTitle:HKLocalizedString(@"Login_wbButton_title") forState:UIControlStateNormal];
    [self.termsOfUseBtn setTitle:HKLocalizedString(@"Login_label_title1") forState:UIControlStateNormal];
    [self.privacyBtn setTitle:HKLocalizedString(@"Login_label_title2") forState:UIControlStateNormal];
    [self.copyrightBtn setTitle:HKLocalizedString(@"Login_label_title3") forState:UIControlStateNormal];
    
    [self clearLogType];
    [SVProgressHUD dismiss];
    
    NSDictionary* attDic = @{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#7d7d7d"]};//颜色
    self.loginTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.loginTextField.placeholder attributes:attDic];
    self.passWordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.passWordTextField.placeholder attributes:attDic];
    
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    
    self.loginBtn.backgroundColor = [UIColor colorWithHexString:@"#693290"];
    [self.loginBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.registerBtn.backgroundColor = [UIColor colorWithHexString:@"#6eb92b"];
    [self.registerBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    
    self.facebookBtn.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    [self.facebookBtn setTitleColor:[UIColor colorWithHexString:@"#3b5998"] forState:UIControlStateNormal];
    self.weiboBtn.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    [self.weiboBtn setTitleColor:[UIColor colorWithHexString:@"#cc4242"] forState:UIControlStateNormal];
    
    [self.termsOfUseBtn setTitleColor:[UIColor colorWithHexString:@"#7d7d7d"] forState:UIControlStateNormal];
    [self.privacyBtn setTitleColor:[UIColor colorWithHexString:@"#7d7d7d"] forState:UIControlStateNormal];
    [self.copyrightBtn setTitleColor:[UIColor colorWithHexString:@"#7d7d7d"] forState:UIControlStateNormal];
    
    
    [self.loginBgView setImage:[self getImage]];
//    [self requestMemberFormData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIView* barView = [self createNaviTopBarWithShowBackBtn:YES showTitle:NO];
    barView.backgroundColor = [UIColor whiteColor];
    [self setLoginUI];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.contentView addGestureRecognizer:tap];
    
//    UIButton* cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(27, 20, 25, 31)];
//    [cancelButton setImage:[UIImage imageNamed:@"common_header_back"] forState:UIControlStateNormal];
//    [cancelButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
//    _backButton = cancelButton;
//    [self.view addSubview:_backButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popRegisterVC) name:@"popRegisterVC_kevin" object:nil];
    
   
}
#pragma mark 其他
-(void)setLoginUI{
    
    //
    self.logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.logoImageView.image = [UIImage imageNamed:@"language_logo"];
    
    [self.contentView addSubview:self.logoImageView];
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(30);
        make.centerX.mas_equalTo(self.contentView .mas_centerX);
        make.size.mas_equalTo(CGSizeMake(self.size.width/3,self.size.width/3/3));
    }];
    //用户
    
    self.loginBgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
//    self.loginBgView.image = [UIImage imageNamed:@"comment_input"];
    [self.loginBgView setImage:[self getImage]];
    
    [self.contentView addSubview:self.loginBgView];
    [self.loginBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoImageView.mas_bottom).offset(40);
        make.centerX.mas_equalTo(self.contentView .mas_centerX);
        make.size.mas_equalTo(CGSizeMake(355, 73));
    }];
    
    
    self.loginTextField = [self createTextFild];
    [self.contentView addSubview:self.loginTextField];
    
    self.passWordTextField = [self createTextFild];
    self.passWordTextField.secureTextEntry = YES;
    [self.contentView addSubview:self.passWordTextField];
    
    UIView *line = [UIView new];
    line.backgroundColor =  [UIColor colorWithHexString:@"#B6B6B6"];
    [self.contentView  addSubview:line];
    
    [self.loginTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_loginBgView);
        make.leading.equalTo(_loginBgView).offset(5);
        make.trailing.equalTo(_loginBgView).offset(-5);
    }];
    
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_loginTextField.mas_bottom).offset(1);
        make.leading.equalTo(_loginBgView);
        make.trailing.equalTo(_loginBgView);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.passWordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom);
        make.leading.equalTo(_loginBgView).offset(5);
        make.bottom.equalTo(_loginBgView);
        make.trailing.equalTo(_loginBgView).offset(-5);
        make.height.equalTo(_loginTextField);
    }];
    
    self.forgetBtn = [self createImageButton:[UIImage imageNamed:@"login_forgot_pw"]];
    [self.forgetBtn addTarget:self action:@selector(forgotPassWord:) forControlEvents:UIControlEventTouchUpInside];
    self.forgetBtn.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.forgetBtn];
    [self.forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.passWordTextField);
        make.leading.equalTo(_passWordTextField.mas_trailing).offset(-35);
        make.width.mas_equalTo(35);
        make.height.mas_equalTo(35);
        
    }];
    
    
    self.loginBtn = [[UIButton alloc]init];
     self.loginBtn .layer.cornerRadius = 5;
    [self.loginBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    self.loginBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.loginBtn.backgroundColor = [UIColor colorWithHexString:@"#531E7E"];
    [self.contentView addSubview:self.loginBtn];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_loginBgView.mas_bottom).offset(40);
         make.leading.equalTo(_loginBgView);
        make.trailing.equalTo(_loginBgView);
        make.height.mas_equalTo(35);
        
    }];
    
    self.registerBtn = [[UIButton alloc]init];
    self.registerBtn .layer.cornerRadius = 5;
    self.registerBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.registerBtn addTarget:self action:@selector(registerVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.registerBtn];
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_loginBtn.mas_bottom).offset(15);
        make.leading.equalTo(_loginBtn);
        make.trailing.equalTo(_loginBtn);
        make.height.equalTo(_loginBtn);
    }];
    //
    self.facebookBtn = [self createImageButton:[UIImage imageNamed:@"login_facebook"]];
    [self.facebookBtn setTitleColor:[UIColor colorWithHexString:@"#2E4486"] forState:UIControlStateNormal];
    [self.facebookBtn addTarget:self action:@selector(FacebookLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.facebookBtn];
    [self.facebookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_registerBtn.mas_bottom).offset(40);
        make.leading.equalTo(_registerBtn);
        make.trailing.equalTo(_registerBtn);
        make.height.equalTo(_registerBtn);
    }];
 
    self.weiboBtn = [self createImageButton:[UIImage imageNamed:@"login_sina"]];
    [self.weiboBtn setTitleColor:[UIColor colorWithHexString:@"#F82F38"] forState:UIControlStateNormal];
    [self.weiboBtn addTarget:self action:@selector(wbLogin:) forControlEvents:UIControlEventTouchUpInside];
    
    self.weiboBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -36, 0, 0);
    [self.contentView addSubview:self.weiboBtn];
    [self.weiboBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_facebookBtn.mas_bottom).offset(15);
        make.leading.equalTo(_facebookBtn);
        make.trailing.equalTo(_facebookBtn);
        make.height.equalTo(_facebookBtn);
    }];
//
    self.termsOfUseBtn = [self createButton];
    [self.termsOfUseBtn addTarget:self action:@selector(termsOfUseAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.termsOfUseBtn];
    [self.termsOfUseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_weiboBtn.mas_bottom).offset(80);
        make.leading.equalTo(_weiboBtn);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        
        
    }];
    
    self.privacyBtn = [self createButton];
    [self.privacyBtn addTarget:self action:@selector(privacyAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.privacyBtn];
    [self.privacyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.termsOfUseBtn);
        make.height.mas_equalTo(self.termsOfUseBtn);
        make.width.mas_equalTo(self.termsOfUseBtn);
        make.leading.equalTo(self.termsOfUseBtn.mas_trailing).offset(15);
        
    }];
    
    self.copyrightBtn = [self createButton];
    [self.copyrightBtn addTarget:self action:@selector(copyrightAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.copyrightBtn];
    [self.copyrightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.termsOfUseBtn);
        make.height.mas_equalTo(self.termsOfUseBtn);
        make.width.mas_equalTo(self.termsOfUseBtn);
        make.leading.equalTo(self.privacyBtn.mas_trailing).offset(15);
        make.trailing.equalTo(_weiboBtn);
        
    }];

    UIView *line1 = [UIView new];
    line1.backgroundColor =  [UIColor darkGrayColor];
    [self.contentView  addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.termsOfUseBtn);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(1);
        make.leading.equalTo(self.termsOfUseBtn.mas_trailing).offset(3);
        
    }];
    UIView *line2 = [UIView new];
    line2.backgroundColor =  [UIColor darkGrayColor];
    [self.contentView  addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.termsOfUseBtn);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(1);
        make.leading.equalTo(self.privacyBtn.mas_trailing).offset(3);
        
    }];
//
}

-(UIButton*)createImageButton:(UIImage*)image
{
    UIButton* button =[[UIButton alloc]init];
    button.backgroundColor = [UIColor colorWithHexString:@"#F4F5F6"];
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    [button setImage:image forState:UIControlStateNormal];
    button.layer.cornerRadius = 5;
    return button;
}

-(UIButton*)createButton
{
    UIButton* button =[[UIButton alloc]init];
    button.backgroundColor = [UIColor clearColor];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    return button;
}

-(UITextField*)createTextFild
{
    UITextField* textField =[[UITextField alloc]init];
    textField.backgroundColor = [UIColor clearColor];
    textField.font = [UIFont systemFontOfSize:15];
    textField.borderStyle =  UITextBorderStyleNone;
    textField.delegate = self;
    return textField;
}

-(void)popRegisterVC{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString* loginType = [NSString stringWithFormat:@"%@",[standardUserDefaults objectForKey:@"loginType_registerBack"]];
    if ([loginType isEqualToString:@"facebook"]) {
        [self requestLoginApiData:@"facebook"];
        [standardUserDefaults setObject:@"normal" forKey:@"loginType_registerBack"];
        
    }else if ([loginType isEqualToString:@"weibo"]) {
        [self requestLoginApiData:@"weibo"];
        [standardUserDefaults setObject:@"normal" forKey:@"loginType_registerBack"];
    }
    if ([standardUserDefaults objectForKey:@"loginName_registerBack"]) {
        self.loginTextField.text = [standardUserDefaults objectForKey:@"loginName_registerBack"];
    }
    [standardUserDefaults setObject:@"" forKey:@"loginName_registerBack"];
}

- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

-(UIImage*)getImage{
    UIImage* image = [UIImage imageNamed:@"comment_input"];
    CGFloat top = 5; // 顶端盖高度
    CGFloat bottom = 5 ; // 底端盖高度
    CGFloat left = 5; // 左端盖宽度
    CGFloat right = 5; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    // 指定为拉伸模式，伸缩后重新赋值
    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    return image;
}
-(void)clearLogType{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setObject:@"0" forKey:@"FACEBOOK_REG_REQ"];
    [standardUserDefaults setObject:@"0" forKey:@"WEIBO_REG_REQ"];
    [standardUserDefaults setBool:NO forKey:@"FACEBOOK_Login"];
    [standardUserDefaults setBool:NO forKey:@"WEIBO_Login"];
    [standardUserDefaults setBool:NO forKey:@"NORMAL_Login"];
    [standardUserDefaults synchronize];
}
- (void)tapAction{
    // 关闭键盘
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
}

#pragma mark 返回
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [SVProgressHUD dismiss];
}
#pragma mark 忘记密码
- (IBAction)forgotPassWord:(id)sender {
    
    [self tapAction];
    NSString* showMessage = HKLocalizedString(@"是否通过Email找回密码？");
    NSString* MessageBtnTitle = HKLocalizedString(@"Common_button_confirm");
    [self showMessageVCWithTitle:HKLocalizedString(@"提示") type:@"message_PushForgotVC"  message:showMessage messageButton:MessageBtnTitle];
    
}

#pragma mark 会员登入
- (IBAction)login:(id)sender {
    NSString * logintype = @"normal";
    [self tapAction];
    if (_loginTextField.text.length>0 && _passWordTextField.text.length>0) {
         [self requestLoginApiData:logintype];
    }else{
        [self showMessageVCWithTitle:HKLocalizedString(@"输入错误") type:@"message" message:HKLocalizedString(@"Login_note_title") messageButton:nil];
    }

}

#pragma mark - 请求API,下载解析数据
-(void)requestLoginApiData:(NSString *)loginType{

    NSString *theID = @"";
    NSString *login = @"";
    NSString *password = @"";
    NSUserDefaults *standardUserDefaults  = [NSUserDefaults standardUserDefaults];

    [SVProgressHUD show];
    if ([loginType isEqualToString:@"facebook"]) {
        [standardUserDefaults setBool:YES forKey:@"FACEBOOK_Login"];
        NSDictionary *acc = [standardUserDefaults objectForKey:@"FACEBOOK_DETAIL"];
        theID = [acc objectForKey:@"id"];
    } else if ([loginType isEqualToString:@"weibo"]) {
        [standardUserDefaults setBool:YES forKey:@"WEIBO_Login"];
        NSDictionary *acc = [standardUserDefaults objectForKey:@"WEIBO_DETAIL"];
        theID = [acc objectForKey:@"usid"];
    } else {
        [standardUserDefaults setBool:YES forKey:@"NORMAL_Login"];
        login = _loginTextField.text;
        password = _passWordTextField.text;
    }
 
    NSString * soapMessage =
    [NSString stringWithFormat:
     @"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body> <Login xmlns=\"egive.appservices\"><LoginType>%@</LoginType><LoginName>%@</LoginName><PWD>%@</PWD><ID>%@</ID><AppToken>%@</AppToken><CookieID></CookieID></Login></soap:Body></soap:Envelope>",loginType,login,password, theID,[EGLoginTool loginSingleton].getAppToken];
    
    [EGLoginModel getLoginApiDataWithParams:soapMessage block:^(NSString *result, NSError *error) {
        [SVProgressHUD dismiss];
        if (!error) {
            NSLog(@"requestLoginApiData JSON:%@", result);
            NSDictionary * dict = [NSString parseJSONStringToNSDictionary:result];
            NSString *resultString = [NSString jSONStringToNSDictionary:result];
            
            if ([resultString isEqualToString:@"\"Error(5007)\""] && ([loginType isEqualToString:@"facebook"] || [loginType isEqualToString:@"weibo"])
                ) {
                //跳注册
                [self registerVC:nil];
                
            } else if (dict != nil) {
                _memberId = dict[@"MemberID"];
                [self getMemberInfo:_memberId];
                
            }else{
                if ([resultString isEqualToString:@"\"Error(5008)\""]) {
                    resultString = HKLocalizedString(@"密码错误");
                    
                }
                else if ([resultString isEqualToString:@"\"Error(5007)\""]){
                    resultString = HKLocalizedString(@"未注册的用户");
                }
                else if ([resultString isEqualToString:@"\"Error(1001)\""]){
                    resultString = HKLocalizedString(@"输入错误");
                }
                [self showMessageVCWithTitle:HKLocalizedString(@"提示") type:@"message"  message:resultString messageButton:nil];
            }

        }else{
            [self showMessageVCWithTitle:[NSString stringWithFormat:@"error %@",HKLocalizedString(@"提示")] type:@"message" message:[error.userInfo objectForKey:@"NSLocalizedDescription"]?[error.userInfo objectForKey:@"NSLocalizedDescription"]:@"unknown error" messageButton:nil];
        }
    }];

    
}

//#pragma mark - 请求表格数据
//-(void)requestMemberFormData{
//
//    [MemberFormModel getMemberFormModelDataBlock:^(NSDictionary *result, NSError *error) {
//     
//        if (!error) {
//            NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
//            [standardUserDefaults setObject:result forKey:@"EGIVE_MemberFormModel_kevin"];
//            [standardUserDefaults synchronize];
//        }
//        
//    }];
//}

#pragma mark 获取会员信息
- (void)getMemberInfo:(NSString *)memberId{
    
    [SVProgressHUD show];
    [EGUserModel getMemberInfoDataWithMemberId:memberId block:^(NSDictionary *result, NSError *error) {
        [SVProgressHUD dismiss];
        if (!error) {
//            EGUserModel *model = [EGUserModel mj_objectWithKeyValues:result];
            
            NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
            [standardUserDefaults setObject:result forKey:@"EGIVE_MEMBER_MODEL"];
            [standardUserDefaults synchronize];
            
            [self backAction:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginChange_reloadUI" object:nil];
        }else{
            [self showMessageVCWithTitle:[NSString stringWithFormat:@"error %@",HKLocalizedString(@"提示")] type:@"message"  message:[error.userInfo objectForKey:@"NSLocalizedDescription"]?[error.userInfo objectForKey:@"NSLocalizedDescription"]:@"unknown error" messageButton:nil];
        }
    }];
    
}

#pragma mark 会员注册
- (IBAction)registerVC:(id)sender {

    [self tapAction];
    EGRegisterAllByPushViewController* vc = [[EGRegisterAllByPushViewController alloc]init];
    [vc setContentSize:self.size bgAction:NO animated:NO];
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark Facebook登入
- (IBAction)FacebookLogin:(id)sender {
    [self tapAction];
    EGAgreeStatementViewController* root = [[EGAgreeStatementViewController alloc]init];
    root.title = HKLocalizedString(@"TitleLabel");
    [root setAgreeStatement:^(EGAgreeStatementViewController *vc) {
        
        [vc dismissViewControllerAnimated:YES completion:^{
            //同意声明
            [self loginFacebook];
        }];
        
    }];
    [self presentViewController:root animated:YES completion:nil];

}

-(void)loginFacebook{
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
     [login logOut];//如果用其他账号授权过，先登出
    
    [login
     logInWithReadPermissions: @[@"public_profile"]
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
             [self showMessageVCWithTitle:[NSString stringWithFormat:@"error %@",HKLocalizedString(@"提示")] type:@"message" message:@"Process error" messageButton:nil];
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             NSLog(@"Logged in");
             if ([FBSDKAccessToken currentAccessToken]) {
                 [[NSUserDefaults standardUserDefaults] setObject:[[FBSDKAccessToken currentAccessToken] tokenString  ]forKey:@"FBSDKAccessToken"];
                 [[NSUserDefaults standardUserDefaults] synchronize];
                 NSLog(@"Access Token Activated");
                 
                 NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
                 [parameters setValue:@"id,name,email,gender,picture,first_name,last_name" forKey:@"fields"];
                 [SVProgressHUD show];
                 [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
                  startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                      [SVProgressHUD dismiss];
                      if (!error) {
                          NSLog(@"fetched user:%@", result);
                          NSDictionary *result2 = result;
               
//                          NSString *url = [[[result2 objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];
//                           NSString *url = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [result2 objectForKey:@"id"]];
                          NSString *url = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=1000&height=1000", [result2 objectForKey:@"id"]];
                          
                          NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: url]];
                          NSString *base64 = [UIImagePNGRepresentation([self imageWithImage:[UIImage imageWithData: imageData] convertToSize:CGSizeMake(1000, 1000)]) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//                          NSLog(@"base64 = %@", base64);
                          
                          NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                          [def setObject:@"1" forKey:@"FACEBOOK_REG_REQ"];
                          [def setObject:result2 forKey:@"FACEBOOK_DETAIL"];
                          [def setObject:base64 forKey:@"FACEBOOK_PICTURE"];
                          [def synchronize];
                          
                          [self requestLoginApiData:@"facebook"];
                      }
                      else {
                          [self showMessageVCWithTitle:[NSString stringWithFormat:@"error %@",HKLocalizedString(@"提示")] type:@"message" message:[error.userInfo objectForKey:@"NSLocalizedDescription"]?[error.userInfo objectForKey:@"NSLocalizedDescription"]:@"unknown error" messageButton:nil];
                          NSLog(@"error=%@", error);
                      }
                  }];
                 
             }
         }
     }];
    
}
//#define Weibo_redirectURI @"http://www.sina.com"
#pragma mark 微博登入
- (IBAction)wbLogin:(UIButton *)sender {
    [self tapAction];
    EGAgreeStatementViewController* root = [[EGAgreeStatementViewController alloc]init];
    root.title = HKLocalizedString(@"TitleLabel");
//    root.modalPresentationStyle = UIModalPresentationFormSheet;
    [root setAgreeStatement:^(EGAgreeStatementViewController *vc) {
        //同意声明
        [vc dismissViewControllerAnimated:YES completion:^{
//            [self.yqNavigationController show:NO animated:NO];
            [self loginWeibo];
        }];
        
    }];
    [self presentViewController:root animated:YES completion:nil];
    

}
-(void)loginWeibo{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        AppDelegate *dele = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [dele setPushLoginViewController:self];
        
        WBAuthorizeRequest *request = [WBAuthorizeRequest request];
        request.redirectURI = Weibo_redirectURI;
        request.scope = @"all";
//        request.shouldShowWebViewForAuthIfCannotSSO = NO;//限制只客户端
        request.userInfo = @{@"SSO_From": @"EGLoginByPushViewController",
                             @"Other_Info_1": [NSNumber numberWithInt:123],
                             @"Other_Info_2": @[@"obj1", @"obj2"],
                             @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
        
        [WeiboSDK sendRequest:request];
        
    });
}

#pragma mark 微博 SDK
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    NSLog(@"didReceiveWeiboRequest");
}
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
//        NSString *title = NSLocalizedString(@"认证结果", nil);
        NSString *message = [NSString stringWithFormat:@"%@: %d\nresponse.userId: %@\nresponse.accessToken: %@\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode,[(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken],  NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];
        NSLog(@"WEIBO INFO->%@",message);
        if (response.statusCode == 0) {
            
            self->wbtoken = [(WBAuthorizeResponse *)response accessToken];
            self->wbCurrentUserID = [(WBAuthorizeResponse *)response userID];
            self->wbRefreshToken = [(WBAuthorizeResponse *)response refreshToken];
            
            NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.weibo.com/2/users/show.json?source=%@&access_token=%@&uid=%@", Weibo_APP_ID, self->wbtoken, self->wbCurrentUserID]]];
            NSURLResponse * response = nil;
            NSError * error = nil;
            NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
            
            NSMutableDictionary * innerJson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSString *url = [innerJson objectForKey:@"avatar_large"];
            
            NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: url]];
            NSString *base64 = [UIImagePNGRepresentation([self imageWithImage:[UIImage imageWithData: imageData] convertToSize:CGSizeMake(128, 128)]) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];

            NSMutableDictionary *acc = [NSMutableDictionary dictionary];
            [acc setObject:[innerJson objectForKey:@"name"] forKey:@"userName"];
            [acc setObject:self->wbCurrentUserID forKey:@"usid"];
            [acc setObject:@"" forKey:@"email"];
            [acc setObject:[innerJson objectForKey:@"gender"] forKey:@"gender"];
            // TODO WEIBO EMAIL
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            [def setObject:@"1" forKey:@"WEIBO_REG_REQ"];
            [def setObject:[acc copy] forKey:@"WEIBO_DETAIL"];
            [def setObject:base64 forKey:@"WEIBO_PICTURE"];
            [def synchronize];
            
            [self requestLoginApiData:@"weibo"];
 
        }else{
            [self showMessageVCWithTitle:[NSString stringWithFormat:@"error %@",HKLocalizedString(@"提示")] type:@"message" message:@"AuthorizeResponse error" messageButton:nil];

        }
        
    }
    
}

#pragma mark 使用条款
- (IBAction)termsOfUseAction:(UIButton *)sender {
    [self showVCWithTitle:HKLocalizedString(@"Login_label_title1") type:TermsOfUse];
   
}
#pragma mark 隐私政策
- (IBAction)privacyAction:(UIButton *)sender {
   [self showVCWithTitle:HKLocalizedString(@"Login_label_title2") type:Privacy];
   
}
#pragma mark 版权说明
- (IBAction)copyrightAction:(UIButton *)sender {

    [self showVCWithTitle:HKLocalizedString(@"Login_label_title3") type:Copyright];
    
}

#pragma mark showPopViewVC
-(void)showVCWithTitle:(NSString*)title type:(NSString*)type
{
    EGPrentAlertViewController* root = [[EGPrentAlertViewController alloc]init];
    root.title = title;
    root.type = type;
    root.modalPresentationStyle = UIModalPresentationFormSheet;
   [self presentViewController:root animated:YES completion:nil];

}

-(void)showMessageVCWithTitle:(NSString*)title type:(NSString*)type message:(NSString*)message messageButton:(NSString*)btnTitle
{
    
    
    if ([type isEqualToString:@"message_PushForgotVC"]) {
        CZPickerView *pv = [[CZPickerView alloc] initWithHeaderTitle:title singleButtonTitle:btnTitle singleTapAction:^{
            EGForgotPWByPushViewController * forgotVC = [[EGForgotPWByPushViewController alloc] init];
            [forgotVC setContentSize:self.size bgAction:NO animated:NO];
            [self.navigationController pushViewController:forgotVC animated:YES];
        }];
        pv.headerBackgroundColor = [UIColor colorWithHexString:@"#F4F5F6"];
        pv.headerTitleColor = [UIColor colorWithHexString:@"#673291"];
        pv.cancelButtonBackgroundColor = [UIColor colorWithHexString:@"#5CAF21"];
        pv.cancelButtonNormalColor = [UIColor whiteColor];
        pv.showCloseButton = YES;
        pv.needFooterView = YES;
        [pv setContent:message];
        [pv show];
        return;
    }
    if ([type rangeOfString:@"message"].location != NSNotFound && message) {//是不是message
        CZPickerView *pv = [[CZPickerView alloc] initWithHeaderTitle:title cancelButtonTitle:nil confirmButtonTitle:nil];
        pv.headerBackgroundColor = [UIColor colorWithHexString:@"#F4F5F6"];
        pv.headerTitleColor = [UIColor colorWithHexString:@"#673291"];
        pv.showCloseButton = YES;
        [pv setContent:message];
        [pv show];
        return;
    }

}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
  
    if (textField == _loginTextField) {
        [_passWordTextField becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
        [self login:nil];
    }
    return YES;
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
