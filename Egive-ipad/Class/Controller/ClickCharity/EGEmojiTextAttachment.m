//
//  EGEmojiTextAttachment.m
//  Egive-ipad
//
//  Created by 123 on 15/12/25.
//  Copyright © 2015年 Sino. All rights reserved.
//

#import "EGEmojiTextAttachment.h"

@interface EGEmojiTextAttachment ()

@end

@implementation EGEmojiTextAttachment

- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex {
    return CGRectMake(0, 0, _emojiSize.width, _emojiSize.height);
}

@end
