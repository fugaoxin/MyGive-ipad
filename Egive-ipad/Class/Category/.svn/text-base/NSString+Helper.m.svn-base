//
//  NSString+Helper.m
//  QRCode
//
//  Created by apple on 13-12-22.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "NSString+Helper.h"
#import <CoreImage/CoreImage.h>
@implementation NSString (Helper)
/**
 *返回当前字符串对应的二维码图像
 *二维码的实现就是将字符串传递给滤镜，滤镜直接转换生成二维码图片
 **/
-(UIImage *)createRRcode
{
    //1.实例化一个滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //1.1>设置filter的默认值
    //因为之前如果使用过滤镜，输入有可能会被保留，因此，在使用滤镜之前，最好恢复默认设置
    [filter setDefaults];
    
    //2将传入的字符串转换为NSData
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    //3.将NSData传递给滤镜（通过KVC的方式，设置inputMessage）
    [filter setValue:data forKey:@"inputMessage"];
    
    //4.由filter输出图像
    CIImage *outputImage = [filter outputImage];
    
    //5.将CIImage转换为UIImage
    UIImage *qrImage = [UIImage imageWithCIImage:outputImage];

    //6.返回二维码图像
    return [qrImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

#pragma mark - InterpolatedUIImage
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // create a bitmap image that we'll draw into a bitmap context at the desired size;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // Create an image with the contents of our bitmap
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    // Cleanup
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

#pragma mark - QRCodeGenerator
//- (CIImage *)createQRForString:(NSString *)qrString {
//    // Need to convert the string to a UTF-8 encoded NSData object
//    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
//    // Create the filter
//    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
//    // Set the message content and error-correction level
//    [qrFilter setValue:stringData forKey:@"inputMessage"];
//    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
//    // Send the image back
//    return qrFilter.outputImage;
//}

#pragma mark - imageToTransparent
void ProviderReleaseData (void *info, const void *data, size_t size){
    free((void*)data);
}
- (UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue{
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    // create context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    // traverse pixe
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900){
            // change color
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        }else{
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    // context to image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // release
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}



+ (NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString {
    NSRange r;
    while ((r = [JSONString rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound){
        JSONString = [JSONString stringByReplacingCharactersInRange:r withString:@""];
        
    }
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    
    return responseJSON;
}





+(NSString *)countNumAndChangeformat:(NSString *)num{
    int count = 0;
    long long int a = num.longLongValue;
    while (a != 0)    {
        count++;
        a /= 10;
    }
    NSMutableString *string = [NSMutableString stringWithString:num];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 3) {
        count -= 3;
        NSRange rang = NSMakeRange(string.length - 3, 3);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@"," atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    return newstring;
    
}

@end
