//
//  EGTool.m
//  Egive-ipad
//
//  Created by vincentmac on 15/11/3.
//  Copyright (c) 2015年 Sino. All rights reserved.
//

#import "EGLoginTool.h"
#import <SSKeychain.h>
#import <MJExtension.h>

#define USER_ACCOUNT   @"EGUserName"
#define USER_PASSWORD  @"EGPassWord"
#define USER_ID        @"ID"
#define SERVICE_NAME   @"EGClient"
#define USER_PHOTO     @"Photo"
#define USER_INTERGRATION   @"Integration"

#define BALANCE         @"Balance"
#define USERTYPE         @"UserType"
#define USERLEVEL         @"UserLevel"
#define REALNAME         @"RealName"
#define PHONE           @"Phone"
#define ADDRESS           @"Address"

#define NICKNAME           @"NickName"

@implementation EGLoginTool


+(instancetype)loginSingleton
{
    static EGLoginTool *_tool = nil;
    static dispatch_once_t onceLoginSingleton;
    dispatch_once(&onceLoginSingleton, ^{
        _tool = [[EGLoginTool alloc] init];
    });
    
    return _tool;
}


-(EGUserModel *)currentUser{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict =  [standardUserDefaults objectForKey:@"EGIVE_MEMBER_MODEL"];
    
    if(dict && dict.count>0){
        return [EGUserModel mj_objectWithKeyValues:dict];
    }
    
    return nil;
}


-(NSString *)getAppToken{
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppToken_Dict"];
    
    NSString *token = nil;
    
    if (dict) {
        token = dict[@"AppToken"];
    }
    
    return token;
}

/**
 *  set每个key对应的值
 *
 *  @param value
 *  @param key
 */
- (void)setSecureValue:(NSString *)value forKey:(NSString *)key
{
    if (value) {
        [SSKeychain setPassword:value
                     forService:SERVICE_NAME
                        account:key];
    } else {
        [SSKeychain deletePasswordForService:SERVICE_NAME account:key];
    }
}

/**
 *  get 当前key的value
 *
 *  @param key
 *
 *  @return value
 */
- (NSString *)secureValueForKey:(NSString *)key
{
    return [SSKeychain passwordForService:SERVICE_NAME account:key];
}

-(BOOL)isLoggedIn
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict =  [standardUserDefaults objectForKey:@"EGIVE_MEMBER_MODEL"];
    
    if(dict && dict.count>0){
        return YES;
    }
    
    //这里需要获取token或者其他值，这里暂时没有token，所以后面再扩展
    return NO;
}

- (void)clearSavedContent
{
    //具体清除什么内容，可以依情况而定
    [self setSecureValue:nil forKey:USER_ID];
    [self setSecureValue:nil forKey:USER_ACCOUNT];
    [self setSecureValue:nil forKey:USER_PASSWORD];
    [self setSecureValue:nil forKey:USER_PHOTO];
    [self setSecureValue:nil forKey:USER_INTERGRATION];
    [self setSecureValue:nil forKey:NICKNAME];
}

- (void)setUserAccount:(NSString *)userAccount
{
    [self setSecureValue:userAccount forKey:USER_ACCOUNT];
}

- (NSString *)userAccount
{
    return [self secureValueForKey:USER_ACCOUNT];
}

- (void)setUserID:(NSString *)userID
{
    [self setSecureValue:userID forKey:USER_ID];
}

- (NSString *)userID
{
    return [self secureValueForKey:USER_ID];
}


-(void)setUserPassword:(NSString *)userPassword
{
    [self setSecureValue:userPassword forKey:USER_PASSWORD];
}

- (NSString *)userPassword
{
    return [self secureValueForKey:USER_PASSWORD];
}



- (NSString *)integration
{
    return [self secureValueForKey:USER_INTERGRATION];
}

- (void)setIntegration:(NSString *)integration
{
    [self setSecureValue:integration forKey:USER_INTERGRATION];
}

- (NSString *)photo
{
    return [self secureValueForKey:USER_PHOTO];
}

- (void)setPhoto:(NSString *)photo
{
    [self setSecureValue:photo forKey:USER_PHOTO];
}

- (NSString *)nickName
{
    return [self secureValueForKey:NICKNAME];
}

- (void)setNickName:(NSString *)nickName
{
    [self setSecureValue:nickName forKey:NICKNAME];
}
- (void)setAuthToken:(NSString *)token userAccount:(NSString *)userAccount userPassword:(NSString *)userPassword userID:(NSString *)userID companyID:(NSString *)companyID integration:(NSString *)integration photo:(NSString *)photo
{
    [self setUserAccount:userAccount];
    [self setUserPassword:userPassword];
    [self setUserID:userID];
    [self setIntegration:integration];
    [self setPhoto:photo];
}


-(void)saveAlertDonation:(BOOL)alert{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setBool:alert forKey:kShowAlertDonation];
    [standardUserDefaults synchronize];

}


-(BOOL)getAlertDonation{

    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    BOOL show = [standardUserDefaults boolForKey:kShowAlertDonation];
    return show;
}
@end
