//
//  EGDonationModel.m
//  Egive-ipad
//
//  Created by vincentmac on 15/12/2.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGDonationModel.h"
#import "EGHttpClient.h"

@implementation EGDonationModel


+(void)getNoteWithParams:(NSString *)param block:(void (^)(NSString *, NSError *))block{

    EGHttpClient *client = [EGHttpClient shareClient];
    
    [client.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return param;
    }];
    
    
    [client POST:@"/appservices/webservice.asmx?wsdl" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSString *response = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
        NSArray * array = [self parseJSONStringToNSArray:response];
        NSMutableString *content = [[NSMutableString alloc] init];
        for (NSDictionary *dict in array) {
            NSString *LabelName = dict[@"LabelName"];
            NSString *LabelDescription = dict[@"LabelDescription"];
            if (![LabelName hasPrefix:@"AcceptDisclaimer"]) {
                [content appendFormat:@"<p>%@</p>",LabelDescription];
            }
        }
        //DLOG(@"jsonDict:%@",content);
        
        block(content,nil);
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLOG(@"error:%@",operation.error);
        block(nil,error);
    }];

}


+(void)getDonationRecordWithParams:(NSString *)param block:(void (^)(NSArray *, NSError *))block{

    EGHttpClient *client = [EGHttpClient shareClient];
    
    [client.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return param;
    }];
    
    
    [client POST:@"/appservices/webservice.asmx?wsdl" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSString *response = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *jsonDict = [self parseJSONStringToNSDictionary:response];
        //DLOG(@"jsonDict:%@",jsonDict);
        
        [EGDonationModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"RecordList" : @"EGRecordItem",
                     //@"ads" : @"Ad"
                     // @"ads" : [Ad class]
                     };
        }];
        
        
        EGDonationModel *model = [EGDonationModel mj_objectWithKeyValues:jsonDict];
        
        
        NSArray *array = [EGRecordItem mj_objectArrayWithKeyValuesArray:model.RecordList];
        
        block(array,nil);

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
    }];
}


+(void)getCartListWithParams:(NSString *)param block:(void (^)(NSDictionary *, NSError *))block{
    EGHttpClient *client = [EGHttpClient shareClient];
    
    [client.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return param;
    }];
    
    
    [client POST:@"/appservices/webservice.asmx?wsdl" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSString *response = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *jsonDict = [self parseJSONStringToNSDictionary:response];
        //DLOG(@"jsonDict:%@",jsonDict);
        
      
        block(jsonDict,nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
    }];

}


+(void)updateCartListWithParams:(NSString *)param block:(void (^)(NSDictionary *, NSError *))block{
    EGHttpClient *client = [EGHttpClient shareClient];
    
    [client.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return param;
    }];
    
    
    [client POST:@"/appservices/webservice.asmx?wsdl" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSString *response = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *jsonDict = [self parseJSONStringToNSDictionary:response];
        //DLOG(@"update:%@",jsonDict);
        
        
        block(jsonDict,nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
    }];
    
}


+(void)getDisclaimerWithParams:(NSString *)param block:(void (^)(NSString *, NSError *))block{

    EGHttpClient *client = [EGHttpClient shareClient];
    
    [client.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return param;
    }];
    
    
    [client POST:@"/appservices/webservice.asmx?wsdl" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSString *response = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
        NSArray * array = [self parseJSONStringToNSArray:response];
        NSMutableString *content = [[NSMutableString alloc] init];
        for (NSDictionary *dict in array) {
            NSString *LabelName = dict[@"LabelName"];
            NSString *LabelDescription = dict[@"LabelDescription"];
            if (![LabelName hasPrefix:@"AcceptDisclaimer"]) {
                [content appendFormat:@"<p>%@</p>",LabelDescription];
            }
        }
        
        block(content,nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
    }];
}


+(void)checkOutShoppingCartWithParams:(NSString *)param block:(void (^)(NSDictionary *, NSError *))block{

    EGHttpClient *client = [EGHttpClient shareClient];
    
    [client.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return param;
    }];
    
    
    [client POST:@"/appservices/webservice.asmx?wsdl" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSString *response = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
        
        NSDictionary *dict = [self parseJSONStringToNSDictionary:response];
        
        block(dict,nil);
//        block(content,nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
    }];
}

@end


@implementation EGRecordItem
@end

@implementation EGCartItem

-(NSString *)description{
    return [NSString stringWithFormat:@"CaseID:%@,ischeck:%i,DonateAmt:%ld,ReceiveAmt:%ld,SelectedOption:%ld,title:%@",self.CaseID,self.IsChecked,self.DonateAmt,self.ReceiveAmt,self.SelectedOption,self.Title];
}
@end
