//
//  EGMZShowOther.m
//  Egive-ipad
//
//  Created by vincentmac on 15/12/25.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGMZShowOther.h"

@implementation EGMZShowOther



-(void)awakeFromNib{
    _Label1.textColor = MemberZoneTextColor;
    _Label3.textColor = MemberZoneTextColor;
    _Label5.textColor = MemberZoneTextColor;
   
    _workLabel1.textColor = MemberZoneTextColor;
    _workLabel2.textColor = MemberZoneTextColor;
    _workLabel5.textColor = MemberZoneTextColor;
    _workLabel17.textColor = MemberZoneTextColor;
    
    //
    NSArray *workBtns = @[_workButton1,_workButton2,_workButton3,_workButton4,_workButton5,_workButton6,_workButton7,_workButton8,_workButton9,_workButton10];
    for (int i=0; i<workBtns.count; i++) {
        //
        UIButton *btn = workBtns[i];
        [btn setImage:[UIImage imageNamed:@"cart_checkbox_nor"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"cart_checkbox_sel"] forState:UIControlStateSelected];
        
        btn.tag = i;
        [btn addTarget:self action:@selector(workBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        //
        btn.userInteractionEnabled = NO;
        
    }
    
    
    //
    NSArray *timeBtns = @[_timeButton1,_timeButton2,_timeButton3,_timeButton4,_timeButton5,_timeButton6,_timeButton7,_timeButton8,_timeButton9,_timeButton10,_timeButton11,_timeButton12,_timeButton13];
    for (int i=0; i<timeBtns.count; i++) {
        //
        UIButton *btn = timeBtns[i];
        [btn setImage:[UIImage imageNamed:@"cart_checkbox_nor"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"cart_checkbox_sel"] forState:UIControlStateSelected];
        
        btn.tag = i;
        [btn addTarget:self action:@selector(timeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        //
        
        btn.userInteractionEnabled = NO;
    }
}


-(void)workBtnClick:(UIButton *)btn{
    btn.selected = btn.selected ? NO : YES;
    
    NSInteger tag  = btn.tag;
    
    if (tag==9) {
        
        if (btn.selected) {
            _workLabel16.hidden = NO;
            _otherField.hidden = NO;
        }else{
            _workLabel16.hidden = YES;
            _otherField.hidden = YES;
        }
        
    }
    
}

-(void)timeBtnClick:(UIButton *)btn{
    btn.selected = btn.selected ? NO : YES;
    
    NSInteger tag  = btn.tag;
    if (tag==12) {
        
        if (btn.selected) {
            _workLabel31.hidden = NO;
            _timeField.hidden = NO;
        }else{
            _workLabel31.hidden = YES;
            _timeField.hidden = YES;
        }
        
    }
    
    
}


-(void)refreshText{

    _Label1.text = HKLocalizedString(@"你從何處認識「意贈慈善基金」(可選擇多項)");
    _Label3.text = HKLocalizedString(@"Register_IsEmailNote");
    _Label5.text = HKLocalizedString(@"Register_org_noteLabel3_title");
    
    
    [_sureSeg setTitle:HKLocalizedString(@"长期义工") forSegmentAtIndex:0];
    [_sureSeg setTitle:HKLocalizedString(@"短期义工") forSegmentAtIndex:1];
    _workLabel1.text = HKLocalizedString(@"义工服务意向");
    _workLabel2.text = HKLocalizedString(@"我愿意成为意赠慈善基金的");
    _workLabel3.text = HKLocalizedString(@"由");
    _workLabel4.text = HKLocalizedString(@"至");
    _workLabel5.text = HKLocalizedString(@"有关协助之项目");
    _workLabel6.text = HKLocalizedString(@"办事处行政支援服务:(资料输入、信件处理、一般行政工作等)");
    _workLabel7.text = HKLocalizedString(@"印刷品设计");
    _workLabel8.text = HKLocalizedString(@"活动联络");
    _workLabel9.text = HKLocalizedString(@"编辑");
    _workLabel10.text = HKLocalizedString(@"翻译(中英/英中)");
    _workLabel11.text = HKLocalizedString(@"文稿撰写");
    _workLabel12.text = HKLocalizedString(@"摄影");
    _workLabel13.text = HKLocalizedString(@"协办筹款活动(不定期举办)");
    _workLabel14.text = HKLocalizedString(@"探访");
    _workLabel15.text = HKLocalizedString(@"其他");
    _workLabel16.text = HKLocalizedString(@"请注明");
    _workLabel17.text = HKLocalizedString(@"可服务的时间");
    _workLabel18.text = HKLocalizedString(@"星期一");
    _workLabel19.text = HKLocalizedString(@"星期二");
    _workLabel20.text = HKLocalizedString(@"星期三");
    _workLabel21.text = HKLocalizedString(@"星期四");
    _workLabel22.text = HKLocalizedString(@"星期五");
    _workLabel23.text = HKLocalizedString(@"星期六");
    _workLabel24.text = HKLocalizedString(@"星期日");
    _workLabel25.text = HKLocalizedString(@"任何时间");
    _workLabel26.text = HKLocalizedString(@"上午10时至下午1时");
    _workLabel27.text = HKLocalizedString(@"下午2时至下午5时");
    _workLabel28.text = HKLocalizedString(@"上午10时至下午5时");
    _workLabel29.text = HKLocalizedString(@"晚上7时至9时");
    _workLabel30.text = HKLocalizedString(@"其他");
    _workLabel31.text = HKLocalizedString(@"请注明");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
