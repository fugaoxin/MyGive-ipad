//
//  EGVerifyTool.m

//  Created by Kevin on 12-10-23.
//  Copyright (c) lrzsone. All rights reserved.
//

#import "EGVerifyTool.h"

const int factor[] = { 7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 };//加权因子
const int checktable[] = { 1, 0, 10, 9, 8, 7, 6, 5, 4, 3, 2 };//校验值对应表

@implementation EGVerifyTool

+ (BOOL)isNumeric:(NSString *)input
{
    return [EGVerifyTool commonCheck:input pattern:@"^\\d+$"];
}

+ (BOOL)isEmail:(NSString *)input
{
//    return [EGVerifyTool commonCheck:input pattern:@"^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+((\\.[a-zA-Z0-9_-]{2,3}){1,2})$"];
    
    return [EGVerifyTool commonCheck:input pattern:@"^([A-Z0-9a-z._%+-])+@([a-zA-Z0-9_-])+((\\.[a-zA-Z0-9_-]{2,3}){1,2})$"];
}

+ (BOOL)isTelePhone:(NSString *)input
{
    return [EGVerifyTool commonCheck:input pattern:@"^1[0-9]{10}$"];
}

+ (BOOL)isPhone:(NSString *)input
{
    return [EGVerifyTool commonCheck:input pattern:@"(^((\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1})|(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1}))$)"];
}

+ (BOOL)isDate:(NSString *)input format:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [formatter setDateFormat:format];
    
    return ([formatter dateFromString:input] != nil);
}

+(BOOL)isMemberZoneDate:(NSString *)input{
    ///^(\d{4})-(0\d{1}|1[0-2])-(0\d{1}|[12]\d{1}|3[01])$/
    
    return [EGVerifyTool commonCheck:input pattern:@"(\\d{4})/(0\\d{1}|1[0-2])/(0\\d{1}|[12]\\d{1}|3[01])"];
    
//     return [EGVerifyTool commonCheck:input pattern:@"(((0[1-9]|[12][0-9]|3[01])/((0[13578]|1[02]))|((0[1-9]|[12][0-9]|30)/(0[469]|11))|(0[1-9]|[1][0-9]|2[0-8])/(02))/([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3}))|(29/02/(([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00)))"];
    
}

+ (BOOL)checkAlphanumeric:(NSString *)input
{
    return [EGVerifyTool commonCheck:input pattern:@"^(([0-9]+[a-zA-Z]+[0-9a-zA-Z]*)|([a-zA-Z]+[0-9]+[0-9a-zA-Z]*))$"];
}

+ (BOOL)checkGeneral:(NSString *)input
{
    return [EGVerifyTool commonCheck:input pattern:@"^([_0-9a-zA-Z]+)$"];
}

+ (BOOL)checkEnglish:(NSString *)input
{
    return [EGVerifyTool commonCheck:input pattern:@"^([a-zA-Z]+)$"];
}

+ (BOOL)commonCheck:(NSString *)input pattern:(NSString *)pattern
{
    if ([input isKindOfClass:[NSString class]] && [pattern isKindOfClass:[NSString class]])
    {
        NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
        return [regular numberOfMatchesInString:input options:0 range:NSMakeRange(0, input.length)];
    }
    
    return NO;
}

+ (BOOL)validateCard:(NSString *)inputValue
{
    return [EGVerifyTool commonCheck:inputValue pattern:@"^(\\d{15}$|^\\d{18}$|^\\d{17}(\\d|X|x))$"];
}

+ (BOOL)isIP:(NSString *)inputValue
{
    return [EGVerifyTool commonCheck:inputValue pattern:@"^(1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|[1-9])\\.(1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|\\d)\\.(1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|\\d)\\.(1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|\\d)$"];
}

