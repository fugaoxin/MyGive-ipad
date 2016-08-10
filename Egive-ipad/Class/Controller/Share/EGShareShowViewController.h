//
//  EGShareShowViewController.h
//  Egive-ipad
//
//  Created by kevin on 15/12/25.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGBaseViewController.h"
#import "WhatsAppKit.h"

@interface EGShareShowViewController : EGBaseViewController
@property (assign,nonatomic) CGSize size;

@property (copy,nonatomic)void(^buttonAction)(NSString *type);//acancel

@end
