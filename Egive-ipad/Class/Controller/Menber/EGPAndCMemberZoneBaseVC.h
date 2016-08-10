//
//  EGPAndCMemberZoneBaseVC.h
//  Egive-ipad
//
//  Created by vincentmac on 15/12/26.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGBaseViewController.h"
#import <TPKeyboardAvoiding/TPKeyboardAvoidingScrollView.h>

@interface EGPAndCMemberZoneBaseVC : EGBaseViewController


@property (strong, nonatomic)  TPKeyboardAvoidingScrollView *showScrollView;

@property (strong, nonatomic)  TPKeyboardAvoidingScrollView *editScrollView;

//@property (nonatomic,copy) NSArray *registTypeArray;


-(void)loadData;

-(void)setupUI;


//获取下拉选项
-(void)getSelections;

@property (copy, nonatomic) NSDictionary *selections;

@property (copy, nonatomic) NSMutableArray *ageGroups;

@property (copy, nonatomic) NSArray *educationLevels;

@property (copy, nonatomic) NSArray *belongToOptions;

@property (copy, nonatomic) NSArray *jobs;

@property (strong, nonatomic) NSMutableArray *businessRegistrationType;

- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size;

@end
