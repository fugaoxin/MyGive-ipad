//
//  EGHomeModel.m
//  Egive-ipad
//
//  Created by vincentmac on 15/11/19.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGHomeModel.h"
#import "EGHttpClient.h"


@implementation EGHomeModel

-(void)setDictionary:(NSDictionary *)dic
{
    [self setValuesForKeysWithDictionary:dic];
}

+(void)getHomeDataWithParams:(NSDictionary *)param block:(void (^)(NSArray *, NSError *))block{

    [[EGHttpClient shareClient] GET:@"" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:operation.responseData options: kNilOptions error:&error];
        if (!error) {
            
            
            //TO-DO
            
            
        }else{
            block(nil,error);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
    }];
}


+(void)postHomeItemListWithParams:(NSString *)param block:(void (^)(NSArray *, NSError *))block{
    
    EGHttpClient *client = [EGHttpClient shareClient];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    [client.requestSerializer setValue:@"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [client.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return param;
    }];
    [client.requestSerializer setStringEncoding:NSUTF8StringEncoding];

    [client POST:@"/appservices/webservice.asmx?wsdl" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *response = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *jsonDict = [self parseJSONStringToNSDictionary:response];
        
        if ([jsonDict objectForKey:@"ItemList"]!=[NSNull null]) {
            NSArray * array=[jsonDict objectForKey:@"ItemList"];
            block(array,nil);
        }
        

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
    }];
}

+(void)mypostHomeItemListWithParams:(NSString *)param block:(void (^)(NSArray *, NSError *))block{
    
    EGHttpClient *client = [EGHttpClient shareClient];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    [client.requestSerializer setValue:@"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [client.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return param;
    }];
    
    [client.requestSerializer setStringEncoding:NSUTF8StringEncoding];
    
    [client POST:@"/appservices/webservice.asmx?wsdl" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *response = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
        NSArray *jsonArr = [self parseJSONStringToNSArray:response];
        block(jsonArr,nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
    }];
}

+(void)savepostHomeItemListWithParams:(NSString *)param block:(void (^)(NSString * str, NSError *))block{
    EGHttpClient *client = [EGHttpClient shareClient];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    [client.requestSerializer setValue:@"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [client.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return param;
    }];
    
    [client.requestSerializer setStringEncoding:NSUTF8StringEncoding];
    
    [client POST:@"/appservices/webservice.asmx?wsdl" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *response = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
        NSString *result = [self captureData:response];;
        block(result,nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
    }];
    
}

+(void)postFavouriteWithParams:(NSString *)param block:(void (^)(NSString *, NSError *))block
{
    EGHttpClient *client = [EGHttpClient shareClient];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    [client.requestSerializer setValue:@"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [client.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return param;
    }];
    
    [client.requestSerializer setStringEncoding:NSUTF8StringEncoding];
    
    [client POST:@"/appservices/webservice.asmx?wsdl" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *response = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
        NSString *result = [self captureData:response];
        block(result,nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
    }];

}

+(void)postClickCharitytWithParams:(NSString *)param block:(void (^)(NSDictionary *data,NSError *error)) block
{
    EGHttpClient *client = [EGHttpClient shareClient];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    [client.requestSerializer setValue:@"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [client.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return param;
    }];
    [client.requestSerializer setStringEncoding:NSUTF8StringEncoding];
    
    [client POST:@"/appservices/webservice.asmx?wsdl" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *response = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *jsonDict = [self parseJSONStringToNSDictionary:response];
        block(jsonDict,nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
    }];
}

+ (void)postWithHttpsConnection:(BOOL)safe soapMsg:(NSString *)soapMsg success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSString *url = [NSString stringWithFormat:@"%@/appservices/webservice.asmx?wsdl", SITE_URL];//safe ? requestURLString_s : requestURLString;
    [EGHomeModel postWithURL:url soapMsg:soapMsg success:success failure:failure];
}

+ (void)postWithURL:(NSString *)url soapMsg:(NSString *)soapMsg success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    //1.获得请求管理者
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    [manager.requestSerializer setValue:@"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return soapMsg;
    }];
    
    //2.发送Post请求
    [manager POST:url parameters:soapMsg success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


+ (void)postWithSoapMsg:(NSString *)soapMsg success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    //1.获得请求管理者
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    [manager.requestSerializer setValue:@"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return soapMsg;
    }];
    //2.发送Post请求
    [manager POST:[NSString stringWithFormat:@"%@/appservices/webservice.asmx?wsdl", SITE_URL] parameters:soapMsg success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *response = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
        //DLOG(@"response==%@",response);
        NSDictionary * result = [self parseJSONStringToNSDictionary:response];
        if (success) {
            success(result);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
