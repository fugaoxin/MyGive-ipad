//
//  EGHttpClient.m
//  Egive-ipad
//
//  Created by vincentmac on 15/11/19.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGHttpClient.h"


static EGHttpClient *client = nil;

@implementation EGHttpClient


+(instancetype)shareClient{
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        client = [[self alloc] initWithBaseURL:[NSURL URLWithString:SITE_URL]];

        //
        client.responseSerializer = [AFHTTPResponseSerializer serializer];
        [client.requestSerializer setValue:@"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [client.requestSerializer setStringEncoding:NSUTF8StringEncoding];
    });
    
//    NSUInteger count = client.operationQueue.operationCount;
//     DLOG(@"count:%ld",count);
//    if (count>10) {
//        [client.operationQueue cancelAllOperations];
//    }
   
    return client;
}



-(void)EGGET:(NSString *)URLString parameters:(id)parameters block:(ResultBlock)result{
//    [self GET:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        result(responseObject,nil);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        result(nil,error);
//    }];

    
    if (!client) {
        client = [EGHttpClient shareClient];
    }
    
    [client GET:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        result(responseObject,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        result(nil,error);
    }];
    
}





-(instancetype)initWithBaseURL:(NSURL *)url{
    
    if (self = [super initWithBaseURL:url]) {
        self.url = url;
    }
    return self;
}

@end
