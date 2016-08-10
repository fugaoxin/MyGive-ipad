//
//  EGMyFMDataBase.h
//  Egive-ipad
//
//  Created by 123 on 16/1/7.
//  Copyright © 2016年 Sino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface EGMyFMDataBase : NSObject

+(EGMyFMDataBase *)shareFMDataBase;

-(void)openDataBase;//打开数据库

-(BOOL)closeDB;//关闭数据库

-(void)creatTableWithTableName:(NSString *)tableName andArray:(NSMutableArray *)Array;//创建一个表单

-(void)tableDeleteDataWithTableName:(NSString *)tableName;//删除数据

-(void)tableInsertWithTableName:(NSString *)tableName andArray:(NSMutableArray *)Array;//插入数据

-(NSMutableArray *)tableSelectedWithTableName:(NSString*)TableName;//查询数据

@end
