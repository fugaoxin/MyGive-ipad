//
//  EGPAndCMemberZoneBaseVC.m
//  Egive-ipad
//
//  Created by vincentmac on 15/12/26.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGPAndCMemberZoneBaseVC.h"
#import "EGMemberZoneModel.h"

@interface EGPAndCMemberZoneBaseVC ()

@end

@implementation EGPAndCMemberZoneBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getSelections];
    
    if ([self respondsToSelector:@selector(setupUI)]) {
        [self  setupUI];
    }
    
    if ([self respondsToSelector:@selector(loadData)]) {
        [self loadData];
    }
}



-(void)getSelections{
    
    NSDictionary* dict=[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"EGIVE_MemberFormModel_%ld_kevin",[Language getLanguage]]];
    
    NSDictionary* engDict=[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"EGIVE_MemberFormModel_%ld_kevin",EN]];
    
    self.selections = dict;
    
    if (dict!=nil) {
        NSArray *a  =  engDict[@"AgeGroupOptions"][@"options"];
        _ageGroups = [NSMutableArray arrayWithArray:a];
        [_ageGroups removeObjectAtIndex:0];
        
        //EducationLevelOptions
        _educationLevels =  dict[@"EducationLevelOptions"][@"options"];
        
        //BelongToOptions
        _belongToOptions = dict[@"BelongToOptions"][@"options"];
        
        //PositionOptions
        _jobs = dict[@"PositionOptions"][@"options"];
        
        //BusinessRegistrationType
        NSArray *array = dict[@"BusinessRegistrationTypeOptions"][@"options"];
        _businessRegistrationType = [NSMutableArray arrayWithArray:array];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
