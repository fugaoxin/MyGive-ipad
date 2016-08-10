//
//  UIAlertView+addtion.h
//  Egive-ipad
//
//  Created by vincentmac on 15/12/1.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (addtion)


+ (void)alertWithText:(NSString*)format, ...;
+ (void)alertWithText:(NSString *)text title:(NSString*)title;

@end
