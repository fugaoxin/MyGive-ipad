//
//  MessageViewController.m
//  Egive
//
//  Created by sino on 15/10/16.
//  Copyright (c) 2015年 sino. All rights reserved.
//

#import "MessageViewController.h"
//#import "EGUtility.h"
//#import "AFHTTPRequestOperationManager.h"
//#import "AppDelegate.h"
#import "EGTool.h"
#import "EGUserModel.h"

@interface MessageViewController ()
{

    NSArray * _dataArray;
    
    
    NSMutableDictionary *_pushDict;
}
@property (strong, nonatomic) IBOutlet UISwitch *allSwitch;
- (IBAction)allAction:(id)sender;
@property (strong, nonatomic) IBOutlet UISwitch *proSwitch;//进度报告
- (IBAction)proAction:(id)sender;
@property (strong, nonatomic) IBOutlet UISwitch *actSwitch;//意赠活动
- (IBAction)actAction:(id)sender;
@property (strong, nonatomic) IBOutlet UISwitch *addSwitch;//新增个案
- (IBAction)addAction:(id)sender;

@property (strong, nonatomic) IBOutlet UISwitch *sucSwtich;//成功筹募
- (IBAction)sucAction:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *allLabel;
@property (strong, nonatomic) IBOutlet UILabel *proLabel;
@property (strong, nonatomic) IBOutlet UILabel *actLabel;
@property (strong, nonatomic) IBOutlet UILabel *addLabel;
@property (strong, nonatomic) IBOutlet UILabel *sucLabel;

@property (strong, nonatomic) IBOutlet UILabel *recordLabel;
@property (strong, nonatomic) IBOutlet UISwitch *recordSwtich;

@property (strong, nonatomic) NSMutableArray * statusArray;
@property (strong, nonatomic) NSString * testString;
@property (strong, nonatomic) NSString * tokey;


@property (nonatomic) int flag;
@property (nonatomic) int closeflag;
@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = HKLocalizedString(@"讯息提示");
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithRed:110/255.0 green:49/255.0 blue:139/255.0 alpha:1]}];
    UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftButton.frame = CGRectMake(0, 0, 85,50);
    leftButton.frame = CGRectMake(0, 0, 25,25);
    [leftButton addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
//    [leftButton setBackgroundImage:[UIImage imageNamed:@"ic_header_logo.png"] forState:UIControlStateNormal];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"common_header_back"] forState:UIControlStateNormal];
    
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.navigationItem.rightBarButtonItem = nil;
    _dataArray = @[HKLocalizedString(@"所有提示"),HKLocalizedString(@"进度报告提示"),HKLocalizedString(@"意赠活动提示"),HKLocalizedString(@"新增个案提示"),HKLocalizedString(@"成功筹募提示"),HKLocalizedString(@"捐款记录提示")];
    
    _allLabel.text =HKLocalizedString(@"所有提示");
    _proLabel.text =HKLocalizedString(@"进度报告提示");
    _actLabel.text =HKLocalizedString(@"意赠活动提示");
    _addLabel.text =HKLocalizedString(@"新增个案提示");
    _sucLabel.text =HKLocalizedString(@"成功筹募提示");
    _recordLabel.text = HKLocalizedString(@"捐款记录提示");

    
    
    //
    NSUserDefaults *standardUserDefault = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *pushDict =  [standardUserDefault objectForKey:@"kAllPush"];

    _pushDict = [NSMutableDictionary dictionary];
    _pushDict = [pushDict mutableCopy];
   
    
    if (pushDict.count>=5) {
        [_allSwitch setOn:YES];
    }else{
       [_allSwitch setOn:NO];
        
    }
    

    [self chanagePushStatus];
    
    
    
    
    
//    [pushDict setValue:@"EVENT" forKey:@"kEVENT"];
//    [pushDict setValue:@"CASE" forKey:@"kCASE"];
//    [pushDict setValue:@"CASEUPDATE" forKey:@"kCASEUPDATE"];
//    [pushDict setValue:@"SUCCESS" forKey:@"kSUCCESS"];
//    [pushDict setValue:@"DONATION" forKey:@"kDONATION"];

}



-(void)chanagePushStatus{
    if ([_pushDict.allKeys containsObject:@"kEVENT"]) {
        [_actSwitch setOn:YES];
    }else{
        [_actSwitch setOn:NO];
    }
    
    
    if ([_pushDict.allKeys containsObject:@"kCASE"]) {
        [_addSwitch setOn:YES];
    }else{
        [_addSwitch setOn:NO];
    }
    
    if ([_pushDict.allKeys containsObject:@"kCASEUPDATE"]) {
        [_proSwitch setOn:YES];
    }else{
        [_proSwitch setOn:NO];
    }
    
    
    if ([_pushDict.allKeys containsObject:@"kSUCCESS"]) {
        [_sucSwtich setOn:YES];
    }else{
        [_sucSwtich setOn:NO];
    }
    
    if ([_pushDict.allKeys containsObject:@"kDONATION"]) {
        [_recordSwtich setOn:YES];
    }else{
        [_recordSwtich setOn:NO];
    }
}



