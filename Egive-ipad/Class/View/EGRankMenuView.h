//
//  EGRankMenuView.h
//  Egive-ipad
//
//  Created by vincentmac on 15/11/25.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EGRankMenuView : UIView


-(instancetype)initWithArray:(NSArray *)array;

-(void)scrollToIndex:(NSInteger)index;


// 点击item的回调
@property (nonatomic, copy) void (^headClick)(NSInteger index);

@end
