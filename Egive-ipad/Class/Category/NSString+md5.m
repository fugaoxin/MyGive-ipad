//
//  NSString+md5.m
//  hello
//
//  Created by iOS开发1 on 15/4/27.
//  Copyright (c) 2015年 iOS开发1. All rights reserved.
//

#import "NSString+md5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (md5)


- (NSString *)MD5 {
    const char *cStr = [self UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}



//- (NSString *)getMd5_32Bit_String:(NSString *)srcString{
//    const char *cStr = [srcString UTF8String];
//    unsigned char digest[CC_MD5_DIGEST_LENGTH];
//    // CC_MD5( cStr, strlen(cStr), digest ); 这里的用法明显是错误的，但是不知道为什么依然可以在网络上得以流传。当srcString中包含空字符（\0）时
//    CC_MD5( cStr, self.length, digest );
//    NSMutableString *result = [NSMutableStringstringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
//    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
//        [result appendFormat:@"%02x", digest[i]];
//    
//    return result;
//}


@end
