//
//  NSString+RegexKitLite.h
//  Egive
//
//  Created by sino on 15/8/25.
//  Copyright (c) 2015年 sino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegexKitLite.h"
@interface NSString (RegexKitLite)

//用户名
+ (BOOL) validateUserName:(NSString *)name;
//密码
+ (BOOL) validatePassword:(NSString *)passWord;
//确认密码
+ (BOOL) validateConfirmPsw:(NSString *)confirmPsw andPassWord:(NSString *)passWord;
//邮箱
+ (BOOL)isEmail:(NSString *)email;
//姓名
+ (BOOL) validateNickname:(NSString *)nickname;
//判断输入为空
+ (BOOL) isEmpty:(NSString *)NSString andNote:(NSString *)note;

//根据字符串的长度计算高度
+ (CGSize)getUILabelHight:(NSString *)str;

//NSNumber格式化转换为NSString添加千位分隔符
+(NSString*)strmethodComma:(NSString*)string;

//截取XML中的数据
+ (NSString *)captureData:(NSString *)dataString;

//NSString转换成字典
+ (NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString;

//NSString转换成数组
+ (NSArray *)parseJSONStringToNSArray:(NSString *)JSONString;

+ (NSString *)requestApiData:(NSString *)soapMessage;

+ (NSString *)jSONStringToNSDictionary:(NSString *)JSONString;
@end
