//
//  EGHttpClient.h
//  Egive-ipad
//
//  Created by vincentmac on 15/11/19.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"


typedef void(^ResultBlock)(id object,NSError *error);

@interface EGHttpClient : AFHTTPRequestOperationManager


@property (nonatomic,strong) NSURL *url;

+(instancetype)shareClient;



- (void )EGGET:(NSString *)URLString parameters:(id)parameters block:(ResultBlock) result;




@end
