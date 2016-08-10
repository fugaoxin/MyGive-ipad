//
//  EGScrollView.h
//  Egive-ipad
//
//  Created by User01 on 15/11/23.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EGScrollView : UIView

@property (nonatomic) int pageCount;

//设置某个位置处的图片
-(void)setImage:(UIImage *)image atIndex:(int)index;
-(void)setImageWithUrlString:(NSString *)urlString atIndex:(int)index;

//是否自动滚动
@property (nonatomic) BOOL autoScroll;

//是否显示pageControl
@property (nonatomic) BOOL showPageControl;

@property (strong,nonatomic) UIScrollView *scrollView;
@property (strong,nonatomic) UIPageControl *pageControl;

//每张添加点击处理 - block
-(void)setClickAction:(void(^)(UIImageView *imageView, int index) )action;

@end
