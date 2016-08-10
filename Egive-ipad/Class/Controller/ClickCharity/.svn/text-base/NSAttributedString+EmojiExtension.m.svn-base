//
//  NSAttributedString+EmojiExtension.m
//  Egive-ipad
//
//  Created by 123 on 15/12/25.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "NSAttributedString+EmojiExtension.h"
#import <UIKit/UIKit.h>
#import "EGEmojiTextAttachment.h"

@implementation NSAttributedString (EmojiExtension)

- (NSString *)getPlainString {
    NSMutableString *plainString = [NSMutableString stringWithString:self.string];
    __block NSUInteger base = 0;
    
    [self enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.length)
                     options:0
                  usingBlock:^(id value, NSRange range, BOOL *stop) {
                      if (value && [value isKindOfClass:[EGEmojiTextAttachment class]]) {
                          [plainString replaceCharactersInRange:NSMakeRange(range.location + base, range.length)
                                                     withString:((EGEmojiTextAttachment *) value).emojiTag];
                          base += ((EGEmojiTextAttachment *) value).emojiTag.length - 1;
                      }
                  }];
    
    return plainString;
}


@end
