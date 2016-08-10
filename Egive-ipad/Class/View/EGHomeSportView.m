//
//  EGHomeSportView.m
//  Egive-ipad
//
//  Created by User01 on 15/11/23.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGHomeSportView.h"

#define VIEWW    self.frame.size.width
#define VIEWH    self.frame.size.height
#define INTERVAL 0.01//时间
#define FONT     20  //字体

@interface EGHomeSportView()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) NSTimer *timer;

@end


@implementation EGHomeSportView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    _str = [dataArray[0] objectForKey:@"Msg"];
    for(NSDictionary * dic in dataArray)
    {
        if (_str.length<[[dic objectForKey:@"Msg"] length]) {
            _str=[dic objectForKey:@"Msg"];
        }
    }
    CGSize size = [_str sizeWithFont:[UIFont systemFontOfSize:FONT]];
    self.label.frame = CGRectMake(VIEWW, 7, size.width, size.height);
    self.label.userInteractionEnabled=YES;
    self.label.text = _str;
    self.label.textColor=[UIColor whiteColor];
    [self.timer fire];
    
    UITapGestureRecognizer * TGR=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cliclLabel:)];
    [self.label addGestureRecognizer:TGR];
}

//- (void)setStr:(NSString *)str
//{
//    _str = str;
//    CGSize size = [_str sizeWithFont:[UIFont systemFontOfSize:FONT]];
//    self.label.frame = CGRectMake(VIEWW, 7, size.width, size.height);
//    self.label.text = _str;
//    self.label.textColor=[UIColor whiteColor];
//    [self.timer fire];
//}

static int abc=0;

- (void)setupAnnimation
{
    CGRect frame = self.label.frame;
    frame.origin.x --;
    if (frame.origin.x < -frame.size.width) {
        frame.origin.x = VIEWW;
        abc++;
        if (abc==_dataArray.count) {
            abc=0;
        }
        self.label.text=[_dataArray[abc] objectForKey:@"Msg"];
    }
    self.label.frame = frame;
    self.label.tag=abc;
}

-(void)cliclLabel:(UITapGestureRecognizer *)tgr
{
    //NSLog(@"www===%d",(int)tgr.view.tag);
    [self.delegate clickTitleIndex:(int)tgr.view.tag];
}

- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
}

- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.userInteractionEnabled=YES;
        _label.font = [UIFont systemFontOfSize:FONT];
        [self addSubview:_label];
    }
    return _label;
}

- (NSTimer *)timer
{
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:INTERVAL target:self selector:@selector(setupAnnimation) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
    return _timer;
}

@end
