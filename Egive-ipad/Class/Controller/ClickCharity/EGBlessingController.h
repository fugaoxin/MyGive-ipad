//
//  EGBlessingController.h
//  Egive-ipad
//
//  Created by 123 on 15/12/8.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YQViewController.h"
#import "EGBlessingModel.h"
#import "RegexKitLite.h"
#import "EGClickCharityModel.h"
#import "EGHomeModel.h"

@interface EGBlessingController : EGBasePresentViewController

@property (strong, nonatomic) EGClickCharityModel * model;

@property (copy, nonatomic) NSString * caseID;
@property (copy, nonatomic) NSString * memberID;

@end
