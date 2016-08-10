//
//  EGSelectedCaseCell.m
//  Egive-ipad
//
//  Created by vincentmac on 15/12/7.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGSelectedCaseCell.h"
#import "NSString+Helper.h"

@interface EGSelectedCaseCell()<UITextFieldDelegate>{

    NSArray *_btns;
}


@property (nonatomic,strong) EGCartItem *item;

@end


@implementation EGSelectedCaseCell



#pragma mark - life cycle

- (void)awakeFromNib {
    _currentSelected = -1;
    //
    _donationLabel.text = HKLocalizedString(@"捐款金额");
    _donationLabel.font = [UIFont boldSystemFontOfSize:NormalFontSize];
    _receiverLabel.text = HKLocalizedString(@"受助者收到金额");
    _receiverLabel.font = [UIFont boldSystemFontOfSize:NormalFontSize];
    _pointLabel.text = HKLocalizedString(@"目标金额");
    _nocaseLabel.text = HKLocalizedString(@"专案目标已经达到,请支持其他意赠项目");
    _nocaseLabel.font = [UIFont boldSystemFontOfSize:NormalFontSize];
    
    _caseNameLabel.font = [UIFont boldSystemFontOfSize:NormalFontSize];
    _donationMoneyLabel.font = [UIFont boldSystemFontOfSize:NormalFontSize];
    _receivermoneyLabel.font = [UIFont boldSystemFontOfSize:NormalFontSize];
    
    //
    _btns = @[self.firstButton,self.secondButton,self.thirdButton,self.fourButton];
    [_checkBox setImage:[UIImage imageNamed:@"cart_checkbox_nor"] forState:UIControlStateNormal];
    [_checkBox setImage:[UIImage imageNamed:@"cart_checkbox_sel"] forState:UIControlStateSelected];
    [_checkBox addTarget:self action:@selector(checkBoxClick:) forControlEvents:UIControlEventTouchUpInside];
    
//    self.fourButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.fourButton setTitle:HKLocalizedString(@"其他") forState:UIControlStateNormal];
    _moneyField = [UITextField new];
    _moneyField.placeholder = @"HK$";
    _moneyField.keyboardType = UIKeyboardTypeNumberPad;
    _moneyField.returnKeyType = UIReturnKeyDone;
    _moneyField.adjustsFontSizeToFitWidth = YES;
    _moneyField.borderStyle = UITextBorderStyleRoundedRect;
    _moneyField.delegate = self;
    [_fourButton addSubview:_moneyField];
    
    [_moneyField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_fourButton);
        make.leading.equalTo(_fourButton).offset(50);
        make.right.equalTo(_fourButton).offset(-10);
        make.height.mas_equalTo(35);
    }];
    
    
    for (int i=0; i<_btns.count; i++) {
        UIButton *btn = _btns[i];
        btn.tag = i;
        btn.layer.borderColor = [UIColor colorWithHexString:@"#531E7E"].CGColor;
        
//        [btn setTintColor:[UIColor clearColor]];
        if (i!=3) {
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:NormalFontSize+2];
            [btn setImage:[UIImage imageNamed:@"cart_case_tick"] forState:UIControlStateSelected];
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15);
        }else{
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:NormalFontSize];
        }
        
        
        btn.layer.borderWidth = 1;
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        
        [btn setTitleColor:[UIColor colorWithHexString:@"#531E7E"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn.titleLabel setBackgroundColor:[UIColor clearColor]];

        
        [btn addTarget:self action:@selector(btnSelect:) forControlEvents:UIControlEventTouchUpInside];
        

    }
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



