//
//  Language.m
//  HungryKing
//
//  Created by sinogz on 15/9/21.
//  Copyright (c) 2015年 sinogz. All rights reserved.
//

#import "Language.h"

@implementation Language

+ (void)setLanguage:(LanguageKey)lang
{
    [[NSUserDefaults standardUserDefaults] setFloat:lang forKey:@"Applang"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LanguageChange" object:nil];
}

+ (LanguageKey)getLanguage
{
    LanguageKey lang = [[NSUserDefaults standardUserDefaults] floatForKey:@"Applang"];
    if (lang == 0) {
        return CN;
    }
    return lang;
}

+(NSString *)getStringByKey:(NSString*)key
{
    LanguageKey lang = [Language getLanguage];
    NSString *path;
    if (lang == HK)
        path = [[NSBundle mainBundle] pathForResource:@"EGLocalized_HK" ofType:@"strings"];
    else if (lang == CN)
        path = [[NSBundle mainBundle] pathForResource:@"EGLocalized_CN" ofType:@"strings"];
    else
        path = [[NSBundle mainBundle] pathForResource:@"EGLocalized_EN" ofType:@"strings"];
    
    NSDictionary *localDict = [NSDictionary dictionaryWithContentsOfFile:path];
    if([localDict objectForKey:key]!=nil)
        return [localDict objectForKey:key];
    else
        return key;
}

@end
