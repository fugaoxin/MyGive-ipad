//
//  EGLoginByPushViewController.m
//  Egive-ipad
//
//  Created by sino on 15/11/24.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGLoginByPushViewController.h"

#import "EGRegisterViewController.h"
#import "EGForgotPWViewController.h"
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

#import "EGAgreeStatementViewController.h"
#define TermsOfUse @"TermsOfUse"
#define Privacy @"Privacy"
#define Copyright @"Copyright"

@interface EGLoginByPushViewController ()
{
    NSString *wbtoken;
    NSString *wbCurrentUserID;
    NSString *wbRefreshToken;
    
    int offset;
}

@property (copy, nonatomic) NSString * memberId;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewHeight;

@end

@implementation EGLoginByPushViewController


-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
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
    
    [self.loginBgView setImage:[self getImage]];
    self.lineViewHeight.constant = 0.5;
    [self requestMemberFormData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
    
    UIButton* cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(27, 20, 25, 31)];
    [cancelButton setImage:[UIImage imageNamed:@"common_header_back"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    _backButton = cancelButton;
    [self.view addSubview:_backButton];
    
     self.registerBtn.backgroundColor = [UIColor colorWithHexString:@"#5CAF21"];
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString* loginType = [NSString stringWithFormat:@"%@",[standardUserDefaults objectForKey:@"loginType_registerBack"]];
    if ([loginType isEqualToString:@"facebook"]) {
        [self requestLoginApiData:@"facebook"];
        
    }else if ([loginType isEqualToString:@"weibo"]) {
        [self requestLoginApiData:@"weibo"];
    }
    if ([standardUserDefaults objectForKey:@"loginName_registerBack"]) {
        self.loginTextField.text = [standardUserDefaults objectForKey:@"loginName_registerBack"];
    }
    [standardUserDefaults setObject:@"" forKey:@"loginName_registerBack"];
}

#pragma mark 其他
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
    [standardUserDefaults synchronize];
}
- (void)tapAction{
    // 关闭键盘
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
}

#pragma mark 返回
- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
    
    [SVProgressHUD show];
    if ([loginType isEqualToString:@"facebook"]) {
        NSUserDefaults *standardUserDefaults  = [NSUserDefaults standardUserDefaults];
        NSDictionary *acc = [standardUserDefaults objectForKey:@"FACEBOOK_DETAIL"];
        theID = [acc objectForKey:@"id"];
    } else if ([loginType isEqualToString:@"weibo"]) {
        NSUserDefaults *standardUserDefaults  = [NSUserDefaults standardUserDefaults];
        NSDictionary *acc = [standardUserDefaults objectForKey:@"WEIBO_DETAIL"];
        theID = [acc objectForKey:@"usid"];
    } else {
        login = _loginTextField.text;
        password = _passWordTextField.text;
    }
 
    NSString * soapMessage =
    [NSString stringWithFormat:
     @"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body> <Login xmlns=\"egive.appservices\"><LoginType>%@</LoginType><LoginName>%@</LoginName><PWD>%@</PWD><ID>%@</ID><AppToken></AppToken><CookieID></CookieID></Login></soap:Body></soap:Envelope>",loginType,login,password, theID];
    
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
            [self showMessageVCWithTitle:[NSString stringWithFormat:@"error %@",HKLocalizedString(@"提示")] type:@"message" message:[error.userInfo objectForKey:@"NSLocalizedDescription"] messageButton:nil];
        }
    }];

    
}

#pragma mark - 请求表格数据
-(void)requestMemberFormData{

    [MemberFormModel getMemberFormModelDataBlock:^(NSDictionary *result, NSError *error) {
     
        if (!error) {
            NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
            [standardUserDefaults setObject:result forKey:@"EGIVE_MemberFormModel_kevin"];
            [standardUserDefaults synchronize];
        }
        
    }];
}

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
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginChange_ByVC" object:nil];
        }else{
            [self showMessageVCWithTitle:[NSString stringWithFormat:@"error %@",HKLocalizedString(@"提示")] type:@"message"  message:[error.userInfo objectForKey:@"NSLocalizedDescription"] messageButton:nil];
        }
    }];
    
}

#pragma mark 会员注册
- (IBAction)registerVC:(id)sender {

    [self tapAction];
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter  defaultCenter] postNotificationName:@"goRegisterVC_kevin" object:nil];
    
}
#pragma mark Facebook登入
- (IBAction)FacebookLogin:(id)sender {
    [self tapAction];
    EGAgreeStatementViewController* root = [[EGAgreeStatementViewController alloc]init];
    root.title = HKLocalizedString(@"TitleLabel");
//    root.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:root animated:YES completion:nil];
//    [self showMessageVCWithTitle:HKLocalizedString(@"TitleLabel") type:@"facebook" message:nil messageButton:nil];
}

