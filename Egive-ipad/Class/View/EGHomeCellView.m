//
//  EGHomeCellView.m
//  Egive-ipad
//
//  Created by User01 on 15/11/23.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGHomeCellView.h"

#define VIEWW    self.frame.size.width
#define VIEWH    self.frame.size.height
#define FONT     12.5  //字体

@implementation EGHomeCellView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    return self;
}

- (UIImageView *)typeImage//左图片
{
    if (!_typeImage) {
        _typeImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 40, 40)];
        [self addSubview:_typeImage];
    }
    return _typeImage;
}

- (UILabel *)titleLabel//地点
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 145, 25)];
        _titleLabel.font = [UIFont systemFontOfSize:FONT];
        _titleLabel.textColor=[UIColor whiteColor];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)timeLabel//剩余时间
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(195, 0, 115, 25)];
        _timeLabel.font = [UIFont systemFontOfSize:FONT];
        _timeLabel.textColor=[UIColor whiteColor];
        [self addSubview:_timeLabel];
    }
    return _timeLabel;
}

- (UILabel *)yellowLabel//进度条
{
    if (!_yellowLabel) {
        _yellowLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 25, 135, 25)];
        _yellowLabel.font = [UIFont systemFontOfSize:FONT];
        [self addSubview:_yellowLabel];
    }
    return _yellowLabel;
}

- (UIImageView *)yellowButton//心按钮CGRectMake(40, 35, 100, 2)
{
    if (!_yellowButton) {
        _yellowButton = [[UIImageView alloc] initWithFrame:CGRectMake(120, 27, 23, 21)];
        [self addSubview:_yellowButton];
    }
    return _yellowButton;
}

- (UILabel *)valueLabel//进度值
{
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(145, 25, 45, 25)];
        _valueLabel.font = [UIFont systemFontOfSize:FONT];
        _valueLabel.textColor=[UIColor whiteColor];
        [self addSubview:_valueLabel];
    }
    return _valueLabel;
}

- (UILabel *)peopleLabel//赞助人数
{
    if (!_peopleLabel) {
        _peopleLabel = [[UILabel alloc] initWithFrame:CGRectMake(195, 25, 110, 25)];
        _peopleLabel.font = [UIFont systemFontOfSize:FONT];
        _peopleLabel.textColor=[UIColor whiteColor];
        [self addSubview:_peopleLabel];
    }
    return _peopleLabel;
}

- (UILabel *)moneyLabel//赞助金额
{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 50, 200, 30)];
        _moneyLabel.font = [UIFont systemFontOfSize:FONT];
        _moneyLabel.textColor=[UIColor whiteColor];
        [self addSubview:_moneyLabel];
    }
    return _moneyLabel;
}

- (UIButton *)CollectButton//购物车
{
    if (!_CollectButton) {
        _CollectButton = [[UIButton alloc] initWithFrame:CGRectMake(VIEWW-35, 50, 30, 30)];
        [self addSubview:_CollectButton];
    }
    return _CollectButton;
}


@end
