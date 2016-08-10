//
//  UILabel+StringFrame.m
//  Egive-ipad
//
//  Created by 123 on 16/1/27.
//  Copyright © 2016年 Sino. All rights reserved.
//

#import "UILabel+StringFrame.h"

@implementation UILabel (StringFrame)

-(CGSize)boundingRectWithSize:(CGSize)size
{
    NSDictionary *attribute = @{NSFontAttributeName: self.font};
    
    CGSize retSize = [self.text boundingRectWithSize:size
                                             options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;
    
    return retSize;
}

@end
