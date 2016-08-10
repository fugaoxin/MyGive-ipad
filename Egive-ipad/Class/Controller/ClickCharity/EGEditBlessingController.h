//
//  EGEditBlessingController.h
//  Egive-ipad
//
//  Created by 123 on 15/12/17.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YQViewController.h"
#import "EGClickCharityModel.h"
#import "PreviewViewController.h"
#import "EGEmojiTextAttachment.h"
#import "NSAttributedString+EmojiExtension.h"

@interface EGEditBlessingController : EGBasePresentViewController
@property (strong, nonatomic) EGClickCharityModel * model;

@property (strong, nonatomic) NSString * disappearStr;

@end
