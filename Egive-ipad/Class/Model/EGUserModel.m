//
//  EGUserModel.m
//  Egive-ipad
//
//  Created by vincentmac on 15/12/1.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGUserModel.h"
#import "EGHttpClient.h"

@implementation EGUserModel


-(NSDictionary*)asDictionary {
    
    NSDictionary *data = [self dictionaryWithValuesForKeys:[NSArray arrayWithObjects:@"MemberID",
                                                            @"MemberType",
                                                            @"LoginName",
                                                            @"password",
                                                            @"AddressCountry",
                                                            @"VolunteerInterest",
                                                            @"EngFirstName",
                                                            @"ChiLastName",
                                                            @"AddressRoom",
                                                            @"AddressBldg",
                                                            @"BusinessRegistrationType",
                                                            @"BusinessRegistrationNo",
                                                            @"ProfilePicBase64String",
                                                            @"ProfilePicURL",
                                                            @"ChiFirstName",
                                                            @"Email",
                                                            @"AddressStreet",
                                                            @"DonationInterest",
                                                            @"JoinVolunteer",
                                                            @"EngNameTitle",
                                                            @"BelongTo",
                                                            @"VolunteerInterest_Other",
                                                            @"AvailableTime",
                                                            @"Sex",
                                                            @"AppToken",
                                                            @"ChiNameTitle",
                                                            @"AddressEstate",
                                                            @"VolunteerStartDate",
                                                            @"CorporationEngName",
                                                            @"EducationLevel",
                                                            @"CorporationChiName",
                                                            @"EngLastName",
                                                            @"HowToKnoweGive",
                                                            @"AvailableTime_Other",
                                                            @"HowToKnoweGive",
                                                            @"CorporationType_Other",
                                                            @"Position",
                                                            @"VolunteerType",
                                                            @"VolunteerEndDate",
                                                            @"AgeGroup",
                                                            @"TelNo",
                                                            @"AcceptEDM",
                                                            @"TelCountryCode",
                                                            @"CorporationType",
                                                            @"AddressDistrict",
                                                            @"donationAmount",
                                                            @"faceBookID",
                                                            @"weiboID",
                                                            @"ShoppingCartCount", nil]];
    
  
    
    return data;
};

