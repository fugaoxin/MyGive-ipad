//
//  Language.h
//  HungryKing
//
//  Created by sinogz on 15/9/21.
//  Copyright (c) 2015年 sinogz. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LanguageKey)
{
    HK = 1,
    CN = 2,
    EN = 3
};

@interface Language : NSObject

+ (void)setLanguage:(LanguageKey)lang;
+ (LanguageKey)getLanguage;
+(NSString *)getStringByKey:(NSString*)key;
@end


#define HKLocalizedString(key) [Language getStringByKey:key]