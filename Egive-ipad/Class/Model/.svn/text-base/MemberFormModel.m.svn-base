//
//  MemberFormModel.m
//  Egive
//
//  Created by sino on 15/9/4.
//  Copyright (c) 2015年 sino. All rights reserved.
//

#import "MemberFormModel.h"
#import "EGHttpClient.h"

@implementation MemberFormModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

+(void)getMemberFormModelData:(int)lang  Block:(void (^)(NSDictionary *result,NSError *error)) block;
{
    
//    int lang = [Language getLanguage];
    NSString * param =
    [NSString stringWithFormat:
     @"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body> <GetMemberForm xmlns=\"egive.appservices\"><Lang>%d</Lang></GetMemberForm></soap:Body></soap:Envelope>",lang
     ];
    
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

@end
