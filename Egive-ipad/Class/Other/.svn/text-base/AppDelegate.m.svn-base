//
//  AppDelegate.m
//  Egive-ipad
//
//  Created by vincentmac on 15/11/3.
//  Copyright (c) 2015年 Sino. All rights reserved.
//

#import "AppDelegate.h"
#import "EGHomeViewController.h"
#import <Facebook-iOS-SDK/FBSDKCoreKit/FBSDKCoreKit.h>
#import <WeiboSDK/WeiboSDK.h>
#import "NSString+Helper.h"
#import "EGLoginTool.h"

//#define Weibo_APP_ID @"3143659811"
//#define Weibo_APP_ID @"4276187362"

//fgx
#import "EGMyTabarViewController.h"
#import "EGFollowCaseViewController.h"
#import "EGMessageCenterViewController.h"
#import "EGAboutGiveViewController.h"
#import "EGClickCharityViewController.h"
#import "EGKindnessRankingViewController.h"
#import "EGGiveInformationViewController.h"
#import "EGShareViewController.h"
#import "EGSettingViewController.h"
#import "MemberFormModel.h"
#import "EGOneSetupController.h"


@interface AppDelegate ()<WeiboSDKDelegate>

@property (strong, nonatomic) EGHomeViewController * home;
@property (strong, nonatomic) EGLoginViewController * login;
@property (strong, nonatomic) EGLoginByPushViewController * pushLogin;
@property (nonatomic,strong) NSString * memberString;//MemberID

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    EGUserModel * UModel=[[EGLoginTool loginSingleton] currentUser];
    if (UModel.MemberID == nil) {
        self.memberString=@"";
    }
    else
    {
        self.memberString=UModel.MemberID;
    }
//    
    EGOneSetupController * HKT=[[EGOneSetupController alloc] init];
    self.window.rootViewController=HKT;
    
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:Weibo_APP_ID];
    
    [self requestMemberFormData];
   
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
//    [FBSDKSettings setAppID:Facebook_URL_SCHEMA];
    [self.window makeKeyAndVisible];

    [self regPushPremission];
    
    
    return YES;
}


