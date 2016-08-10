//
//  UIAlertView+addtion.m
//  Egive-ipad
//
//  Created by vincentmac on 15/12/1.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "UIAlertView+addtion.h"

@implementation UIAlertView (addtion)


+ (void)alertWithText:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    NSString* text = [[NSString alloc] initWithFormat:format arguments:args];
    [self alertWithText:nil title:text];
    va_end(args);
}

+ (void)alertWithText:(NSString *)text title:(NSString *)title {
    UIAlertView* av = [[UIAlertView alloc] initWithTitle:title message:text delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [av show];
}

@end
