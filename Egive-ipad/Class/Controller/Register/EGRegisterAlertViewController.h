//
//  EGRegisterAlertViewController.h
//  Egive-ipad
//
//  Created by sino on 15/12/10.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "YQViewController.h"

@interface EGRegisterAlertViewController : YQViewController
@property (assign,nonatomic) CGSize size;
@property (assign,nonatomic) BOOL notShowLeftItem;
@property (strong,nonatomic) NSString* message;//  message提示
@property (strong,nonatomic) NSString* btnTitle;
@property (copy,nonatomic)void(^messageAction)(EGRegisterAlertViewController *vc);//messageAction 确定按钮
@property (copy,nonatomic)void(^agreeStatement)(EGRegisterAlertViewController *vc);//agreeStatement声明

//
@property (nonatomic,copy) void (^CloseAction)();

@end
