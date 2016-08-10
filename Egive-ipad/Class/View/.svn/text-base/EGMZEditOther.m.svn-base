//
//  EGMZEditOther.m
//  Egive-ipad
//
//  Created by vincentmac on 15/12/26.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGMZEditOther.h"

@implementation EGMZEditOther


-(void)awakeFromNib{

    NSArray *btns = @[_webButton,_activityButton,_friendButton,_paperButton,_socialButton,_donationButton,_otherButton];
    _egiveBtns = btns;
    //
    for (int i=0; i<btns.count; i++) {
        //
        UIButton *btn = btns[i];
        [btn setImage:[UIImage imageNamed:@"cart_checkbox_nor"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"cart_checkbox_sel"] forState:UIControlStateSelected];
        
        btn.tag = i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        //
        
        
    }
    
    
    //
    [_emailSeg addTarget:self action:@selector(emailValueChange:) forControlEvents:UIControlEventValueChanged];
    NSArray *emailBtns = @[_Button1,_Button2,_Button3,_Button4,_Button5,_Button6,_Button7,_Button8];
    _emailBtns = emailBtns;
    for (int i=0; i<emailBtns.count; i++) {
        //
        UIButton *btn = emailBtns[i];
        [btn setImage:[UIImage imageNamed:@"cart_checkbox_nor"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"cart_checkbox_sel"] forState:UIControlStateSelected];
        
        btn.tag = i;
        [btn addTarget:self action:@selector(emailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        //
        
        
    }
    
    
    //
    NSArray *workBtns = @[_workButton1,_workButton2,_workButton3,_workButton4,_workButton5,_workButton6,_workButton7,_workButton8,_workButton9,_workButton10];
    _workBtns = workBtns;
    for (int i=0; i<workBtns.count; i++) {
        //
        UIButton *btn = workBtns[i];
        [btn setImage:[UIImage imageNamed:@"cart_checkbox_nor"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"cart_checkbox_sel"] forState:UIControlStateSelected];
        
        btn.tag = i;
        [btn addTarget:self action:@selector(workBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        //
        
        
    }
    
    
    //
    NSArray *timeBtns = @[_timeButton1,_timeButton2,_timeButton3,_timeButton4,_timeButton5,_timeButton6,_timeButton7,_timeButton8,_timeButton9,_timeButton10,_timeButton11,_timeButton12,_timeButton13];
    _timeBtns = timeBtns;
    for (int i=0; i<timeBtns.count; i++) {
        //
        UIButton *btn = timeBtns[i];
        [btn setImage:[UIImage imageNamed:@"cart_checkbox_nor"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"cart_checkbox_sel"] forState:UIControlStateSelected];
        
        btn.tag = i;
        [btn addTarget:self action:@selector(timeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        //
        
        
    }
    
    _titleLabel.textColor = MemberZoneTextColor;
    _emailLabel.textColor = MemberZoneTextColor;
    _workLabel.textColor = MemberZoneTextColor;
    _workDetailLabel.textColor = MemberZoneTextColor;
    
    _workLabel1.textColor = MemberZoneTextColor;
    _workLabel2.textColor = MemberZoneTextColor;
    _workLabel5.textColor = MemberZoneTextColor;
    _workLabel17.textColor = MemberZoneTextColor;
//    _otherField.placeholder = HKLocalizedString(@"请说明");
//    _timeField.placeholder = HKLocalizedString(@"请说明");
}

-(void)setAcceptEmail:(BOOL)acceptEmail{

    if (acceptEmail) {
        _workMargin.constant = 70;
        _btnBgView.hidden = NO;
    }else{
        _workMargin.constant = 20;
        _btnBgView.hidden = YES;
    }
}


-(void)emailValueChange:(UISegmentedControl *)seg{
    
    if (seg.selectedSegmentIndex==1) {
        _workMargin.constant = 20;
        _btnBgView.hidden = YES;
    }else{
        _workMargin.constant = 70;
        _btnBgView.hidden = NO;
    }
}


-(void)emailBtnClick:(UIButton *)btn{
    btn.selected = btn.selected ? NO : YES;
    
    NSInteger tag  = btn.tag;
    if (tag==7 && btn.selected) {
        for (UIButton *b in _emailBtns) {
            b.selected = YES;
        }
    }
    
    if (tag==7 && !btn.selected) {
        for (UIButton *b in _emailBtns) {
            b.selected = NO;
        }
    }
    
    
    //有一个不被选中，all就不能勾选
    if (!btn.selected) {
        self.Button8.selected = NO;
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

-(void)btnClick:(UIButton *)btn{
    
    btn.selected = btn.selected ? NO : YES;
    
    
}


-(void)refreshText{

    _titleLabel.text = HKLocalizedString(@"你從何處認識「意贈慈善基金」(可選擇多項)");
    _webLabel.text = HKLocalizedString(@"「意贈」網頁");
    _donatLabel.text = HKLocalizedString(@"為「意贈」的捐款者");
    _activityLabel.text = HKLocalizedString(@"「意贈」活動/刊物");
    _socialLabel.text = HKLocalizedString(@"社交媒體(Facebook、新浪微博等)");
    _otherLabel.text = HKLocalizedString(@"其他");
    _friendLabel.text = HKLocalizedString(@"朋友");
    _paperLabel.text = HKLocalizedString(@"報章");
    _emailLabel.text = HKLocalizedString(@"Register_IsEmailNote");
    _workLabel.text = HKLocalizedString(@"Register_org_noteLabel3_title");
    [_emailSeg setTitle:HKLocalizedString(@"Register_isEmailButton_title") forSegmentAtIndex:0];
    [_emailSeg setTitle:HKLocalizedString(@"Register_noEmailButton_title") forSegmentAtIndex:1];
    [_workSeg setTitle:HKLocalizedString(@"Register_yButton_title") forSegmentAtIndex:0];
    [_workSeg setTitle:HKLocalizedString(@"Register_nButton_title") forSegmentAtIndex:1];
    
    _Label1.text = HKLocalizedString(@"助学");
    _Label2.text = HKLocalizedString(@"助医");
    _Label3.text = HKLocalizedString(@"紧急援助");
    _Label4.text = HKLocalizedString(@"意赠行动");
    _Label5.text = HKLocalizedString(@"安老");
    _Label6.text = HKLocalizedString(@"扶贫");
    _Label7.text = HKLocalizedString(@"其他");
    _Label8.text = HKLocalizedString(@"全部");
    _workDetailLabel.text = HKLocalizedString(@"请选择你喜欢的专案类别(可选多项)");
    
//    [_webButton setTitle:HKLocalizedString(@"") forState:UIControlStateNormal];
//    [_activityButton setTitle:HKLocalizedString(@"") forState:UIControlStateNormal];
//    [_friendButton setTitle:HKLocalizedString(@"") forState:UIControlStateNormal];
//    [_paperButton setTitle:HKLocalizedString(@"") forState:UIControlStateNormal];
//    [_otherButton setTitle:HKLocalizedString(@"") forState:UIControlStateNormal];
//    [_donationButton setTitle:HKLocalizedString(@"") forState:UIControlStateNormal];
    
    
    
    [_sureSeg setTitle:HKLocalizedString(@"长期义工") forSegmentAtIndex:0];
    [_sureSeg setTitle:HKLocalizedString(@"短期义工") forSegmentAtIndex:1];
    _workLabel1.text = HKLocalizedString(@"义工服务意向");
    _workLabel2.text = HKLocalizedString(@"我愿意成为意赠慈善基金的");
    _workLabel3.text = HKLocalizedString(@"由");
    _workLabel4.text = HKLocalizedString(@"至");
    _workLabel5.text = HKLocalizedString(@"有关协助之项目:(可选择多项)");
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
    _workLabel17.text = HKLocalizedString(@"可服务的时间(可选择多项)");
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


-(void)clearWorkSelected{
    for (UIButton *b in _workBtns) {
//        if (b.tag!=_workBtns.count-1) {
//             b.selected = NO;
//        }
         b.selected = NO;
    }
}

-(void)clearTimeSelected{
    for (UIButton *b in _timeBtns) {
//        if (b.tag!=_timeBtns.count-1) {
//            b.selected = NO;
//        }
         b.selected = NO;
    }

}

@end