+ (BOOL)isUrl:(NSString *)inputValue
{
    return [EGVerifyTool commonCheck:inputValue pattern:@"^(https|http|www|ftp|)?(://)?(\\w+(-\\w+)*)(\\.(\\w+(-\\w+)*))*((:\\d+)?)(/(\\w+(-\\w+)*))*(\\.?(\\w)*)(\\?)?(((\\w*%)*(\\w*\\?)*(\\w*:)*(\\w*\\+)*(\\w*\\.)*(\\w*&)*(\\w*-)*(\\w*=)*(\\w*%)*(\\w*\\?)*(\\w*:)*(\\w*\\+)*(\\w*\\.)*(\\w*&)*(\\w*-)*(\\w*=)*)*(\\w*)*)$"];
}

+ (BOOL)isCheckInput1:(NSString *)inputValue minLen:(int)minLen maxLen:(int)maxLen
{
    if ([inputValue length] >= minLen && [inputValue length] <= maxLen)
    {
        if ([EGVerifyTool commonCheck:inputValue pattern:@"[0-9]"] && [EGVerifyTool commonCheck:inputValue pattern:@"[a-zA-Z]"] && [EGVerifyTool commonCheck:inputValue pattern:@"[_~-.!@#$%^&*()+?><]"])
        {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)isCheckInput2:(NSString *)inputValue minLen:(int)minLen maxLen:(int)maxLen
{
    if ([inputValue length] >= minLen && [inputValue length] <= maxLen)
    {
        return [EGVerifyTool checkAlphanumeric:inputValue];
    }
    return NO;
}

+ (BOOL)isHandset:(NSString *)inputValue
{
    return [EGVerifyTool commonCheck:inputValue pattern:@"^((13[0-9])|(15[^4,\\D])|(18[0,5-9]))\\d{8}$"];
}

+ (BOOL)isDecimal:(NSString *)inputValue
{
    return [EGVerifyTool commonCheck:inputValue pattern:@"\\d+\\.\\d{2}?"];
}

+ (BOOL)isPostalcode:(NSString *)inputValue
{
    return [EGVerifyTool commonCheck:inputValue pattern:@"\\d{6}(-\\d{4})?"];
}

+ (BOOL)isDay:(NSString *)inputValue
{
    return [EGVerifyTool commonCheck:inputValue pattern:@"^((0?[1-9])|((1|2)[0-9])|30|31)$"];
}

+ (BOOL)isDate:(NSString *)inputValue
{
    return [EGVerifyTool commonCheck:inputValue pattern:@"^\\d{4}-(0?[1-9]{1}|1[0-2])-(0?[1-9]{1}|[1-2][0-9]|3[0-1])(\\s([0-1][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9])?$"];
}

+ (BOOL)isTime:(NSString *)inputValue
{
    return [EGVerifyTool commonCheck:inputValue pattern:@"([0-1]?[0-9]|2[0-3]):[0-5]?[0-9]:[0-5]?[0-9]"];
}

+ (BOOL)isIntNumber:(NSString *)inputValue
{
    return [EGVerifyTool commonCheck:inputValue pattern:@"^[0-9]*[1-9][0-9]*$"];
}

+ (BOOL)isUpChar:(NSString *)inputValue
{
    return [EGVerifyTool commonCheck:inputValue pattern:@"^[A-Z]+$"];
}

+ (BOOL)isLowChar:(NSString *)inputValue
{
    return [EGVerifyTool commonCheck:inputValue pattern:@"^[a-z]+$"];
}

+ (BOOL)isLetter:(NSString *)inputValue
{
    return [EGVerifyTool commonCheck:inputValue pattern:@"^[A-Za-z]+$"];
}

+ (BOOL)isLength:(NSString *)inputValue length:(int)length
{
    return [inputValue length] > length ? NO : YES;
}

+ (BOOL)isChinese:(NSString *)inputValue
{
    return [EGVerifyTool commonCheck:inputValue pattern:@"^[\u4E00-\u9FA5]+$"];
}


//判断是否是有效的身份证号码
+(BOOL)checkIDfromchar:(char *)ID
{
    if (StrLength(ID)==18) {//验证18位
        return 0;
    }
    char IDNumber[19];
    for ( int i = 0; i < 18; i ++ )//相当于类型转换
        IDNumber[i] = ID[i] - 48;
    return [self checkID:IDNumber IDchar:ID];
}

+(int)checkID:(char *)IDNumber IDchar:(char *)IDchar
{
    int i = 0;//i为计数
    int checksum = 0;
    for (; i < 17; i ++ )
        checksum += IDNumber[i] * factor[i];
    
    if ( IDNumber[ 17 ] == checktable[ checksum % 11 ] || ( (IDchar[ 17 ] == 'x'||IDchar[ 17 ] == 'X') && checktable[ checksum % 11 ] == 10 ))
        return 1;
    else
        return 0;
}

+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    BOOL result = [identityCardPredicate evaluateWithObject:identityCard];
    if (result) {
        result = [self checkIDfromchar:(char *)[identityCard UTF8String]] != 0;
    }
    return result;
}


+ (BOOL)isNilOrEmptyString:(NSString *)string{
    NSString *nilString = @"null";
    return !string || [string length] <= 0 || [nilString isEqualToString:string];
}

/**
 * 判断是否是中文或中文加拼音或接音加中文
 */
+ (BOOL)isVerificationChinese:(NSString *)string;
{
    if([self isNilOrEmptyString:string]){
        return NO;
    }
    
    NSString *trimmedString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *regex = @"([\u4e00-\u9fa5]+[a-zA-z]+)|([a-zA-z]+[\u4e00-\u9fa5]+)|([\u4e00-\u9fa5]+)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",regex];
    if ([predicate evaluateWithObject:trimmedString] == YES) {
        return YES;
    }
    return NO;
}