+ (instancetype)cellWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath item:(EGCartItem *)item{

    EGSelectedCaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"EGSelectedCaseCell" owner:self options:nil] lastObject];
        cell.bgView.backgroundColor = [UIColor colorWithHexString:@"#EAF8E5"];
        cell.btnBgView.backgroundColor = [UIColor colorWithHexString:@"#EAF8E5"];
        cell.bgView.layer.cornerRadius = 6.0;
        cell.bgView.layer.masksToBounds = YES;
        cell.caseNameLabel.textColor = [UIColor colorWithHexString:@"#63B227"];
        
    }
    
    cell.item = item ;
    cell.row = indexPath.row;
    
    if (indexPath.row!=0) {
        cell.topBgView.backgroundColor = [UIColor colorWithHexString:@"#e5e5e4"];
        cell.bgView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        cell.bgView.layer.borderWidth = 1;
        cell.bgView.layer.borderColor = [UIColor colorWithHexString:@"#cccccc"].CGColor;
        cell.btnBgView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    }else{
        cell.topBgView.backgroundColor = [UIColor colorWithHexString:@"#f0f8e9"];
        cell.bgView.layer.borderWidth = 1;
        cell.bgView.layer.borderColor = [UIColor colorWithHexString:@"#cccccc"].CGColor;
    }
    
    //
    cell.caseNameLabel.text = item.Title;
//    cell.donationMoneyLabel.text = [NSString stringWithFormat:@"HK$ %ld",item.DonateAmt];
//    cell.receivermoneyLabel.text = [NSString stringWithFormat:@"HK$ %ld",item.ReceiveAmt];
    cell.donationMoneyLabel.text = [NSString stringWithFormat:@"HK$ %@",[NSString countNumAndChangeformat:[NSString stringWithFormat:@"%ld",item.DonateAmt]]];
    cell.receivermoneyLabel.text = [NSString stringWithFormat:@"HK$ %@",[NSString countNumAndChangeformat:[NSString stringWithFormat:@"%ld",item.ReceiveAmt]]];
    cell.minDonateAmt = item.MinDonateAmt;
    
    
    [cell.firstButton setTitle:[NSString stringWithFormat:@"HK$ %@" ,[NSString countNumAndChangeformat:[NSString stringWithFormat:@"%ld",item.PayOption1]]] forState:UIControlStateNormal];
    [cell.secondButton setTitle:[NSString stringWithFormat:@"HK$ %@" ,[NSString countNumAndChangeformat:[NSString stringWithFormat:@"%ld",item.PayOption2]]] forState:UIControlStateNormal];
    if (indexPath.row != 0) {
        cell.pointLabel.hidden = NO;
        [cell.thirdButton setTitle:[NSString stringWithFormat:@"* HK$ %@" ,[NSString countNumAndChangeformat:[NSString stringWithFormat:@"%ld",item.PayOption3]]] forState:UIControlStateNormal];
    }else{
        cell.pointLabel.hidden = YES;
        [cell.thirdButton setTitle:[NSString stringWithFormat:@"HK$ %@" ,[NSString countNumAndChangeformat:[NSString stringWithFormat:@"%ld",item.PayOption3]]] forState:UIControlStateNormal];
    }
    
    
    
    
    //
    cell.checkBox.selected = item.IsChecked;
    CGFloat selectedOption = item.SelectedOption;
    if (selectedOption==item.PayOption1) {
        [cell btnSelect:cell.firstButton];
        cell.currentSelected = 0;
    }else if (selectedOption==item.PayOption2) {
        [cell btnSelect:cell.secondButton];
        cell.currentSelected = 1;
    }else if (selectedOption==item.PayOption3) {
        [cell btnSelect:cell.thirdButton];
        cell.currentSelected = 2;
    }else{
        
        [cell btnSelect:cell.fourButton];
        
        if (item.SelectedOption>0) {
            cell.moneyField.text = [NSString stringWithFormat:@"%ld",item.SelectedOption];
            
            if(item.IsChecked){
                NSString *inputMoney = cell.moneyField.text;
                
                
                if (inputMoney.length>0) {
                    if (inputMoney.integerValue < item.MinDonateAmt) {
                        cell.donationLabel.textColor = [UIColor redColor];
                        cell.donationLabel.text = [NSString stringWithFormat:HKLocalizedString(@"min_donation"),item.MinDonateAmt];
                        cell.donationMoneyLabel.textColor = [UIColor redColor];
                        cell.receivermoneyLabel.textColor = [UIColor redColor];
                    }
                }
            }
        }
        
        
        
        cell.currentSelected = 3;
    }
    
    if (item.IsChecked) {
        
    }else{
        //
        cell.currentSelected = -1;
        cell.checkBox.selected = NO;
        
        cell.donationMoneyLabel.text = [NSString stringWithFormat:@"HK$ 0"];
        cell.receivermoneyLabel.text = [NSString stringWithFormat:@"HK$ 0"];
    }
    
    
    
    
    if(item.PayOption1==0 && item.PayOption2==0 && item.PayOption3==0){
    
        cell.btnBgView.hidden = YES;
        cell.checkBox.hidden = YES;
        cell.nocaseLabel.hidden = NO;
    }else{
        cell.btnBgView.hidden = NO;
        cell.checkBox.hidden = NO;
        cell.nocaseLabel.hidden = YES;
    }
    
    