-(void)applicationDidBecomeActive:(UIApplication *)application{

    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

#pragma mark - 请求表格数据
-(void)requestMemberFormData{
    
    [MemberFormModel getMemberFormModelData:HK Block:^(NSDictionary *result, NSError *error) {
        
        if (!error) {
            NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
            [standardUserDefaults setObject:result forKey:@"EGIVE_MemberFormModel_1_kevin"];
            [standardUserDefaults synchronize];
        }
        
    }];
    [MemberFormModel getMemberFormModelData:CN Block:^(NSDictionary *result, NSError *error) {
        
        if (!error) {
            NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
            [standardUserDefaults setObject:result forKey:@"EGIVE_MemberFormModel_2_kevin"];
            [standardUserDefaults synchronize];
        }
        
    }];
    [MemberFormModel getMemberFormModelData:EN Block:^(NSDictionary *result, NSError *error) {
        
        if (!error) {
            NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
            [standardUserDefaults setObject:result forKey:@"EGIVE_MemberFormModel_3_kevin"];
            [standardUserDefaults synchronize];
        }
        
    }];
}

//#define Facebook_URL_SCHEMA @"fb751070381705553"

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{

    if ([[[[url absoluteString] componentsSeparatedByString:@"://"] objectAtIndex:0] isEqualToString:@"egive4u"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"isPaySuccessful" object: nil];
    }
    
    if ([[[[url absoluteString] componentsSeparatedByString:@"://"] objectAtIndex:0] isEqualToString:Facebook_URL_SCHEMA]) {
//        NSLog(@"%@://authorize = %@", Facebook_URL_SCHEMA, url);
    }
    
    BOOL fb = [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    
    BOOL wb = [WeiboSDK handleOpenURL:url delegate:self];
    
    return fb || wb;
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WeiboSDK handleOpenURL:url delegate:self ];
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {

}

-(void) application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{

    if (notificationSettings.types) {
        NSLog(@"user allowed notifications");
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
    }else{
        NSLog(@"user did not allow notifications");
        // show alert here
    }
    //[self actionAfterClickPushDialog];
}
-(NSString*)deviceTokenAsString:(NSData*)deviceTokenData{
    NSString *rawDeviceTring = [NSString stringWithFormat:@"%@", deviceTokenData];
    NSString *noSpaces = [rawDeviceTring stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *tmp1 = [noSpaces stringByReplacingOccurrencesOfString:@"<" withString:@""];
    return [tmp1 stringByReplacingOccurrencesOfString:@">" withString:@""];
    
}
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken{
    NSLog(@"deviceToken: %@", deviceToken);
     NSLog(@"deviceTokenSS: %@", [self deviceTokenAsString:deviceToken]);
    [[NSUserDefaults standardUserDefaults] setObject:[self deviceTokenAsString:deviceToken] forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstPushRegister"]){
       [self pushTest];//打印推送的deviceARN
        
    }
    
    
}

- (void)pushTest{
 
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 请求的序列化
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer =  [AFHTTPRequestSerializer serializer];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];

//    [dict setObject:@"arn:aws:sns:us-east-1:819247114127:app/APNS/EGive_APNS_PROD" forKey:@"applicationArn"];
//    [dict setObject:@"arn:aws:sns:us-east-1:819247114127:app/APNS/EGive_iPAD_APNS_PROD" forKey:@"applicationArn"];


    [dict setObject:Arns forKey:@"applicationArn"];
    
    //device Id for iOS
    NSString *deviceid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
//    NSString *deviceid = [OpenUDID value];//938703a5109137ce12a52a76cdc9b4a1d4ac6f77
    NSLog(@"deviceid--------------------%@",deviceid);
    [dict setObject:deviceid forKey:@"deviceid"];
    //token
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if ([standardUserDefaults objectForKey:@"deviceToken"]) {
        [dict setObject:[standardUserDefaults objectForKey:@"deviceToken"] forKey:@"token"];
        NSLog(@"deviceTokendeviceTokendeviceToken====%@",[standardUserDefaults objectForKey:@"deviceToken"]);//<a543e0b1 de29ada5 48d42479 f9ddeef8 227dba54 fe9ec83d e2abc1bd b4d06538>
    }
    //获取设备语言
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *lang = [languages objectAtIndex:0];
    [dict setObject:lang forKey:@"lang"];
    
    //系统版本
    NSString *systemVersion = [[NSBundle mainBundle]
                               
                               objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    [dict setObject:systemVersion forKey:@"systemVersion"];
    
    //platform
    [dict setObject:@"iOS" forKey:@"platform"];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSString *URLstring = [NSString stringWithFormat:@"http://snsfx.sinodynamic.com:8080/sns/register.api"];
    
    [manager POST:URLstring  parameters:dict
          success:^(AFHTTPRequestOperation *operation, id responseObject){
        
              
              [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstPushRegister"];
              
              NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
              NSLog(@"responseObject===%@",dict);
              
              
              NSString *endpointArn = [dict objectForKey:@"endpointArn"];
              
              if(endpointArn.length>0){
                  
                  
                  NSMutableDictionary *tokenDict = [@{@"AppToken":endpointArn} mutableCopy];

                  [[NSUserDefaults standardUserDefaults] setObject:tokenDict forKey:@"AppToken_Dict"];

              }
              
              
              
              NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
              [standardUserDefaults setObject:dict[@"endpointArn"] forKey:@"GetendpointArn"];
              [standardUserDefaults synchronize];
              
              [self registerMobileUser:endpointArn];
//              [self sendAllPush];
              
              
              
              
//              [UIAlertView alertWithText:[dict objectForKey:@"endpointArn"]];

          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              // 服务器给我们返回的包得头部信息
              NSLog(@"failure---%@", operation.response);
//              [UIAlertView alertWithText:@"failure to get Arn"];
          }];
    
    
}


-(void)registerMobileUser:(NSString *)token{
//    NSInteger II = [Language getLanguage];
    NSString * soapMessage =
    [NSString stringWithFormat:
     @"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><RegisterMobileUser xmlns=\"egive.appservices\"><DeviceID>%@</DeviceID><AppLang>%ld</AppLang><AppToken>%@</AppToken></RegisterMobileUser></soap:Body></soap:Envelope>",[OpenUDID value],[Language getLanguage],token];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/appservices/webservice.asmx?wsdl", SITE_URL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    [request addValue: @"text/xml" forHTTPHeaderField:@"Content-Type"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *dataString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSDictionary * dict = [NSString parseJSONStringToNSDictionary:dataString];
        DLOG(@"向服务端注册arn-token完成:%@",dict);
        
        //
        [self changePushMessagePreference:token];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       DLOG(@"向服务端注册arn-token出错:%@",error);
    }];
    
    [operation start];
    
}


-(void)changePushMessagePreference:(NSString *)token{


    NSString * soapMessage =
    [NSString stringWithFormat:
     @"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><ChangePushMessagePreference xmlns=\"egive.appservices\"><MsgPreference>%@</MsgPreference><AppToken>%@</AppToken></ChangePushMessagePreference></soap:Body></soap:Envelope>",@"EVENT,CASE,CASEUPDATE,SUCCESS,DONATION",token];//EVENT,CASE,CASEUPDATE,SUCCESS,DONATION
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/appservices/webservice.asmx?wsdl", SITE_URL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    [request addValue: @"text/xml" forHTTPHeaderField:@"Content-Type"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
       NSString *dataString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        
        //保存开通的push
        NSMutableDictionary *pushDict = [NSMutableDictionary dictionary];
        [pushDict setValue:@"EVENT" forKey:@"kEVENT"];
        [pushDict setValue:@"CASE" forKey:@"kCASE"];
        [pushDict setValue:@"CASEUPDATE" forKey:@"kCASEUPDATE"];
        [pushDict setValue:@"SUCCESS" forKey:@"kSUCCESS"];
        [pushDict setValue:@"DONATION" forKey:@"kDONATION"];
        
        
        
        NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
        [standardUserDefaults setObject:pushDict forKey:@"kAllPush"];
        [standardUserDefaults synchronize];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLOG(@"出错:%@",error);
    }];
    
    [operation start];
}