//判断是否是英文 空格
+(BOOL)isVerificationZimu:(NSString *)string{
    //判断是否以字母开头
    NSString *ZIMU = @"^[A-Za-z\\s]*$";
    NSPredicate *regextestA = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ZIMU];
    
    if ([regextestA evaluateWithObject:string] == YES)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//判断是否是中文 空格
+(BOOL)isVerificatioZhongWen:(NSString *)string{
    
    NSString *ZhongWen = @"^[\u4e00-\u9fa5\\s]*$";
    NSPredicate *regextestA = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ZhongWen];
    
    if ([regextestA evaluateWithObject:string] == YES)
    {
        return YES;
    }
    else
    {
        return NO;
        
    }
    
}


//判断是否是中文或中文加拼音或接音加中文或英文/英文
+ (BOOL)isVerificationCardHolder:(NSString *)string{
    
    if([self isNilOrEmptyString:string]){
        return NO;
    }
    
    NSString *trimmedString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *regex = @"([\u4e00-\u9fa5]+[a-zA-z]+)|([a-zA-z]+[\u4e00-\u9fa5]+)|([\u4e00-\u9fa5]+)|([a-zA-z]+/[a-zA-z]+)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",regex];
    if ([predicate evaluateWithObject:trimmedString] == YES) {
        return YES;
    }
    return NO;
}

//判断是否拼音
+ (BOOL)isVerificationPingYin:(NSString *)string{
    
    if([self isNilOrEmptyString:string]){
        return NO;
    }
    
    NSString *trimmedString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *regex = @"([a-zA-z]+)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",regex];
    if ([predicate evaluateWithObject:trimmedString] == YES) {
        return YES;
    }
    return NO;
}

//判断是否拼音或数字、拼音加数字、数字加拼音
+ (BOOL)isVerificationNumber:(NSString *)string{
    
    if([self isNilOrEmptyString:string]){
        return NO;
    }
    
    NSString *trimmedString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *regex = @"([a-zA-z]+)|([0-9]+)|([a-zA-z]+[0-9]+)|([0-9]+[a-zA-z]+)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",regex];
    if ([predicate evaluateWithObject:trimmedString] == YES) {
        return YES;
    }
    return NO;
}

@end
