//
//  EGProReportModel.h
//  Egive-ipad
//
//  Created by 123 on 15/12/14.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EGProReportModel : NSObject

@property (nonatomic,copy) NSArray *GalleryImg;
@property (nonatomic,copy) NSString *UpdateDate;
@property (nonatomic,copy) NSString *ProfilePicURL;
@property (nonatomic,copy) NSString *ProfilePicCaption;
@property (nonatomic,copy) NSString *Content;
@property (nonatomic,copy) NSNumber *CaseUpdateIndex;

-(void)setDictionary:(NSDictionary *)dic;

@end
