//
//  EGGiveItemModel.m
//  Egive-ipad
//
//  Created by kevin on 15/12/28.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGGiveItemModel.h"
#import "EGHttpClient.h"

@implementation EGGiveItem

- (id)initWithDict:(NSDictionary *)dict;
{
    if ((self = [super init]))
    {
        self.TotalNumberOfItems = [[dict objectForKey:@"TotalNumberOfItems"] integerValue];
        self.ItemList = [EGGiveItemModel initWithArray:[dict objectForKey:@"ItemList"]];
    }
    return self;
}

@end

@implementation EGGiveItemModel

- (id)initWithDict:(NSDictionary *)dict
{
    if ((self = [super init]))
    {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+ (NSMutableArray *)initWithArray:(NSArray *)array;
{
    NSMutableArray *result = [NSMutableArray array];
    for (id value in array)
    {
        if ([value isKindOfClass:[NSDictionary class]])
        {
            [result addObject:[[EGGiveItemModel alloc] initWithDict:value]];
        }
    }
    return result;
}

+ (void)getEventDtlListWithEventTp:(NSString *)EventTp year:(NSString*)year block:(void (^)(EGGiveItem *result, NSError *error))block;
{
    int lang = [Language getLanguage];
    NSString * soapMessage =[NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body> <GetEventDtlList xmlns=\"egive.appservices\"><Lang>%d</Lang><EventTp>%@</EventTp><Year>%@</Year><SearchText></SearchText><StartRowNo>1</StartRowNo><NumberOfRows>999</NumberOfRows></GetEventDtlList></soap:Body></soap:Envelope>", lang, EventTp, year];
    
    EGHttpClient *client = [EGHttpClient shareClient];
    
    [client.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return soapMessage;
    }];

    [client POST:@"/appservices/webservice.asmx?wsdl" parameters:soapMessage success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSString *response = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *dict = [self parseJSONStringToNSDictionary:response];
        EGGiveItem *result = [[EGGiveItem alloc] initWithDict:dict];
        block(result,nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
    }];
}
@end


@implementation EGAnnouncement


- (id)initWithDict:(NSDictionary *)dict
{
    if ((self = [super init]))
    {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+ (NSMutableArray *)initWithArray:(NSArray *)array;
{
    NSMutableArray *result = [NSMutableArray array];
    for (id value in array)
    {
        if ([value isKindOfClass:[NSDictionary class]])
        {
            [result addObject:[[EGAnnouncement alloc] initWithDict:value]];
        }
    }
    return result;
}

//意赠资讯-发布中心 接口
+ (void)getEventCentreListWithBlock:(void (^)(NSArray *results, NSError *error))block;
{
    int lang = [Language getLanguage];
    NSString * soapMessage = [NSString stringWithFormat:
                               @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                               "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                               "<soap:Body>"
                               "<GetAnnouncementCentreList xmlns=\"egive.appservices\">"
                               "<Lang>%d</Lang>"
                               "</GetAnnouncementCentreList>"
                               "</soap:Body>"
                               "</soap:Envelope>",lang];
    
    EGHttpClient *client = [EGHttpClient shareClient];
    
    [client.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return soapMessage;
    }];
    
    [client POST:@"/appservices/webservice.asmx?wsdl" parameters:soapMessage success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSString *response = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
        NSDictionary* dic = [self parseJSONStringToNSDictionary:response];
        NSArray *arr = [dic objectForKey:@"itemlist"];
        NSArray *results = [EGAnnouncement initWithArray:arr];
        block(results,nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
    }];
}

@end
