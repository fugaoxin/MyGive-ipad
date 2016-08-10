//
//  EGBasePresentViewController.h
//  Egive-ipad
//
//  Created by kevin on 15/12/29.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGBaseViewController.h"

@interface EGBasePresentViewController : EGBaseViewController<UITextFieldDelegate>

@property (assign,nonatomic) CGSize size;//内容 显示大小
@property (strong,nonatomic) UIView* bgView;//背景 点击关闭
@property (strong,nonatomic) UIView* contentView;//内容
@property (strong,nonatomic) UIView* animationView;

@property (strong,nonatomic) UIView* barView;
@property (nonatomic, strong, readonly) UILabel *navigationTitle;
@property (nonatomic, strong) UIButton *navigationBackButton;
@property (assign,nonatomic) BOOL animated;
@property (assign,nonatomic) BOOL bgAction;
/**
 * 创建ui方法  内容大小  背景按钮 动画
 */
-(void)setContentSize:(CGSize)size bgAction:(BOOL)bgAction animated:(BOOL)animated;

/**
 * 公共的TopBar  改变BackBtn请重写baseBackAction
 */
-(UIView *)createNaviTopBarWithShowBackBtn:(BOOL)showBackBtn showTitle:(BOOL)showTitle;
/**
 * 返回按钮方法
 */
-(void)baseBackAction;

/**
 * 点击背景方法
 */
-(void)bgViewAction;

@end
