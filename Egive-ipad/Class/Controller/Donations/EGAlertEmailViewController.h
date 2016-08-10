//
//  EGAlertEmailViewController.h
//  Egive-ipad
//
//  Created by vincentmac on 16/1/14.
//  Copyright © 2016年 Sino. All rights reserved.
//

#import "EGBaseViewController.h"

typedef void(^EmailDismissBlock)();

@interface EGAlertEmailViewController : EGBaseViewController

@property (nonatomic, copy) EmailDismissBlock dismissBlock;

@end
