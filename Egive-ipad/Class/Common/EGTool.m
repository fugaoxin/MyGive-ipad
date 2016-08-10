//
//  EGTool.m
//  Egive-ipad
//
//  Created by vincentmac on 16/3/4.
//  Copyright © 2016年 Sino. All rights reserved.
//

#import "EGTool.h"

@implementation EGTool


+(BOOL)getIsAllowNotification
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"notification"];
}


+(void)setAllowNotification:(BOOL)setIsAllow
{
    [[NSUserDefaults standardUserDefaults] setBool:setIsAllow forKey:@"notification"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