//    if (item.IsChecked) {
//        cell.checkBox.selected = YES;
//        CGFloat selectedOption = item.SelectedOption;
//        if (selectedOption==item.PayOption1) {
//            [cell btnSelect:cell.firstButton];
//            cell.currentSelected = 0;
//        }else if (selectedOption==item.PayOption2) {
//            [cell btnSelect:cell.secondButton];
//            cell.currentSelected = 1;
//        }else if (selectedOption==item.PayOption3) {
//
//            [cell btnSelect:cell.thirdButton];
//            cell.currentSelected = 2;
//        }else{
//
//            [cell btnSelect:cell.fourButton];
//            cell.moneyField.text = [NSString stringWithFormat:@"%ld",item.SelectedOption];
//            cell.currentSelected = 3;
//        }
//    }else{
//        //
//        cell.currentSelected = -1;
//        cell.checkBox.selected = NO;
//        
//        cell.donationMoneyLabel.text = [NSString stringWithFormat:@"HK$ 0"];
//        cell.receivermoneyLabel.text = [NSString stringWithFormat:@"HK$ 0"];
//    }
    
    
    return cell;
}


#pragma mark - touch event
-(void)btnSelect:(UIButton *)btn{
    
    NSInteger tag = btn.tag;
    
    if (_currentSelected==tag) return;
    
    _currentSelected = tag;
    btn.selected = YES;
    btn.backgroundColor = [UIColor colorWithHexString:@"#69318f"];
    
    for (int i=0; i<_btns.count; i++) {
        if (i!=tag) {
            UIButton *btn = _btns[i];
            btn.selected = NO;
            btn.backgroundColor = [UIColor whiteColor];
        }
    }
    
    if (tag==3) {
//        [_moneyField becomeFirstResponder];
    }
    
    switch (tag) {
        case 0:
            //_item.DonateAmt = _item.PayOption1;
            _item.SelectedOption = _item.PayOption1;
            break;
        case 1:
            //_item.DonateAmt = _item.PayOption2;
            _item.SelectedOption = _item.PayOption2;
            break;
        case 2:
            //_item.DonateAmt = _item.PayOption3;
            _item.SelectedOption = _item.PayOption3;
            [self.thirdButton setTitle:[NSString stringWithFormat:@"HK$ %@" ,[NSString countNumAndChangeformat:[NSString stringWithFormat:@"%ld",_item.PayOption3]]] forState:UIControlStateNormal];
            break;
        case 3:
            
            if (_item.SelectedOption == _item.PayOption1 || _item.SelectedOption == _item.PayOption2 || _item.SelectedOption == _item.PayOption3) {
                _item.SelectedOption = 0;
            }else{
                //_item.SelectedOption = 0;
            }
            
            
            //未输入数字的时候不作计算，还是用回之前的数据
            //_donationMoneyLabel.text = [NSString stringWithFormat:@"HK$ 0"];
            //_receivermoneyLabel.text = @"HK$ 0";
            break;
        default:
            break;
    }
    
    //修改数据之后同步服务端
    if (self.checkBox.isSelected && tag != 3) {
        if (_block) {
            _block(_item,_row);
        }
    }
}


