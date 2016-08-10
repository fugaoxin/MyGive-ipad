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
#import "EGBasePresentViewController.h"

@interface EGLoginByPushViewController : EGBasePresentViewController<WeiboSDKDelegate>

//@property (weak, nonatomic)  UIButton *backButton;

@property (retain, nonatomic)  UIImageView *loginBgView;
@property (retain, nonatomic)  UIView *lineView;
@property (retain, nonatomic)  UIImageView *logoImageView;

@property (retain, nonatomic)  UITextField *loginTextField;
@property (retain, nonatomic)  UITextField *passWordTextField;

@property (retain, nonatomic)  UIButton *loginBtn;
@property (retain, nonatomic)  UIButton *forgetBtn;
@property (retain, nonatomic)  UIButton *registerBtn;

@property (retain, nonatomic)  UIButton *facebookBtn;
@property (retain, nonatomic)  UIButton *weiboBtn;


@property (retain, nonatomic)  UIButton *termsOfUseBtn;
@property (retain, nonatomic)  UIButton *privacyBtn;
@property (retain, nonatomic)  UIButton *copyrightBtn;


#pragma mark - weibo delegate
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request;
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response;

@end
