//
//  EGLoginModel.m
//  Egive-ipad
//
//  Created by kevin on 15/12/16.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGLoginModel.h"
#import "EGHttpClient.h"

@implementation EGLoginModel


//登录接口
+(void)getLoginApiDataWithParams:(NSString *)param block:(void (^)(NSString *result,NSError *error)) block;
{
    EGHttpClient *client = [EGHttpClient shareClient];
    
    [client.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return param;
    }];
    
    [client POST:@"/appservices/webservice.asmx?wsdl" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *response = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];

        block(response,nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
    }];
}

//获取条款、政策、声明等信息
+(void)getStaticPageContentWithFormID:(NSString *)formID block:(void (^)(NSDictionary *result,NSError *error)) block;
{
    int lang = [Language getLanguage];
    NSString * param =[NSString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                         "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                         "<soap:Body>"
                         "<GetStaticPageContent xmlns=\"egive.appservices\">"
                         "<Lang>%d</Lang>"
                         "<FormID>%@</FormID>"
                         "</GetStaticPageContent>"
                         "</soap:Body>"
                         "</soap:Envelope>",lang,formID];
    
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
        block(nil,error);
    }];
}

//忘记密码接口
+(void)commitForgetPasswordWithFormEmailAddress:(NSString *)emailAddress block:(void (^)(NSString *result,NSError *error)) block;
{
    int lang = [Language getLanguage];
    NSString * param =  [NSString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body> <ForgetPassword xmlns=\"egive.appservices\"><Lang>%d</Lang><Email>%@</Email></ForgetPassword></soap:Body></soap:Envelope>",lang,emailAddress];
    
    EGHttpClient *client = [EGHttpClient shareClient];
    [client.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return param;
    }];
    
    [client POST:@"/appservices/webservice.asmx?wsdl" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *response = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];

        block(response,nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
    }];
}


@end
