//
//  NSString+RegexKitLite.m
//  Egive
//
//  Created by sino on 15/8/25.
//  Copyright (c) 2015年 sino. All rights reserved.
//

#import "NSString+RegexKitLite.h"

static NSString * _dataString;
@implementation NSString (RegexKitLite)

//用户名
+ (BOOL) validateUserName:(NSString *)name
{
    //判断是否以字母开头
    NSString *ZIMU = @"^[A-Za-z0-9\\s]*$";
    NSPredicate *regextestA = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ZIMU];
    
    if ([regextestA evaluateWithObject:name] == YES)
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
//    NSString *userNameRegex = @"^[A-Za-z0-9]{1,20}+$";
//    if (![name isMatchedByRegex:userNameRegex]) {
//        NSLog(@"无效的用户名称");
//        return NO;
//    }
//    return YES;
}
//密码
+ (BOOL) validatePassword:(NSString *)passWord
{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    if (![passWord isMatchedByRegex:passWordRegex])
    {
        //@"无效的密码,请重新输入!"];
        NSLog(@"未通过校验，数据格式有误，请检查！");
        return NO;
    }
    return YES;
}
//确认密码
+ (BOOL) validateConfirmPsw:(NSString *)confirmPsw andPassWord:(NSString *)passWord{
    
    if (![passWord isEqualToString:confirmPsw]) {
        NSLog(@"确认密码与登入密码不一致,请重新输入!");
    }
    return [passWord isEqualToString:confirmPsw];
}

//验证邮箱
+ (BOOL)isEmail:(NSString *)email {
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    if (![email isMatchedByRegex:regex]) {
        NSLog(@"无效的电子邮箱");
        return NO;
    }
    return YES;
}

//昵称
+ (BOOL) validateNickname:(NSString *)nickname
{
    NSString *nicknameRegex = @"^[\u4e00-\u9fa5]{1,8}$";
    if (![nickname isMatchedByRegex:nicknameRegex]) {
        NSLog(@"无效的姓或名,请重新输入!");
        return NO;
    }
    return YES;

}
//判断输入为空
+ (BOOL) isEmpty:(NSString *)NSString andNote:(NSString *)note {
   
    if ([NSString isEqualToString:@""]) {
//        NSLog(
    }
    return [NSString isEqualToString:@""];
}

+ (CGSize)getUILabelHight:(NSString *)str {
    
   CGSize retSize = [str boundingRectWithSize:CGSizeMake(300, CGFLOAT_MAX)                                                                                                                                                             options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin |
                NSStringDrawingUsesFontLeading
                                        attributes:nil context:nil].size;
    return retSize;
}

+(NSString*)strmethodComma:(NSString*)string
{
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior: NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
    NSString *numberString = [numberFormatter stringFromNumber: [NSNumber numberWithInteger:[string integerValue]]];
    return numberString;
    
}

//截取XML中的数据
+ (NSString *)captureData:(NSString *)dataString{
    NSRange r;
    while ((r = [dataString rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound){
        dataString = [dataString stringByReplacingCharactersInRange:r withString:@""];

    }
    return dataString;
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


+ (NSArray *)parseJSONStringToNSArray:(NSString *)JSONString {
    NSRange r;
    while ((r = [JSONString rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound){
        JSONString = [JSONString stringByReplacingCharactersInRange:r withString:@""];
        
    }
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    
    return responseJSON;
    
}

+ (NSString *)requestApiData:(NSString *)soapMessage{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/appservices/webservice.asmx?wsdl",SITE_URL ]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    [request addValue: @"text/xml" forHTTPHeaderField:@"Content-Type"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
     
        _dataString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@",_dataString);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
        // 返回的数据
        NSLog(@"success = %@", error);
    }];
    
    [operation start];
    
    return _dataString;
}
+ (NSString *)jSONStringToNSDictionary:(NSString *)JSONString {
    NSRange r;
    while ((r = [JSONString rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound){
        JSONString = [JSONString stringByReplacingCharactersInRange:r withString:@""];
        
    }
    return JSONString;
}
@end

