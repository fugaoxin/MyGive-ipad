//
//  EGContactModel.h
//  Egive-ipad
//
//  Created by vincentmac on 16/1/15.
//  Copyright © 2016年 Sino. All rights reserved.
//

#import "EGBaseModel.h"

@interface EGContactModel : EGBaseModel


@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *email;
@property (nonatomic, assign)int recordID;

@property (nonatomic, assign)BOOL isChecked;

@end
