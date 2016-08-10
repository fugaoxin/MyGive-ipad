//
//  EGLoginModel.h
//  Egive-ipad
//
//  Created by kevin on 15/12/16.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGBaseModel.h"

@interface EGLoginModel : EGBaseModel

/**
 *  登录接口
 *  接口Login
 *  @return
 */
+(void)getLoginApiDataWithParams:(NSString *)param block:(void (^)(NSString *result,NSError *error)) block;


/**
 *  获取条款、政策、声明等信息
 *  接口GetStaticPageContent
 *  @return
 */
+(void)getStaticPageContentWithFormID:(NSString *)formID block:(void (^)(NSDictionary *result,NSError *error)) block;


/**
 *  忘记密码接口
 *  接口ForgetPassword
 *  @return
 */
+(void)commitForgetPasswordWithFormEmailAddress:(NSString *)emailAddress block:(void (^)(NSString *result,NSError *error)) block;


@end
