//
//  EGRankModel.m
//  Egive-ipad
//
//  Created by vincentmac on 15/12/1.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGRankModel.h"
#import "EGHttpClient.h"

@implementation EGRankModel



+(void)getRankWithParams:(NSString *)param block:(void (^)(NSArray *, NSError *))block{

    EGHttpClient *client = [EGHttpClient shareClient];

    [client.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return param;
    }];
    
    
    [client POST:@"/appservices/webservice.asmx?wsdl" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSString *response = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
        NSArray *array = [self parseJSONStringToNSArray:response];
        //DLOG(@"jsonDict:%@",array);
        
        
        
        if (array.count<=0) {
            block(nil,nil);
        }else{
//            [EGRankModel mj_setupObjectClassInArray:^NSDictionary *{
//                return @{
//                         @"ItemList" : @"EGRankItem",
//                         };
//            }];
            
            
            NSArray *userArray = [EGRankItem mj_objectArrayWithKeyValuesArray:array];
            block(userArray,nil);
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
    }];
}

+(void)getOtherRankInfoWithParams:(NSString *)param block:(void (^)(NSDictionary *, NSError *))block{
    EGHttpClient *client = [EGHttpClient shareClient];
    
    [client.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return param;
    }];
    
    
    [client POST:@"/appservices/webservice.asmx?wsdl" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSString *response = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *dict = [self parseJSONStringToNSDictionary:response];
        //DLOG(@"jsonDict:%@",dict);
        
        block(dict,nil);
        
       
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLOG(@"error:%@",operation.error);
        block(nil,error);
    }];

}




@end



@implementation EGRankItem



@end
