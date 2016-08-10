//
//  EGMessageModel.m
//  Egive-ipad
//
//  Created by kevin on 16/1/13.
//  Copyright © 2016年 Sino. All rights reserved.
//

#import "EGMessageModel.h"
#import "EGHttpClient.h"

@implementation EGMessageModel
+ (void)registerMobileUserWithAppToken:(NSString *)AppToken block:(void (^)(NSArray *results, NSError *error))block;
{
    int lang = [Language getLanguage];
    NSString * soapMessage = [NSString stringWithFormat:
                              @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                              "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                              "<soap:Body>"
                              "<GetMailBoxMsgResponse xmlns=\"egive.appservices\">"
                              "<AppToken>%@</AppToken>""<AppLang>%d</AppLang>"
                              "</GetMailBoxMsgResponse>"
                              "</soap:Body>"
                              "</soap:Envelope>",[[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"],lang];
    
    EGHttpClient *client = [EGHttpClient shareClient];
    
    [client.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return soapMessage;
    }];
    
    [client POST:@"/appservices/webservice.asmx?wsdl" parameters:soapMessage success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        //NSString *response = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
      
        //
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
    }];
}


+ (void)getMailBoxMsgWithMsgTp:(NSString *)MsgTp block:(void (^)(NSArray *results, NSError *error))block;
{
   
    NSString * soapMessage = [NSString stringWithFormat:
                              @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
//                              "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                              "<soap:Body>"
                              "<GetMailBoxMsgResponse xmlns=\"egive.appservices\">"
                              "<AppToken>%@</AppToken>""<MsgTp>%@</MsgTp>"
                              "</GetMailBoxMsgResponse>"
                              "</soap:Body>"
                              ,[[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"]?@"":@"",MsgTp];
    
    EGHttpClient *client = [EGHttpClient shareClient];
    
    [client.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return soapMessage;
    }];
    
    [client POST:@"/appservices/webservice.asmx?wsdl" parameters:soapMessage success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *response = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@",response);
//        NSDictionary* dic = [self parseJSONStringToNSDictionary:response];
//        NSArray *arr = [dic objectForKey:@"itemlist"];
//        NSArray *results = [EGAnnouncement initWithArray:arr];
//        block(results,nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        block(nil,error);
    }];
}

@end
