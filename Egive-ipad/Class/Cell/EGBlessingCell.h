//
//  EGBlessingCell.h
//  Egive-ipad
//
//  Created by 123 on 15/12/11.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGBlessingModel.h"

@protocol EGBlessingDelegate <NSObject>

-(void)deleteBlessing:(int)index;//删除评论

@end

@interface EGBlessingCell : UITableViewCell

@property (strong, nonatomic) UIImageView * bgImageView;//背景
@property (strong, nonatomic) UIWebView * commentWv;//内容
@property (strong, nonatomic) UIButton * deleteButton;//删除按钮

-(void)setModel:(EGBlessingModel *)model andIndex:(int)index;

@property (nonatomic,weak)id<EGBlessingDelegate>delegate;

@end
