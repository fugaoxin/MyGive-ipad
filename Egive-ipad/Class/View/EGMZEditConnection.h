//
//  EGMZEditConnection.h
//  Egive-ipad
//
//  Created by vincentmac on 15/12/26.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGBaseView.h"

@interface EGMZEditConnection : EGBaseView

@property (weak, nonatomic) IBOutlet UILabel *conNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *conNameDetailLabel;

@property (weak, nonatomic) IBOutlet UILabel *Label1;

@property (weak, nonatomic) IBOutlet UILabel *Label2;

@property (weak, nonatomic) IBOutlet UILabel *Label3;

@property (weak, nonatomic) IBOutlet UILabel *Label4;

@property (weak, nonatomic) IBOutlet UILabel *Label5;

@property (weak, nonatomic) IBOutlet UITextField *Field1;

@property (weak, nonatomic) IBOutlet UITextField *Field2;

@property (weak, nonatomic) IBOutlet UITextField *Field3;

@property (weak, nonatomic) IBOutlet UITextField *Field4;

@property (weak, nonatomic) IBOutlet UITextField *Field5;

@property (weak, nonatomic) IBOutlet UISegmentedControl *addSeg;

@property (weak, nonatomic) IBOutlet UIButton *dropButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineConstraint;

@property (weak, nonatomic) IBOutlet UITextField *otherField;

@end
