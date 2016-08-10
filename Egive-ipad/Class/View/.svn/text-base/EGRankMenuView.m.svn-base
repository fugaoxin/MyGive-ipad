//
//  EGRankMenuView.m
//  Egive-ipad
//
//  Created by vincentmac on 15/11/25.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGRankMenuView.h"
#import "UIImage+addtion.h"


@interface EGRankMenuView(){
    UIButton *currentSelectBtn;
    UILabel *currentSelectLabel;
}

@property (nonatomic,strong) NSMutableArray *btns;

@property (nonatomic,strong) NSMutableArray *labels;

@end

@implementation EGRankMenuView

-(instancetype)initWithArray:(NSArray *)array{
    
    if (self =[super init]) {
        _btns = [NSMutableArray array];
        _labels = [NSMutableArray array];
        [self setupSubviews:array];
    }
    return self;
}



-(void)setupSubviews:(NSArray *)array{
    
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - 64)/ array.count ;
    
    for (int i=0;i<array.count;i++) {
        
        NSDictionary *dict = array[i];
        
        
        UIImage *icon = [UIImage resizedImage:dict[@"icon"]];
        UIImage *selectedImage = [UIImage resizedImage:dict[@"selectedImage"]];
        UIImage *unselectedImage = [UIImage resizedImage:dict[@"normalImage"]];
        
       
        
        UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
        item.titleLabel.font = [UIFont systemFontOfSize:NormalFontSize];
//        [item setTitle:dict[@"title"] forState:UIControlStateNormal];
        item.tag = i;
        
        
        
        CGFloat scale = unselectedImage.size.width / unselectedImage.size.height;
//        item.frame = (CGRect){width*i,0,width-1,width/scale};
        item.frame = (CGRect){width*i,0,width,44};
        item.highlighted = NO;
        [item addTarget:self action:@selector(selectItem:) forControlEvents:UIControlEventTouchUpInside];
        [item setBackgroundImage:selectedImage forState:UIControlStateSelected];
//        [item setBackgroundImage:unselectedImage forState:UIControlStateNormal];
        [item setTitleColor:[UIColor colorWithHexString:@"#531E7D"] forState:UIControlStateSelected];
        [item setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:item];
        
        
       
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.tag = i;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor colorWithHexString:@"#7B7C7D"];
        titleLabel.text = dict[@"title"];
        titleLabel.font = [UIFont boldSystemFontOfSize:15];
        titleLabel.numberOfLines = 0;
//        titleLabel.frame = (CGRect){imageView.frame.size.width+30+10,10,item.frame.size.width-60,44};
//        titleLabel.bounds = (CGRect){0,0,item.frame.size.width-60,item.frame.size.height-20};
//        titleLabel.center = item.center;
        [item addSubview:titleLabel];
        
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(item);
            make.centerX.equalTo(item);
            //make.left.equalTo(imageView.mas_right).offset(5);
//            make.width.mas_equalTo(item.frame.size.width-70);
            make.width.mas_lessThanOrEqualTo(item.frame.size.width-70);
        }];
        
        
        
        //
        UIImageView *imageView = [[UIImageView alloc] initWithImage:icon];
        [item addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(item);
            //make.left.equalTo(item).offset(15);
            make.right.equalTo(titleLabel.mas_left).offset(-5);
            make.width.mas_equalTo(25);
            make.height.mas_equalTo(25);
        }];
        
        
        //
        [_labels addObject:titleLabel];
        [_btns addObject:item];
        
        
    }
    
    
    //
    UIButton *selectedBtn =  _btns[0];
    selectedBtn.selected = YES;
    currentSelectBtn = selectedBtn;
    UILabel *selectedLabel = _labels[0];
    currentSelectLabel = selectedLabel;
    currentSelectLabel.textColor = [UIColor colorWithHexString:@"#531E7D"];
}

-(void)selectItem:(UIButton *)btn{
    NSInteger tag = btn.tag;
    if (currentSelectBtn.tag==tag)  return;
    
    UIButton *selectBtn = (UIButton *)_btns[tag];
    selectBtn.selected = YES;
    
    currentSelectBtn.selected = NO;
    currentSelectBtn = selectBtn;
    
    UILabel *selectedLabel = _labels[tag];
    currentSelectLabel.textColor = [UIColor colorWithHexString:@"#7B7C7D"];
    selectedLabel.textColor = [UIColor colorWithHexString:@"#531E7D"];
    currentSelectLabel = selectedLabel;
    
    
    if (_headClick) {
        _headClick(tag);
    }
}


-(void)scrollToIndex:(NSInteger)index{
    if (index<0 || index>_btns.count-1 || index==currentSelectBtn.tag) return;
    
    UIButton *selectBtn = (UIButton *)_btns[index];
    selectBtn.selected = YES;
    
    currentSelectBtn.selected = NO;
    currentSelectBtn = selectBtn;
    
    UILabel *selectedLabel = _labels[index];
    currentSelectLabel.textColor = [UIColor colorWithHexString:@"#7B7C7D"];
    selectedLabel.textColor = [UIColor colorWithHexString:@"#531E7D"];
    currentSelectLabel = selectedLabel;
    
    if (_headClick) {
        _headClick(index);
    }
}


@end
