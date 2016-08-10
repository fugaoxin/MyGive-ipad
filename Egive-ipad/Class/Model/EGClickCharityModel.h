//
//  EGClickCharityModel.h
//  Egive-ipad
//
//  Created by 123 on 15/12/7.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EGClickCharityModel : NSObject

@property (nonatomic,copy) NSString *TitleColor;
@property (nonatomic,copy) NSString *Region;
@property (nonatomic,copy) NSString *Title;
@property (nonatomic,copy) NSString *Percentage;
@property (nonatomic,copy) NSString *ProfilePicURL;
@property (nonatomic,copy) NSString *ProfilePicCaption;
@property (nonatomic,copy) NSString *BackGround;
@property (nonatomic,copy) NSString *Need;
@property (nonatomic,copy) NSString *CaseID;
@property (nonatomic,copy) NSArray *Comments;
@property (nonatomic,copy) NSString *Share;
@property (nonatomic,copy) NSArray *RemainingTime;
@property (nonatomic) BOOL IsSuccess;
@property (nonatomic,copy) NSString *IsAngelActionCase;
@property (nonatomic,copy) NSString *DonorCount;
@property (nonatomic,copy) NSArray *Media;
@property (nonatomic,copy) NSArray *GalleryImg;
@property (nonatomic,copy) NSString *Content;
@property (nonatomic,copy) NSString *CommentCount;
@property (nonatomic,copy) NSString *Amt;
@property (nonatomic) BOOL Isfavourite;
@property (nonatomic,copy) NSDictionary *SimilarCaseList;
@property (nonatomic,copy) NSString *ShortDesc;
@property (nonatomic,copy) NSArray *UpdatesDetail;
@property (nonatomic,copy) NSString *Status;
@property (nonatomic,copy) NSString *TargetAmt;
@property (nonatomic,copy) NSArray *Donors;
@property (nonatomic,copy) NSString *ShortDescColor;

@end
