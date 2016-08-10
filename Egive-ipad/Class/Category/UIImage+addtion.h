//
//  UIImage+addtion.h
//  zw_shop
//
//  Created by Vincent on 15/5/7.
//  Copyright (c) 2015年 zw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (addtion)


/**
 *  加载项目中的所有图片
 *
 *  @param name 文件名
 *
 *  @return 一个新的图片对象
 */
+ (UIImage *)imageWithName:(NSString *)name;
/**
 *  返回能够自由拉伸不变形的图片
 *
 *  @param name 文件名
 *
 *  @return 能够自由拉伸不变形的图片
 */
+ (UIImage *)resizedImage:(NSString *)name;

/**
 *   返回能够自由拉伸不变形的图片
 *
 *  @param name      文件名
 *  @param leftScale 左边需要保护的比例（0~1）
 */
+ (UIImage *)resizedImage:(NSString *)name leftScale:(CGFloat)leftScale topScale:(CGFloat)topScale;


/**
 *  生成带圆角的图片
 *
 *  @param sizeToFit
 *  @param radius
 *
 *  @return image
 */
- (UIImage *)yal_imageWithRoundedCornersAndSize:(CGSize)sizeToFit andCornerRadius:(CGFloat)radius;


+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;


-(UIImage *)circleImage:(UIImage *)image withParam:(CGFloat)inset;



@end
