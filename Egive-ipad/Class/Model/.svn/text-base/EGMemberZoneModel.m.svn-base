//
//  EGMemberZoneModel.m
//  Egive-ipad
//
//  Created by vincentmac on 15/12/28.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGMemberZoneModel.h"
#import "EGHttpClient.h"
#import "NSString+RegexKitLite.h"

@implementation EGMemberZoneModel



+(void)getPersonInfoWithParams:(NSString *)param block:(void (^)(EGMemberInfo *, NSError *))block{

    
    EGHttpClient *client = [EGHttpClient shareClient];
    
    [client.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return param;
    }];
    
    
    [client POST:@"/appservices/webservice.asmx?wsdl" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSString *response = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
        
       
        
        NSDictionary *jsonDict = [self parseJSONStringToNSDictionary:response];
        DLOG(@"jsonDict:%@",jsonDict);
        
       
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
    }];
}



+(void)getCompanyInfoWithParams:(NSString *)param block:(void (^)(EGMemberInfo *, NSError *))block{

    
    EGHttpClient *client = [EGHttpClient shareClient];
    
    [client.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return param;
    }];
    
    
    [client POST:@"/appservices/webservice.asmx?wsdl" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSString *response = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
        NSArray *array = [self parseJSONStringToNSArray:response];
        DLOG(@"jsonDict:%@",array);
        
        if(array.count>0){
            NSDictionary *dict = array[0];
            
            EGMemberInfo *info = [EGMemberInfo mj_objectWithKeyValues:dict];
            block(info,nil);
        }else{
        
            block(nil,nil);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
    }];
}


+(void)getCompanySelectionsWithParams:(NSString *)param block:(void (^)(NSDictionary *, NSError *))block{

    EGHttpClient *client = [EGHttpClient shareClient];
    
    [client.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return param;
    }];
    
    
    [client POST:@"/appservices/webservice.asmx?wsdl" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSString *response = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *jsonDict = [self parseJSONStringToNSDictionary:response];
        //DLOG(@"jsonDict:%@",array);
        block(jsonDict,nil);

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
    }];
}


+(void)updateMemberWithParams:(NSString *)param block:(void (^)(NSString *, NSError *))block{

    EGHttpClient *client = [EGHttpClient shareClient];
    
    [client.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return param;
    }];
    
    
    [client POST:@"/appservices/webservice.asmx?wsdl" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSString *response = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
        
       
        //DLOG(@"jsonDict:%@",array);
        block(response,nil);
        [NSString jSONStringToNSDictionary:response];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
    }];
}

@end



@implementation EGMemberInfo

@end