-(void)loginFacebook{
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    
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
               
                          NSString *url = [[[result2 objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];
                          
                          NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: url]];
                          NSString *base64 = [UIImagePNGRepresentation([self imageWithImage:[UIImage imageWithData: imageData] convertToSize:CGSizeMake(128, 128)]) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                          NSLog(@"base64 = %@", base64);
                          
                          NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                          [def setObject:@"1" forKey:@"FACEBOOK_REG_REQ"];
                          [def setObject:result2 forKey:@"FACEBOOK_DETAIL"];
                          [def setObject:base64 forKey:@"FACEBOOK_PICTURE"];
                          [def synchronize];
                          
                          [self requestLoginApiData:@"facebook"];
                      }
                      else {
                          [self showMessageVCWithTitle:[NSString stringWithFormat:@"error %@",HKLocalizedString(@"提示")] type:@"message" message:[error.userInfo objectForKey:@"NSLocalizedDescription"] messageButton:nil];
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
    [self presentViewController:root animated:YES completion:nil];
//    [self showMessageVCWithTitle:HKLocalizedString(@"TitleLabel") type:@"weibo" message:nil messageButton:nil];
}
-(void)loginWeibo{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        AppDelegate *dele = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [dele setLoginViewController:self];
        
        WBAuthorizeRequest *request = [WBAuthorizeRequest request];
        request.redirectURI = Weibo_redirectURI;
        request.scope = @"all";
        request.userInfo = @{@"SSO_From": @"LoginViewController",
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
    [self showVCWithTitle:HKLocalizedString(@"Login_label_title3") type:TermsOfUse];
   
}
#pragma mark 隐私政策
- (IBAction)privacyAction:(UIButton *)sender {
   [self showVCWithTitle:HKLocalizedString(@"Login_label_title3") type:Privacy];
   
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
   [self presentViewController:root animated:YES completion:^{
       
   }];

}

-(void)showMessageVCWithTitle:(NSString*)title type:(NSString*)type message:(NSString*)message messageButton:(NSString*)btnTitle
{
    
    
    if ([type isEqualToString:@"message_PushForgotVC"]) {
        CZPickerView *pv = [[CZPickerView alloc] initWithHeaderTitle:title singleButtonTitle:btnTitle singleTapAction:^{
            EGForgotPWViewController * forgotVC = [[EGForgotPWViewController alloc] init];
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
    
    
    
    
    CGSize size = CGSizeMake(WIDTH-450, HEIGHT-350);
    if ([type rangeOfString:@"message"].location != NSNotFound && message) {//是不是message
        size = CGSizeMake(WIDTH-500, 200);
        if (btnTitle) {
            size = CGSizeMake(WIDTH-500, 200+40);
        }
    }
    EGRegisterAlertViewController* root = [[EGRegisterAlertViewController alloc]init];
    root.size = size;
    root.title = title;
    root.message = message;
    root.btnTitle = btnTitle;
    
    [root setMessageAction:^(EGRegisterAlertViewController *vc) {
        if ([type isEqualToString:@"message_PushForgotVC"]) {
            EGForgotPWViewController * forgotVC = [[EGForgotPWViewController alloc] init];
            [self.navigationController pushViewController:forgotVC animated:YES];
        }
    }];
    [root setAgreeStatement:^(EGRegisterAlertViewController *vc) {
        //同意声明
        if ([type isEqualToString:@"facebook"]) {
            [self loginFacebook];
        }else if([type isEqualToString:@"weibo"]){
            [self loginWeibo];
        }
        
    }];
    YQNavigationController *nav = [[YQNavigationController alloc] initWithSize:size rootViewController:root];
    nav.touchSpaceHide = YES;//点击没有内容的地方消失
    nav.panPopView = YES;//滑动返回上一层视图
    [nav show:YES animated:YES];
}

#pragma mark - UITextFieldDelegate
-(void)returnFrame{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    _backButton.frame=CGRectMake(27, 20, 25, 31);
    [UIView commitAnimations];
}

//解决虚拟键盘挡住UITextField的方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self returnFrame];
    if (textField == _loginTextField) {
        [_passWordTextField becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
        [self login:nil];
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    [self returnFrame];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    frame = [textField.superview convertRect:frame toView:self.view];
    
    offset = frame.origin.y - (self.view.frame.size.height - 398 - 80);//键盘高度398;
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    if(offset > 0)
    {
        CGRect rect = CGRectMake(0.0f, -offset,width,height);
        self.view.frame = rect;
        _backButton.frame=CGRectMake(27, 20+offset, 25, 31);
    }
    [UIView commitAnimations];
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
