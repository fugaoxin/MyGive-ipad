//
//  EGBaseModel.h
//  Egive-ipad
//
//  Created by vincentmac on 15/11/19.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EGBaseModel : NSObject


-(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString;

//请求广告数据
+(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString;

//请求列表数据
+(NSArray *)parseJSONStringToNSArray:(NSString *)JSONString;

//请求收藏数据
+ (NSString *)captureData:(NSString *)dataString;

@end
