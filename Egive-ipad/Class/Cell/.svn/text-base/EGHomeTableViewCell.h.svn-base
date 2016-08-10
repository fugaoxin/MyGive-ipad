//
//  EGHomeTableViewCell.h
//  Egive-ipad
//
//  Created by User01 on 15/11/19.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGHomeModel.h"

@protocol EGHomeCellDelegate <NSObject>
/**
 * 点击最后一view
 */
-(void)clickLastView;

/**
 * cell点击回调
 * fdm: cell的字典数据
 * index: 第几个被点击
 */
-(void)clickView:(NSDictionary *)fdm and:(int)index;

/**
 * 添加收藏
 * caseID: 专案ID
 */
-(void)AddCaseFavourite:(NSString *)caseID;

/**
 * 取消收藏
 * caseID: 专案ID
 */
-(void)DeleteCaseFavourite:(NSString *)caseID;

/**
 * 添加购物车
 * caseID: 专案ID
 * but: 购物车按钮
 * RemainingValue: 等于0，专案已结束
 * Success: 等于1，专案已成功
 * StyleStr:
 */
- (void)saveShoppingCartItem:(NSString *)caseId andBut:(UIButton *)but andRemainingValue:(NSString *)RemainingValue andIsSuccess:(NSString *)Success andStyleStr:(NSString *) StyleStr;

@end


@interface EGHomeTableViewCell : UITableViewCell

@property (nonatomic,weak)id<EGHomeCellDelegate>delegate;

/**
 * 获取数据
 * Array: 专案的数组数据
 * index: 标识cell是第几行，第一行y值29，其它25
 * IDarray: 购物车ID数组
 * mybool: 用来变换页面数据，5秒一次
 * Types: 用来区分模块，“hone”是首页
 */
-(void)setDataArray:(NSMutableArray *)Array andIndex:(int)index andID:(NSMutableArray *)IDarray andBool:(BOOL)mybool andTypes:(NSString *)Types;

/**
 * 最后一个view
 */
@property (nonatomic,strong) UIImageView * clickView;

@end
