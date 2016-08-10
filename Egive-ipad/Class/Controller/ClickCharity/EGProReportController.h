//
//  EGProReportController.h
//  Egive-ipad
//
//  Created by 123 on 15/12/7.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YQViewController.h"
#import "RegexKitLite.h"
#import "EGShareViewController.h"
#import "MDHTMLLabel.h"
#import "AnyWebViewController.h"

@interface EGProReportController : EGBasePresentViewController

@property (strong, nonatomic) NSArray * dataArray;
@property (strong, nonatomic) NSString * nameString;
@property (strong, nonatomic) NSString * caseId;

@end
