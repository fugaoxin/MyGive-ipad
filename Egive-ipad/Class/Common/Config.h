//
//  Config.h
//  zw
//
//  Created by Vincent on 14-1-11.
//  Copyright (c) 2014年 wujia08@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>


#define IOS7_OR_LATER [[[UIDevice currentDevice]systemVersion]floatValue]>=7.0
#define IOS9_OR_LATER [[[UIDevice currentDevice]systemVersion]floatValue]>=9.0

// Logging
#ifdef DEBUG
#define DLOG(...)       NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)
#define debugObj(obj) NSLog(@"%s:%@", #obj, obj)
#else
#define DLOG(...)
#define debugMethod()
#define debugObj(Obj)
#endif


#define WEAK_VAR(var, obj)  __weak typeof(obj) var = obj

// String
#define EMPTY_STRING        @""
#define LOC_STRING(key)     NSLocalizedString((key), nil)
#define STR_NIL2EMPTY(str)  ((str)?(str):EMPTY_STRING)

// Null
#define NIL2NULL(obj)       ((obj)?(obj):[NSNull null])

// Color
// Use OMColorSence
//#define COLOR_RGBA(r,g,b,a) [UIColor colorWithRed:((float)(r)/255.0f) green:((float)(g)/255.0f) blue:((float)(b)/255.0f) alpha:(a)]
//#define COLOR_RGB(r,g,b)    COLOR_RGBA(r,g,b,1.0f)

#define GrayTextColor  [UIColor colorWithHexString:@"#939393"]
#define MemberZoneTextColor  [UIColor colorWithHexString:@"#7d7d7d"]
#define MemberZoneBlackTextColor  [UIColor colorWithHexString:@"#000000"]

// File System
#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]


#define RESOURCE_FILE(f)    [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:(f)]

// Layout
#define MAIN_SCREEN_BOUNDS          [[UIScreen mainScreen] bounds]
#define MAIN_SCREEN_BOUNDS_WIDTH    MAIN_SCREEN_BOUNDS.size.width
#define MAIN_SCREEN_BOUNDS_HEIGHT   MAIN_SCREEN_BOUNDS.size.height

// Singleton
// Adopt From BeeFramework:https://github.com/gavinkwoe/BeeFramework
#define SINGLETON_DECL(cls, mth)                                                        \
+ (instancetype)mth

#define SINGLETON_IMPL(cls, mth)                                                     \
+ (instancetype)mth {                                                           \
static __typeof__(cls)* __singleton__;                                      \
static dispatch_once_t once;                                                \
dispatch_once( &once, ^{ __singleton__ = [[[self class] alloc] init];});     \
return __singleton__;                                                       \
}


#define WIDTH [UIScreen mainScreen].applicationFrame.size.width  //WIDTH
#define HEIGHT [UIScreen mainScreen].applicationFrame.size.height //HEIGHT
//顏色
#define RGCOLOR(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]
#ifndef UIColorFromRGB
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#endif
#define BG_COLOR 0xefefef

//
#define kServerURLStr @"http://183.237.46.98:809/api"

//
#define SmallFontSize 13
#define NormalFontSize 15


//fgx
#define IS_IPAD     (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define IS_IOS9_AND_UP ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0)
#define IS_IOS8_AND_LOW ([[UIDevice currentDevice].systemVersion floatValue] < 9.0)

#define screenHeight [UIScreen mainScreen].bounds.size.height
#define screenWidth [UIScreen mainScreen].bounds.size.width
#define tabarColor [UIColor colorWithHexString:@"#693290"]
#define greeBar [UIColor colorWithHexString:@"#6eb92b"]
#define graBar [UIColor colorWithHexString:@"#7d7d7d"]
#define yellowBar [UIColor colorWithHexString:@"#ffad22"]
//[UIColor colorWithRed:84/255.0 green:29/255.0 blue:123/255.0 alpha:1]
#define progressBar [UIColor colorWithHexString:@"#cd4f67"]
#define searchTitleColor  [UIColor colorWithHexString:@"#000000"]

// 字体
#define kTitleTextFont [UIFont systemFontOfSize:15]
#define kDescTextFont  [UIFont systemFontOfSize:12]
#define kTitleFontH2   [UIFont systemFontOfSize:16]
#define searchDate @"searchDate"
#define searchStr @"searchStr"

#import "EGMyNvgViewController.h"
#import "Language.h"
#import "EGDataCenter.h"
#import "UIImageView+WebCache.h"
#import "EGLoginTool.h"
#import "EGBasePresentViewController.h"

//#define PRODUCTION_ENV @"PRODUCTION_ENV";
#ifdef PRODUCTION_ENV
#define SITE_URL @"http://www.egive4u.org"
#define Weibo_APP_ID @"1177199632"
#define Weibo_redirectURI @"http://www.egive4u.org/"//@"https://www.egive4u.org/"
#define Facebook_URL_SCHEMA @"fb1526757704220992"//@"fb751070381705553"//@"fb858749344182411"//UAT
#define Arns @"arn:aws:sns:us-east-1:819247114127:app/APNS/EGive_iPAD_APNS_PROD_NEW"
#else
#define SITE_URL @"http://www.egiveforyou.com/"//@"https://www.egiveforyou.com/"
//#define SITE_URL @"http://boose1874uat.ddns.net/"
#define Weibo_APP_ID @"1177199632"
#define Weibo_redirectURI @"http://www.egive4u.org/"//@"https://www.egive4u.org/"
#define Facebook_URL_SCHEMA @"fb858749344182411" //@"fb1526757704220992"//@"fb751070381705553"//UAT
#define Arns @"arn:aws:sns:us-east-1:819247114127:app/APNS_SANDBOX/EGive_iPAD_APNS_UAT"
#endif


#define kDonationAmount @"kDonationAmount"
#define kReceiverAmount @"kReceiverAmount"

#define kCartAddCase @"kCartAddCase"
#define kToKindnessRanking @"kToKindnessRanking"//查看排名跳转伤心排名


#define kShowAlertDonation @"kShowAlertDonation"
#define kDonationCaseList @"kDonationCaseList"

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define EG_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) \
attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;
#else
#define EG_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
sizeWithFont:font constrainedToSize:maxSize lineBreakMode:mode] : CGSizeZero;
#endif


