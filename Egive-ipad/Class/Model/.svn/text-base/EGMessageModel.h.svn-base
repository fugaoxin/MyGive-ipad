//
//  EGMessageModel.h
//  Egive-ipad
//
//  Created by kevin on 16/1/13.
//  Copyright © 2016年 Sino. All rights reserved.
//

#import "EGBaseModel.h"

@interface EGMessageModel : EGBaseModel

@property (nonatomic, copy) NSString *MsgID;
@property (nonatomic, copy) NSString *MsgTp;
@property (nonatomic, copy) NSString *Title;
@property (nonatomic, copy) NSString *Msg;
@property (nonatomic, copy) NSString *ImageFilePath;
@property (nonatomic, copy) NSString *RefID;


/**
 *  訊息中心 注册这台设备 接口
 *  接口RegisterMobileUser
 *  @return
 */
+ (void)registerMobileUserWithAppToken:(NSString *)AppToken block:(void (^)(NSArray *results, NSError *error))block;
/**
 *  訊息中心 接口
 *  接口GetMailBoxMsg
 *  @return
 */
+ (void)getMailBoxMsgWithMsgTp:(NSString *)MsgTp block:(void (^)(NSArray *results, NSError *error))block;


@end