-(void)checkBoxClick:(UIButton *)btn{
    btn.selected = btn.selected ? NO : YES;
    
    if(btn.selected){
        
        _item.IsChecked = YES;
        NSInteger selectOption = _item.SelectedOption;
        if (selectOption==_item.PayOption1) {
            self.firstButton.selected = YES;
            self.currentSelected = 0;
            _item.DonateAmt = _item.PayOption1;
        }else if (selectOption==_item.PayOption2) {
            self.secondButton.selected = YES;
            self.currentSelected = 1;
            _item.DonateAmt = _item.PayOption2;
        }else if (selectOption==_item.PayOption3) {
            self.thirdButton.selected = YES;
            self.currentSelected = 2;
            _item.DonateAmt = _item.PayOption3;
        }else{
            self.fourButton.selected = YES;
            self.currentSelected = 3;
        }
        
        
        
        //DLOG(@"%@",_item);
        if (_block) {
            _block(_item,_row);
        }
        
    }else{
        _item.IsChecked = NO;
        _block(_item,_row);
        
    }
    
}

#pragma mark - textfield delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
//    if (_currentSelected==3) {
//        return;
//    }
    
    self.fourButton.selected = YES;
    _currentSelected = 3;

    _fourButton.backgroundColor = [UIColor colorWithHexString:@"#531E7E"];
    
    for (int i=0; i<_btns.count; i++) {
        if (i!=3) {
            UIButton *btn = _btns[i];
            btn.selected = NO;
            btn.backgroundColor = [UIColor whiteColor];
        }
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    NSString *inputMoney = textField.text;
    
    
    if (inputMoney.length>0) {
        if (inputMoney.floatValue < self.minDonateAmt) {
            self.donationLabel.textColor = [UIColor redColor];
            self.donationLabel.text = [NSString stringWithFormat:HKLocalizedString(@"min_donation"),self.minDonateAmt];
        }
        
        NSInteger money = roundf(inputMoney.floatValue);
        _item.SelectedOption = money;
        
        
        //
        if (self.checkBox.isSelected) {
            if (_block) {
                _block(_item,_row);
            }
        }
       
    }
}

#pragma mark - setter
-(void)setFeeStyle:(EGDonationCounterFeeStyle)feeStyle{
    if (feeStyle!=_feeStyle) {
       
    }
    
    _feeStyle = feeStyle;
    
    if (_checkBox.isSelected && _item.SelectedOption>0) {
        
        NSDictionary *dict = [self CalculationFee:_item.SelectedOption];
        NSInteger donation = [dict[kDonationAmount] integerValue];
        NSInteger reveiver = [dict[kReceiverAmount] integerValue];
        _item.DonateAmt = donation;
        _item.ReceiveAmt = reveiver;
        
        self.donationMoneyLabel.text = [NSString stringWithFormat:@"HK$ %@",[NSString countNumAndChangeformat:[NSString stringWithFormat:@"%ld",_item.DonateAmt]]];
        self.receivermoneyLabel.text = [NSString stringWithFormat:@"HK$ %@",[NSString countNumAndChangeformat:[NSString stringWithFormat:@"%ld",_item.ReceiveAmt]]];
    }
    
    if(_styleChangeBlock){
        _styleChangeBlock(_item,_row);
    }
}


#pragma mark 计算包括手续费在内的捐款金额
-(NSDictionary *)CalculationFee:(NSInteger )value{
    
    //2.35的平均值
    CGFloat fee = 2.35 / _numberOfSelectedCase;
    
    NSInteger donationCount;//捐款金额
    
    NSInteger receiverCount;//收到金额
    
    CGFloat amt;
    
    switch (_feeStyle) {
        case EGDonationHKContainFee:
            
            amt = (value + fee)/(1 - 3.9*0.01);
            donationCount = roundf(amt + 0.5);
            receiverCount = value;
            break;
        case EGDonationHKUnContainFee:
            donationCount = value;
            receiverCount = donationCount - roundf(value*3.9/100 + fee + 0.5);
            
            break;
        case EGDonationUnHKContainFee:
            amt = (value + fee)/(1 - 4.4*0.01);
            donationCount = roundf(amt + 0.5);
            receiverCount = value;
            break;
        case EGDonationUnHKUnContainFee:
            donationCount = value;
            receiverCount = donationCount - roundf(value*4.4/100 + fee + 0.5);
            break;
        default:
            break;
    }
    
    
    NSDictionary *dict = @{kDonationAmount:@(donationCount),kReceiverAmount:@(receiverCount)};
    
    return dict;
}

@end
