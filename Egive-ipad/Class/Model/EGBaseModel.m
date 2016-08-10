//
//  EGBaseModel.m
//  Egive-ipad
//
//  Created by vincentmac on 15/11/19.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGBaseModel.h"

@implementation EGBaseModel



-(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString {
    NSRange r;
    while ((r = [JSONString rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound){
        JSONString = [JSONString stringByReplacingCharactersInRange:r withString:@""];
        
    }
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    
    return responseJSON;
}


+(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString {
    NSRange r;
    while ((r = [JSONString rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound){
        JSONString = [JSONString stringByReplacingCharactersInRange:r withString:@""];
        
    }
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    
    return responseJSON;
}


+(NSArray *)parseJSONStringToNSArray:(NSString *)JSONString {
    NSRange r;
    while ((r = [JSONString rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound){
        JSONString = [JSONString stringByReplacingCharactersInRange:r withString:@""];
        
    }
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
}

+ (NSString *)captureData:(NSString *)dataString{
    NSRange r;
    while ((r = [dataString rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound){
        dataString = [dataString stringByReplacingCharactersInRange:r withString:@""];
        
    }
    return dataString;
}


@end
