

#import "UILabel+addtion.h"

@implementation UILabel (addtion)

+(UILabel *)createWithSize:(CGFloat)size{
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:size];
    
    return label;
}

@end
