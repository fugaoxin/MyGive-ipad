//
//  EGBaseView.m
//  Egive-ipad
//
//  Created by vincentmac on 15/12/26.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGBaseView.h"

@implementation EGBaseView


-(void)awakeFromNib{


}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        
        
    }
    return self;
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    if ([self respondsToSelector:@selector(refreshText)]) {
        [self refreshText];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChangeChange) name:@"LanguageChange" object:nil];
}

-(void)languageChangeChange{
    if ([self respondsToSelector:@selector(refreshText)]) {
        [self refreshText];
    }
}
@end
