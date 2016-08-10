//
//  EGMyFMDataBase.m
//  Egive-ipad
//
//  Created by 123 on 16/1/7.
//  Copyright © 2016年 Sino. All rights reserved.
//

#import "EGMyFMDataBase.h"

@interface EGMyFMDataBase ()
{
    FMDatabase *_dataBase;
}
@end

@implementation EGMyFMDataBase

+(EGMyFMDataBase *)shareFMDataBase{
    static EGMyFMDataBase *mDB = nil;
    if (mDB == nil) {
        mDB = [[super alloc]init];
    }
    return mDB;
}

#pragma mark - 打开数据库
-(void)openDataBase{
    //设置数据库的路径
    //路径为沙盒中的document中
    //document里面的文件不会自动删除（只能通过手动操作删除）
    //tem中是缓存文件，当内存到达一定限度，就会自动删除不常用的文件
    NSString *filePath = [NSString stringWithFormat:@"%@/Documents/EGEgiveIpa.sqlite",NSHomeDirectory()];
    
    //如果没有数据库，则创建一个然后打开；如果有，则直接使用该数据库
    _dataBase = [[FMDatabase alloc]initWithPath:filePath];
    
    //打开数据库
    if(!_dataBase.open){
        //DLOG(@"打开数据库失败");
        return;
    }
    //DLOG(@"打开成功");
}

#pragma mark - 关闭数据库
-(BOOL)closeDB{
    BOOL b = _dataBase.close;
    return b;
}

#pragma mark - 删除数据
-(void)tableDeleteDataWithTableName:(NSString *)tableName{
    NSString *sq = [NSString stringWithFormat:@"DELETE FROM %@",tableName];
    [_dataBase executeUpdate:sq];
}

#pragma mark - 查询数据
-(NSMutableArray *)tableSelectedWithTableName:(NSString*)TableName{
    //SELECT关键字，查询表单
    //FROM 从哪个表单中查询
    //studentInfo 表单名
    //    NSString *sql = @"SELECT *FROM studentInfo";
    NSString *sql = [NSString stringWithFormat:@"SELECT *FROM %@",TableName];
    
    //使用excuteQuery查询表单
    FMResultSet *result = [_dataBase executeQuery:sql];
    NSMutableArray *dataArray = [NSMutableArray array];
    while ([result next]) {
        NSString * str=[result stringForColumn:searchStr];
        [dataArray addObject:str];
    }
    return dataArray;
}

#pragma mark - 添加数据
-(void)tableInsertWithTableName:(NSString *)tableName andArray:(NSMutableArray *)Array{
    
    //INSERT INTO 插入一条数据
    //studentInfo 表单名
    //(name,age,gender,nick)插入数据的字段名
    //VALUES 对应的值，使用？标示在后面会赋值
    //    NSString *sql = @"INSERT INTO studentInfo(name,age,gender,nickName)VALUES(?,?,?,?)";
    for (int i=0;i<Array.count;i++) {
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@(%@)VALUES(%@)",tableName,searchStr,@"?"];
        [_dataBase executeUpdate:sql,Array[i]];
    }
}

#pragma mark - 创建一个表单
-(void)creatTableWithTableName:(NSString *)tableName andArray:(NSMutableArray *)Array{
    //studentInfo 是表单名（自己起）
    //name 是字段名
    //VARCHAR 字符串类型
    //    NSString *creatTableString = @"CREATE TABLE IF NOT EXISTS studentInfo(name VARCHAR(32),age INTEGER,gender INTEGER,nickName VARCHAR(32))";
    NSString *keysString = @"";
    for (int i=0;i<Array.count;i++) {
        if (keysString.length > 0) {
            keysString = [NSString stringWithFormat:@"%@,%@ VARCHAR(32)",keysString,searchStr];
        }
        else{
            keysString = [NSString stringWithFormat:@"%@ VARCHAR(32)",searchStr];
        }
    }
    NSString *creatTableString = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@)",tableName,keysString];
    [_dataBase executeUpdate:creatTableString];
}


@end
