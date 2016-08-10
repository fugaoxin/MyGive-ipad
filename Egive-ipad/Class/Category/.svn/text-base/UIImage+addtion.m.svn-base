//
//  UIImage+addtion.m
//  zw_shop
//
//  Created by Vincent on 15/5/7.
//  Copyright (c) 2015年 zw. All rights reserved.
//

#import "UIImage+addtion.h"

@implementation UIImage (addtion)


+ (UIImage *)imageWithName:(NSString *)name
{
    if (IOS7_OR_LATER) {
        NSString *newName = [name stringByAppendingString:@"_os7"];
        
        // 利用新的文件名加载图片
        UIImage *image = [self imageNamed:newName];
        // 不存在这张图片
        if (image == nil) {
            image = [self imageNamed:name];
        }
        return image;
    } else {
        return [self imageNamed:name];
    }
}

+ (UIImage *)resizedImage:(NSString *)name
{
    return [self resizedImage:name leftScale:0.5 topScale:0.5];
}

+ (UIImage *)resizedImage:(NSString *)name leftScale:(CGFloat)leftScale topScale:(CGFloat)topScale
{
    UIImage *image = [self imageWithName:name];
    
    return [image stretchableImageWithLeftCapWidth:image.size.width * leftScale topCapHeight:image.size.height * topScale];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{

        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        
        UIGraphicsBeginImageContext(rect.size);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context,
                                       
                                       color.CGColor);
        
        CGContextFillRect(context, rect);
        
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();

        return img;
        
}


-(UIImage *)circleImage:(UIImage *)image withParam:(CGFloat)inset{
//    UIGraphicsBeginImageContext(image.size);
    UIGraphicsBeginImageContextWithOptions(image.size, NO, [UIScreen mainScreen].scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 0);
    //为上下文设置anti-aliasing反锯齿是开还是关，anti-aliasing是一个图形状态参数
    CGContextSetShouldAntialias(context, YES);

    
    //为上下文设置Interpolation质量
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    
    
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset * 2.0f, image.size.height - inset * 2.0f);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}


- (UIImage *)yal_imageWithRoundedCornersAndSize:(CGSize)sizeToFit andCornerRadius:(CGFloat)radius
{
    CGRect rect = (CGRect){0.f, 0.f, sizeToFit};
    
    UIGraphicsBeginImageContextWithOptions(sizeToFit, NO, UIScreen.mainScreen.scale);
    CGContextAddPath(UIGraphicsGetCurrentContext(),
                     [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath);
    CGContextClip(UIGraphicsGetCurrentContext());
    
    [self drawInRect:rect];
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return output;
}




@end
