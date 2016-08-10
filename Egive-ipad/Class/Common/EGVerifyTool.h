//
//  EGVerifyTool.h
//
//  Created by Kevin on 12-10-23.
//  Copyright (c) 2012年 lrzsone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EGVerifyTool : NSObject

+ (BOOL)validateCard:(NSString *)inputValue;

+ (BOOL)isIP:(NSString *)inputValue;

+ (BOOL)isUrl:(NSString *)inputValue;

+ (BOOL)isCheckInput1:(NSString *)inputValue minLen:(int)minLen maxLen:(int)maxLen;

+ (BOOL)isCheckInput2:(NSString *)inputValue minLen:(int)minLen maxLen:(int)maxLen;

+ (BOOL)isHandset:(NSString *)inputValue;

+ (BOOL)isDecimal:(NSString *)inputValue;

+ (BOOL)isPostalcode:(NSString *)inputValue;

+ (BOOL)isDay:(NSString *)inputValue;

+ (BOOL)isDate:(NSString *)inputValue;

+ (BOOL)isTime:(NSString *)inputValue;

+ (BOOL)isIntNumber:(NSString *)inputValue;

+ (BOOL)isUpChar:(NSString *)inputValue;

+ (BOOL)isLowChar:(NSString *)inputValue;

+ (BOOL)isLetter:(NSString *)inputValue;

+ (BOOL)isLength:(NSString *)inputValue length:(int)length;

+ (BOOL)isChinese:(NSString *)inputValue;


/**
 *  验证会员专区义工日期格式
 *
 *  @param input 日期字符串  yyyy/mm/dd
 *
 *  @return
 */
+(BOOL)isMemberZoneDate:(NSString *)input;

/**
 * 验证输入的内容是否是数字
 */
+ (BOOL)isNumeric:(NSString *)input;

/**
 * 验证输入的内容是否是邮箱地址
 */
+ (BOOL)isEmail:(NSString *)input;

/**
 * 验证输入的内容是否是电话号码
 * ：11位手机码
 */
+ (BOOL)isTelePhone:(NSString *)input;

/**
 * 验证输入的内容是否是电话号码
 * ：固话或区号-固话
 */
+ (BOOL)isPhone:(NSString *)input;

/**
 * 验证输入的内容是否是日期； format参数是日期校验格式如：yyyy-MM-dd
 */
+ (BOOL)isDate:(NSString *)input format:(NSString *)format;

/**
 * 验证字符串是否由字母＋数字组成
 */
+ (BOOL)checkAlphanumeric:(NSString *)input;

/**
 * 验证字符串是否只含有字母、数字或下划线
 */
+ (BOOL)checkGeneral:(NSString *)input;

/**
 * 验证字符串是否为英文26个大小写字母
 */
+ (BOOL)checkEnglish:(NSString *)input;

/**
 * 公共验证方法；根据输入的字符串和匹配模式验证输入的内容
 */
+ (BOOL)commonCheck:(NSString *)input pattern:(NSString *)pattern;

/**
 * 验证身份证号码
 */
+ (BOOL) validateIdentityCard: (NSString *)identityCard;

/**
 * 判断是否是中文或中文加拼音或接音加中文或英文/英文
 */
+ (BOOL)isVerificationCardHolder:(NSString *)string;

/**
 * 判断是否是英文 可带空格
 */
+(BOOL)isVerificationZimu:(NSString *)string;
/**
 * 判断是否是中文 可带空格
 */
+(BOOL)isVerificatioZhongWen:(NSString *)string;

/**
 * 判断是否是中文或中文加拼音或接音加中文
 */
+ (BOOL)isVerificationChinese:(NSString *)string;

/**
 * 判断是否拼音
 */
+ (BOOL)isVerificationPingYin:(NSString *)string;

/**
 * 判断是否拼音或数字
 */
+ (BOOL)isVerificationNumber:(NSString *)string;


@end
