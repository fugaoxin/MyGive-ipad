//
//  EGMZEditConnection.m
//  Egive-ipad
//
//  Created by vincentmac on 15/12/26.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGMZEditConnection.h"

@implementation EGMZEditConnection


-(void)awakeFromNib{
    _lineConstraint.constant = 10;
    _otherField.hidden = YES;
    self.dropButton.hidden = YES;
    
    [_addSeg addTarget:self action:@selector(addressValueChange:) forControlEvents:UIControlEventValueChanged];
    
    
    _Label1.textColor = MemberZoneTextColor;
    _Label2.textColor = MemberZoneTextColor;
    _Label3.textColor = MemberZoneTextColor;
    _Label4.textColor = MemberZoneTextColor;
    _Label5.textColor = MemberZoneTextColor;
    _conNameDetailLabel.textColor = MemberZoneTextColor;
    _conNameLabel.textColor = MemberZoneTextColor;
}

-(void)addressValueChange:(UISegmentedControl *)seg{

    if (seg.selectedSegmentIndex==0) {
        _lineConstraint.constant = 10;
        _otherField.hidden = YES;
    }else{
        _lineConstraint.constant = 55;
        _otherField.hidden = NO;
    }
}

-(void)refreshText{

    
//    _conNameLabel.text = HKLocalizedString(@"通讯地址");
    _conNameDetailLabel.text = HKLocalizedString(@"Register_org_noteLabel2_title");
    _Label1.text = HKLocalizedString(@"Register_org_region1");
    _Label2.text = HKLocalizedString(@"Register_org_region2");
    _Label3.text = HKLocalizedString(@"Register_org_region3");
    _Label4.text = HKLocalizedString(@"Register_org_region4");
    _Label5.text = HKLocalizedString(@"Register_org_selRegion");
    
    [_addSeg setTitle:HKLocalizedString(@"Register_org_regionButton") forSegmentAtIndex:0];
    [_addSeg setTitle:HKLocalizedString(@"Register_org_otherButton") forSegmentAtIndex:1];
    
    _otherField.placeholder = HKLocalizedString(@"Please_specify");
}

/*

 
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
