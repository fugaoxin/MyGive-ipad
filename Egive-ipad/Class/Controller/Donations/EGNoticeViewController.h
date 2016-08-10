//
//  EGNoticeViewController.h
//  Egive-ipad
//
//  Created by vincentmac on 15/12/17.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGBaseViewController.h"

@interface EGNoticeViewController : EGBaseViewController


@property (nonatomic,copy) NSString *content;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
