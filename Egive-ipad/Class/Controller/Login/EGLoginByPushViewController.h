//
//  EGLoginByPushViewController.h
//  Egive-ipad
//
//  Created by sino on 15/11/24.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGBaseViewController.h"
#import <Facebook-iOS-SDK/FBSDKCoreKit/FBSDKCoreKit.h>
#import <Facebook-iOS-SDK/FBSDKLoginKit/FBSDKLoginKit.h>
#import <WeiboSDK/WeiboSDK.h>
#import "YQViewController.h"

@interface EGLoginByPushViewController : YQViewController<WeiboSDKDelegate>

@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (weak, nonatomic) IBOutlet UIImageView *loginBgView;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@property (weak, nonatomic) IBOutlet UITextField *loginTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@property (weak, nonatomic) IBOutlet UIButton *facebookBtn;
@property (weak, nonatomic) IBOutlet UIButton *weiboBtn;


@property (weak, nonatomic) IBOutlet UIButton *termsOfUseBtn;
@property (weak, nonatomic) IBOutlet UIButton *privacyBtn;
@property (weak, nonatomic) IBOutlet UIButton *copyrightBtn;


#pragma mark - weibo delegate
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request;
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response;

@end
