//
//  EGTool.h
//  Egive-ipad
//
//  Created by vincentmac on 15/11/3.
//  Copyright (c) 2015年 Sino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EGUserModel.h"

@interface EGLoginTool : NSObject



/**
 *  创建单例
 *
 *  @return
 */
+ (instancetype)loginSingleton;

/**
 *  检测是否已经登录
 *
 *  @return
 */
- (BOOL)isLoggedIn;


/**
 *  获取当前用户模型
 *
 *  @return
 */
- (EGUserModel *)currentUser;

/**
 *  退出登录的时候，清除保存的内容（如token，需要扩展）
 */
- (void)clearSavedContent;
/**
 *  账号的set和get方法
 *
 *  @return
 */
- (NSString *)userAccount;
- (void)setUserAccount:(NSString *)userAccount;

/**
 *  密码的set和get方法
 *
 *  @return
 */
- (NSString *)userPassword;
- (void)setUserPassword:(NSString *)userPassword;

/**
 *  userID的set和get方法
 *
 *  @return
 */
- (NSString *)userID;
- (void)setUserID:(NSString *)userID;


/**
 *  积分 的set和 get 方法
 *
 *  @return
 */
- (NSString *)integration;
- (void)setIntegration:(NSString *)integration;

/**
 *  头像 的set和 get 方法
 *
 *  @return
 */
- (NSString *)photo;
- (void)setPhoto:(NSString *)photo;

/**
 *  余额 的set和 get 方法
 *
 *  @return
 */
- (NSString *)balance;
- (void)setBalance:(NSString *)balance;

/**
 *  用户类型 的set和 get 方法
 *
 *  @return
 */
- (NSString *)userType;
- (void)setUserType:(NSString *)userType;

/**
 *  用户等级 的set和 get 方法
 *
 *  @return
 */
- (NSString *)userLevel;
- (void)setUserLevel:(NSString *)userLevel;

/**
 *  真实姓名 的set和 get 方法
 *
 *  @return
 */
- (NSString *)realName;
- (void)setRealName:(NSString *)realName;

/**
 *  联系手机 的set和 get 方法
 *
 *  @return
 */
- (NSString *)phone;
- (void)setPhone:(NSString *)phone;

/**
 *  现住地址 的set和 get 方法
 *
 *  @return
 */
- (NSString *)address;
- (void)setAddress:(NSString *)address;

/**
 *  昵称 的set和 get 方法
 *
 *  @return
 */
- (NSString *)nickName;
- (void)setNickName:(NSString *)nickName;

/**
 *  登录成功之后调用这个方法进行保存
 *
 *  @param token        token
 *  @param userAccount  账号
 *  @param userPassword 密码
 *  @param userID       userID
 */
- (void)setAuthToken:(NSString *)token
         userAccount:(NSString *)userAccount
        userPassword:(NSString *)userPassword
              userID:(NSString *)userID
         integration:(NSString *)integration
               photo:(NSString *)photo;



-(NSString *)getAppToken;


//保存弹起购物车标记
-(void)saveAlertDonation:(BOOL) alert;

-(BOOL)getAlertDonation;

@end
