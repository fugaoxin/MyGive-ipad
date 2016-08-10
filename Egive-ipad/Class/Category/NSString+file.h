//
//  NSString+file.h
//  zw_shop
//
//  Created by iOS开发1 on 15/5/19.
//  Copyright (c) 2015年 zw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (file)

// 在文件名后拼接一段字符串（扩展名不变）
- (NSString *)fileNameAppendString:(NSString *)str;

// 根据count是否超过1万来返回字符串
+ (NSString *)withinWanStr:(int)count;

@end