-(void)fromDictionary:(NSDictionary*)data
{
    _MemberID = [data objectForKey:@"MemberID"];
    _MemberType = [data objectForKey:@"MemberType"];
    _LoginName = [data objectForKey:@"LoginName"];
    _password = [data objectForKey:@"password"];
    _AddressCountry = [data objectForKey:@"AddressCountry"];
    _VolunteerInterest = [data objectForKey:@"VolunteerInterest"];
    _EngFirstName = [data objectForKey:@"EngFirstName"];
    _ChiLastName = [data objectForKey:@"ChiLastName"];
    _AddressRoom = [data objectForKey:@"AddressRoom"];
    _AddressBldg = [data objectForKey:@"AddressBldg"];
    _BusinessRegistrationType = [data objectForKey:@"BusinessRegistrationType"];
    _BusinessRegistrationNo = [data objectForKey:@"BusinessRegistrationNo"];
    _ProfilePicBase64String = [data objectForKey:@"ProfilePicBase64String"];
    _ProfilePicURL = [data objectForKey:@"ProfilePicURL"];
    _ChiFirstName = [data objectForKey:@"ChiFirstName"];
    _Email = [data objectForKey:@"Email"];
    _AddressStreet = [data objectForKey:@"AddressStreet"];
    _DonationInterest = [data objectForKey:@"DonationInterest"];
    NSNumber *jv = [data objectForKey:@"JoinVolunteer"] != nil ? [data objectForKey:@"JoinVolunteer"] : 0;
    _JoinVolunteer = [jv boolValue];
    _EngNameTitle = [data objectForKey:@"EngNameTitle"];
    _BelongTo = [data objectForKey:@"BelongTo"];
    _VolunteerInterest_Other = [data objectForKey:@"VolunteerInterest_Other"];
    _AvailableTime = [data objectForKey:@"AvailableTime"];
    _Sex = [data objectForKey:@"Sex"];
    _AppToken = [data objectForKey:@"AppToken"];
    _ChiNameTitle = [data objectForKey:@"ChiNameTitle"];
    _AddressEstate = [data objectForKey:@"AddressEstate"];
    _VolunteerStartDate = [data objectForKey:@"VolunteerStartDate"];
    _CorporationEngName = [data objectForKey:@"CorporationEngName"];
    _EducationLevel = [data objectForKey:@"EducationLevel"];
    _CorporationChiName = [data objectForKey:@"CorporationChiName"];
    _EngLastName = [data objectForKey:@"EngLastName"];
    _HowToKnoweGive_Other = [data objectForKey:@"HowToKnoweGive[data objectForKey:_Other"];
    _AvailableTime_Other = [data objectForKey:@"AvailableTime_Other"];
    _HowToKnoweGive = [data objectForKey:@"HowToKnoweGive"];
    _CorporationType_Other = [data objectForKey:@"CorporationType_Other"];
    _Position = [data objectForKey:@"Position"];
    _VolunteerType = [data objectForKey:@"VolunteerType"];
    _VolunteerEndDate = [data objectForKey:@"VolunteerEndDate"];
    _AgeGroup = [data objectForKey:@"AgeGroup"];
    _TelNo = [data objectForKey:@"TelNo"];
    NSNumber *ae = [data objectForKey:@"AcceptEDM"] != nil ? [data objectForKey:@"AcceptEDM"] : 0;
    _AcceptEDM = [ae boolValue];
    _TelCountryCode = [data objectForKey:@"TelCountryCode"];
    _CorporationType = [data objectForKey:@"CorporationType"];
    _AddressDistrict = [data objectForKey:@"AddressDistrict"];
    _donationAmount = [data objectForKey:@"donationAmount"];
    _faceBookID = [data objectForKey:@"faceBookID"];
    _weiboID = [data objectForKey:@"weiboID"];
    NSNumber *sc = [data objectForKey:@"ShoppingCartCount"];
    _ShoppingCartCount = [sc integerValue];
}



-(NSString *)description{

    return [NSString stringWithFormat:@"name:%@,memberid:%@,type:%@",self.LoginName,self.MemberID,self.MemberType];
}

//获取成功登录后用户信息
+(void)getMemberInfoDataWithMemberId:(NSString *)memberId block:(void (^)(NSDictionary *result,NSError *error)) block;
{
    NSString * param =
    [NSString stringWithFormat:
     @"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><GetMemberInfo xmlns=\"egive.appservices\"><MemberID>%@</MemberID></GetMemberInfo></soap:Body></soap:Envelope>",memberId];
    
    EGHttpClient *client = [EGHttpClient shareClient];
    
    [client.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return param;
    }];
    
    [client POST:@"/appservices/webservice.asmx?wsdl" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *response = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
        NSArray * arr = [self parseJSONStringToNSArray:response];
        //DLOG(@"jsonDict:%@",dict);
        if (arr.count>0) {
            NSDictionary *dict = arr[0];
            block(dict,nil);
        }else{
            NSError *error = [[NSError alloc] initWithDomain:@"response NSArray 0" code:-9999 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Unknow error", NSLocalizedDescriptionKey, nil]];
            block(nil,error);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
    }];
}

