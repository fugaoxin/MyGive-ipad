//
//  EGRegisterAllViewController.h
//  Egive-ipad
//
//  Created by sino on 15/11/25.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGBaseViewController.h"
#import "EGBasePresentViewController.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface EGRegisterAllByPushViewController : EGBasePresentViewController

@property (retain, nonatomic)  UIView *switchTabbar;
@property (retain, nonatomic)  UIView *bottomView;

@property (retain, nonatomic)  UIButton* personBtn;
@property (retain, nonatomic)  UIButton* organizaBtn;
@property (retain, nonatomic)  UIButton* commitBtn;

@property (retain, nonatomic)   TPKeyboardAvoidingScrollView *bgPersonScrollView;
@property (retain, nonatomic)   TPKeyboardAvoidingScrollView *bgOrganizaScrollView;

-(void)setUIString;
-(void)getBelongToArr;
@end