- (void)leftAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)regPushPremission
{
    UIApplication* app = [UIApplication sharedApplication];
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [app registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationActivationModeBackground|UIUserNotificationActivationModeForeground| UIUserNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIUserNotificationTypeSound categories:nil]];
    }else{
        //work for ios < 8
        [app registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeNewsstandContentAvailability | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }
}



- (IBAction)allAction:(UISwitch*)sender {
    
    
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *endpointArn = [standardUserDefaults objectForKey:@"GetendpointArn"];
    
    if (sender.isOn) {

        [self showLoadingAlert];
        [EGUserModel changePushMessagePreferenceWithToken:endpointArn param:@"EVENT,CASE,CASEUPDATE,SUCCESS,DONATION" block:^(NSString *result, NSError *error) {
            [self removeLoadingAlert];
            if (!error) {
                //保存开通的push
                NSMutableDictionary *pushDict = [NSMutableDictionary dictionary];
                [pushDict setValue:@"EVENT" forKey:@"kEVENT"];
                [pushDict setValue:@"CASE" forKey:@"kCASE"];
                [pushDict setValue:@"CASEUPDATE" forKey:@"kCASEUPDATE"];
                [pushDict setValue:@"SUCCESS" forKey:@"kSUCCESS"];
                [pushDict setValue:@"DONATION" forKey:@"kDONATION"];
                _pushDict = [pushDict mutableCopy];

                [standardUserDefaults setObject:pushDict forKey:@"kAllPush"];
                [standardUserDefaults synchronize];
                
                
                [self chanagePushStatus];
            }
        }];

    }else{
        
        [self showLoadingAlert];
        [EGUserModel changePushMessagePreferenceWithToken:endpointArn param:@"" block:^(NSString *result, NSError *error) {
            [self removeLoadingAlert];
            if (!error) {
                
                [_pushDict removeAllObjects];
                
                [standardUserDefaults setObject:_pushDict forKey:@"kAllPush"];
                [standardUserDefaults synchronize];
                [self chanagePushStatus];
            }
        }];
        
        
        
    }
    

}


#pragma mark 保存推送的配置，并向服务端发送推送请求
-(void)savePushConfig{

    //
    if (_pushDict.count>=5) {
        [_allSwitch setOn:YES];
    }else{
        [_allSwitch setOn:NO];
    }
    
    
    //
    NSArray *values = [_pushDict allValues];
    NSMutableString *param = [[NSMutableString alloc] init];
    for (NSString *s in values) {
        [param appendFormat:@"%@,",s];
    }
    
    NSRange range = [param rangeOfString:@"," options:NSBackwardsSearch];
    NSString *s = @"";
    if (param.length>0) {
        s = [param substringWithRange:NSMakeRange(0, range.location)];
    }

    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *endpointArn = [standardUserDefaults objectForKey:@"GetendpointArn"];
    [self showLoadingAlert];
    [EGUserModel changePushMessagePreferenceWithToken:endpointArn param:s block:^(NSString *result, NSError *error) {
        [self removeLoadingAlert];
        
        if (!error) {
            //如果设置成功，将推送的配置保存在本地
            [standardUserDefaults setObject:_pushDict forKey:@"kAllPush"];
            [standardUserDefaults synchronize];
        }else{
            DLOG(@"error:%@",error);
        }
    }];
}


//进度报告switch
- (IBAction)proAction:(UISwitch*)sender{
    
    if (sender.isOn) {
        [_pushDict setValue:@"CASEUPDATE" forKey:@"kCASEUPDATE"];
    }else{
        [_pushDict removeObjectForKey:@"kCASEUPDATE"];
    }
    
    [self savePushConfig];
}

//意赠活动switch
- (IBAction)actAction:(UISwitch*)sender {
    if (sender.isOn) {
        [_pushDict setValue:@"EVENT" forKey:@"kEVENT"];
    }else{
        [_pushDict removeObjectForKey:@"kEVENT"];
    }
    [self savePushConfig];
}


//新增个案switch
- (IBAction)addAction:(UISwitch*)sender {
    
    if (sender.isOn) {
        [_pushDict setValue:@"CASE" forKey:@"kCASE"];
    }else{
        [_pushDict removeObjectForKey:@"kCASE"];
    }
    [self savePushConfig];
   
}

//成功筹募switch
- (IBAction)sucAction:(UISwitch*)sender{
    if (sender.isOn) {
        [_pushDict setValue:@"SUCCESS" forKey:@"kSUCCESS"];
    }else{
        [_pushDict removeObjectForKey:@"kSUCCESS"];
    }
    [self savePushConfig];
   
}

//捐款记录switch
- (IBAction)donationction:(UISwitch*)sender {
    if (sender.isOn) {
        [_pushDict setValue:@"DONATION" forKey:@"kDONATION"];
    }else{
        [_pushDict removeObjectForKey:@"kDONATION"];
    }
    [self savePushConfig];
    
}



- (void)showLoadingAlert
{
    [SVProgressHUD show];
}

- (void)removeLoadingAlert
{
    [SVProgressHUD dismiss];
}

@end