-(void)sendAllPush{
    dispatch_group_t group =  dispatch_group_create();
    
    
    [self sendAllPush:@"arn:aws:sns:us-east-1:819247114127:EGive_APNS_PROD_PGR" group:group subscriptionArn:@"subscriptionArn1"];
    
    [self sendAllPush:@"arn:aws:sns:us-east-1:819247114127:EGive_APNS_PROD_ACT" group:group subscriptionArn:@"subscriptionArn2"];
    
    [self sendAllPush:@"arn:aws:sns:us-east-1:819247114127:EGive_APNS_PROD_NEW" group:group subscriptionArn:@"subscriptionArn3"];
    
    [self sendAllPush:@"arn:aws:sns:us-east-1:819247114127:EGive_APNS_PROD_REC" group:group subscriptionArn:@"subscriptionArn4"];
    
    dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
        //汇总结果
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            
        });
    });
}

-(void)sendAllPush:(NSString *)topicArn group:(dispatch_group_t) group subscriptionArn:(NSString*)subscriptionArn{
    

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 请求的序列化
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer =  [AFHTTPRequestSerializer serializer];
    // 回复序列化
    //manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    //    NSString * applicationArn = @"arn:aws:sns:us-east-1:819247114127:EGive_APNS_PROD_ACT";
    
    //    [dict setObject:@"arn:aws:sns:us-east-1:819247114127:EGive_APNS_PROD_ACT" forKey:@"topicArn"];
    [dict setObject:topicArn forKey:@"topicArn"];
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if ([standardUserDefaults objectForKey:@"GetendpointArn"]) {
        
        [dict setObject:[standardUserDefaults objectForKey:@"GetendpointArn"] forKey:@"endporintArn"];
      
    }

    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSString *URLstring = [NSString stringWithFormat:@"http://snsfx.sinodynamic.com:8080/sns/subscript.api"];
    
    dispatch_group_enter(group);
    
    [manager POST:URLstring  parameters:dict
          success:^(AFHTTPRequestOperation *operation, id responseObject){
              
              //[self removeLoadingAlert];
              dispatch_group_leave(group);
              
              NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
              
              NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
              [standardUserDefaults setObject:dict[@"subscriptionArn"] forKey:subscriptionArn];
              [standardUserDefaults synchronize];

          }
     
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              //[self removeLoadingAlert];
              dispatch_group_leave(group);

          }];
    
}


- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error{
    
    NSLog(@"Failed to register with error : %@", error);

}
-(void)regPushPremission
{
    UIApplication* app = [UIApplication sharedApplication];
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [app registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil]];
    }
    else
    {
        //work for ios < 8
        [app registerForRemoteNotifications];
    }
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSInteger number = [UIApplication sharedApplication].applicationIconBadgeNumber;
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:number+1];
    
    if (application.applicationState != UIApplicationStateActive) {
        

//        [[NSNotificationCenter defaultCenter] postNotificationName:@"DismissConfirm" object:nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"DismissDonation" object:nil];

//        NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
//        BOOL show = [standardUserDefaults boolForKey:kShowAlertDonation];
        
        BOOL show = [[EGLoginTool loginSingleton] getAlertDonation];

        if (!show) {
            DLOG(@"can't UIApplicationStateActive");
            /**
             e - 意贈活動
             a - 新增個案
             pr - 進度報告
             c - 成功籌募
             d - 捐款記錄
             
             */
            if(([[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] rangeOfString:@"支持意赠"].location==NSNotFound)&&([[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]rangeOfString:@"支持意贈"].location==NSNotFound)&&([[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] rangeOfString:@"Donate Egive"].location==NSNotFound))
            {
                if ([[userInfo objectForKey:@"t"] isEqualToString:@"e"]) {
                    NSDictionary * dic=@{@"CaseID":[userInfo objectForKey:@"e"],
                                         @"MemberID":self.memberString};
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"GiveInformation" object:nil userInfo:@{@"index" : dic}];
                }
                else if ([[userInfo objectForKey:@"t"] isEqualToString:@"a"]){
                    NSDictionary * dic=@{@"CaseID":[userInfo objectForKey:@"c"],
                                         @"MemberID":self.memberString};
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollTitle" object:nil userInfo:@{@"index" : dic}];
                }
                else if ([[userInfo objectForKey:@"t"] isEqualToString:@"pr"]){
                    NSDictionary * dic=@{@"CaseID":[userInfo objectForKey:@"c"],
                                         @"MemberID":self.memberString};
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"progressReport" object:nil userInfo:@{@"index" : dic}];
                }
                else if ([[userInfo objectForKey:@"t"] isEqualToString:@"c"]){
                    NSDictionary * dic=@{@"CaseID":[userInfo objectForKey:@"c"],
                                         @"MemberID":self.memberString};
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollTitle" object:nil userInfo:@{@"index" : dic}];
                }
                else if ([[userInfo objectForKey:@"t"] isEqualToString:@"d"]){
                    NSDictionary * dic=@{@"CaseID":[userInfo objectForKey:@"c"],
                                         @"MemberID":self.memberString};
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollTitle" object:nil userInfo:@{@"index" : dic}];
                }
            }
            else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Support" object:nil userInfo:nil];
            }
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateNewsVolume" object:nil];
        }
        
        
       
    }
}



-(void)setLoginViewController:(EGLoginViewController*)vc
{
    _login = vc;
}
-(void)setPushLoginViewController:(EGLoginByPushViewController*)vc
{
    _pushLogin = vc;
}
-(void)setShareViewController:(EGShareViewController*)vc
{
    _shareVC = vc;
}
-(void)setMyTabarViewController:(EGMyTabarViewController*)vc;{
    _tabarVC = vc;
}

-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    
    return UIInterfaceOrientationMaskLandscapeLeft;
}


#pragma mark - weibo delegate
/**
 收到一个来自微博客户端程序的请求
 
 收到微博的请求后，第三方应用应该按照请求类型进行处理，处理完后必须通过 [WeiboSDK sendResponse:] 将结果回传给微博
 @param request 具体的请求对象
 */
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request{
     NSLog(@"request:%@",request.userInfo);
    if (_login) {
        [_login didReceiveWeiboRequest:request];
    }
    else if (_pushLogin) {
        [_pushLogin didReceiveWeiboRequest:request];
    }
}

/**
 收到一个来自微博客户端程序的响应
 
 收到微博的响应后，第三方应用可以通过响应类型、响应的数据和 WBBaseResponse.userInfo 中的数据完成自己的功能
 @param response 具体的响应对象
 */
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    NSLog(@"response:%@",response.requestUserInfo);
   
    if (_shareVC){
        [_shareVC dismissPopoverReloadUI];
    }
    if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        if (response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
            self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
            if (_login) {
                 [_login didReceiveWeiboResponse:response];
            }
            else if(_pushLogin) {
                [_pushLogin didReceiveWeiboResponse:response];
            }
           
        }
    }
    else if ([response isKindOfClass:WBSendMessageToWeiboResponse.class]){
        
//        if (response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
//            NSString *title = nil;
//            UIAlertView *alert = nil;
//            title = NSLocalizedString(@"收到网络回调", nil);
//            alert = [[UIAlertView alloc] initWithTitle:title
//                                               message:[NSString stringWithFormat:@"%@",response.requestUserInfo]
//                                              delegate:nil
//                                     cancelButtonTitle:NSLocalizedString(@"确定", nil)
//                                     otherButtonTitles:nil];
//            [alert show];
//        }
    }
}


@end
