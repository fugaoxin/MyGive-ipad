//
//  EGHomeSportView.h
//  Egive-ipad
//
//  Created by User01 on 15/11/23.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EGHomeSportViewDelegate <NSObject>

-(void)clickTitleIndex:(int)index;//点击回调

@end


@interface EGHomeSportView : UIView

@property (nonatomic, strong) NSString *str;//要滚动的文字

@property (nonatomic, strong) NSArray * dataArray;//滚动的数据

@property (nonatomic,weak)id<EGHomeSportViewDelegate>delegate;

@end