//注册接口
+(void)commitMemberInfoDataWithModel:(EGUserModel *)model block:(void (^)(NSString *result,NSError *error)) block;
{
    int lang = [Language getLanguage];
    NSString * param = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body> <SaveMemberInfo xmlns=\"egive.appservices\"><MemberID></MemberID><MemberType>%@</MemberType><CorporationType>%@</CorporationType><CorporationType_Other>%@</CorporationType_Other><LoginName>%@</LoginName><Password>%@</Password><ConfirmPassword>%@</ConfirmPassword><ProfilePicBase64String>%@</ProfilePicBase64String><CorporationChiName>%@</CorporationChiName><CorporationEngName>%@</CorporationEngName><BusinessRegistrationType>%@</BusinessRegistrationType><BusinessRegistrationNo>%@</BusinessRegistrationNo><ChiNameTitle>%@</ChiNameTitle><ChiLastName>%@</ChiLastName><ChiFirstName>%@</ChiFirstName><EngNameTitle>%@</EngNameTitle><EngLastName>%@</EngLastName><EngFirstName>%@</EngFirstName><Sex>%@</Sex><AgeGroup></AgeGroup><Email>%@</Email><TelCountryCode>%@</TelCountryCode><TelNo>%@</TelNo><AddressRoom>%@</AddressRoom><AddressBldg>%@</AddressBldg><AddressEstate>%@</AddressEstate><AddressStreet>%@</AddressStreet><AddressDistrict>%@</AddressDistrict><AddressCountry>%@</AddressCountry><EducationLevel></EducationLevel><Position>%@</Position><BelongTo>%@</BelongTo><HowToKnoweGive></HowToKnoweGive><HowToKnoweGive_Other></HowToKnoweGive_Other><AcceptEDM>%d</AcceptEDM><DonationInterest>%@</DonationInterest><JoinVolunteer>%d</JoinVolunteer><VolunteerType>%@</VolunteerType><VolunteerStartDate>%@</VolunteerStartDate><VolunteerEndDate>%@</VolunteerEndDate><VolunteerInterest>%@</VolunteerInterest><VolunteerInterest_Other>%@</VolunteerInterest_Other><AvailableTime>%@</AvailableTime><AvailableTime_Other>%@</AvailableTime_Other><AppToken>%@</AppToken><FaceBookID>%@</FaceBookID><WeiboID>%@</WeiboID><Lang>%d</Lang></SaveMemberInfo></soap:Body></soap:Envelope>",model.MemberType,model.CorporationType,model.CorporationType_Other,model.LoginName,model.password,model.password,model.base64Avatar,model.CorporationChiName,model.CorporationEngName,model.BusinessRegistrationType,model.BusinessRegistrationNo,model.ChiNameTitle,model.ChiLastName,model.ChiFirstName,model.EngNameTitle,model.EngLastName,model.EngFirstName,model.Sex,model.Email,model.TelCountryCode,model.TelNo,model.AddressRoom,model.AddressBldg,model.AddressEstate,model.AddressStreet,@"",model.AddressCountry,model.Position,model.BelongTo, model.AcceptEDM,model.DonationInterest,model.JoinVolunteer,model.VolunteerType,model.VolunteerStartDate,model.VolunteerEndDate,model.VolunteerInterest,model.VolunteerInterest_Other,model.AvailableTime,model.AvailableTime_Other,[EGLoginTool loginSingleton].getAppToken, model.faceBookID, model.weiboID,lang];
    
    EGHttpClient *client = [EGHttpClient shareClient];
    [client.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return param;
    }];
    
    [client POST:@"/appservices/webservice.asmx?wsdl" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *response = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
        //DLOG(@"jsonDict:%@",dict);
        block(response,nil);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
    }];
}


+(void)commitLangWithParams:(NSString *)parms block:(void (^)(NSString *, NSError *))block{

    EGHttpClient *client = [EGHttpClient shareClient];
    [client.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return parms;
    }];
    
    [client POST:@"/appservices/webservice.asmx?wsdl" parameters:parms success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *response = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
        //DLOG(@"jsonDict:%@",dict);
        block(response,nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
    }];
}


+(void)changePushMessagePreferenceWithToken:(NSString *)token param:(NSString *)str block:(void (^)(NSString *, NSError *))block{
    


    NSString * param =  [NSString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><ChangePushMessagePreference xmlns=\"egive.appservices\"><MsgPreference>%@</MsgPreference><AppToken>%@</AppToken></ChangePushMessagePreference></soap:Body></soap:Envelope>",str,token];//EVENT,CASE,CASEUPDATE,SUCCESS,DONATION
    
    EGHttpClient *client = [EGHttpClient shareClient];
    [client.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return param;
    }];
    
    [client POST:@"/appservices/webservice.asmx?wsdl" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *response = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
        //DLOG(@"jsonDict:%@",dict);
        block(response,nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
    }];

}

@end
