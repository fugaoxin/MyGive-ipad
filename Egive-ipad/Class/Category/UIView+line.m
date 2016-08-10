//
//  UIView+line.m
//  HKGTA
//
//  Created by vincentmac on 15/8/18.
//  Copyright (c) 2015年 香港. All rights reserved.
//

#import "UIView+line.h"

@implementation UIView (line)


+(instancetype)normalLine{
    UIView *line = [UIView new];
//    line.backgroundColor = [UIColor colorWithHexString:@"#C9BEAC"];
    line.backgroundColor = [UIColor colorWithHexString:@"#E9EAEC"];
//    line.layer.opacity = 0.5;
    line.frame = (CGRect){0,0,WIDTH,1.5};
    
    return line;
}



+(instancetype)createLineWithColor:(UIColor *)color{
    UIView *line = [UIView new];
    
    line.backgroundColor = color;
   
    line.frame = (CGRect){0,0,WIDTH,1.5};
    
    return line;

}
@end
