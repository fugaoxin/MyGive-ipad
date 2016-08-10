//
//  EGScoopImageShowViewController.h
//  Egive-ipad
//
//  Created by kevin on 16/1/4.
//  Copyright © 2016年 Sino. All rights reserved.
//

#import "EGBasePresentViewController.h"
#import "EGGiveItemModel.h"

@interface EGScoopImageShowViewController : EGBasePresentViewController

@property(nonatomic,retain) EGGiveItemModel *ItemModel;
@property(nonatomic,assign) int selectImageTag;
@end
