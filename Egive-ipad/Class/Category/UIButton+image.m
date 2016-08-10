//
//  UIButton+image.m
//  zw_shop
//
//  Created by iOS开发1 on 15/5/20.
//  Copyright (c) 2015年 zw. All rights reserved.
//

#import "UIButton+image.h"

@implementation UIButton (image)

+(UIButton *)buttonWithImage:(NSString *)imageName{
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (imageName) {
        [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        
    }
    
    
    
    return btn;
}

@end
