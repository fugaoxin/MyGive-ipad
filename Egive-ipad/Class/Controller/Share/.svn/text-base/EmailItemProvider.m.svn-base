//
//  EmailItemProvider.m
//  Egive
//
//  Created by vincentmac on 15/10/26.
//  Copyright (c) 2015年 sino. All rights reserved.
//

#import "EmailItemProvider.h"


@interface EmailItemProvider()<UIActivityItemSource>

@end

@implementation EmailItemProvider

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController {
    return _body;
}

- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType {
    return _body;
}

- (NSString *)activityViewController:(UIActivityViewController *)activityViewController subjectForActivityType:(NSString *)activityType {
    return _subject;
}

@end
