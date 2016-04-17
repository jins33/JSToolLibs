//
//  CoreDataManager.m
//  CoreDataTest
//
//  Created by hjs on 16/3/20.
//  Copyright © 2016年 hjs. All rights reserved.
//

#import "CoreDataManager.h"
#define MODELNAME @"Aiugo"

@implementation CoreDataManager

+ (instancetype)manager{
    static id sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    if ([sharedInstance context] == nil) {
        [sharedInstance initContext];
    }
    return sharedInstance;
}

//搭建上下文环境
- (void)initContext{
    // 初始化模型文件
    if(_managedObjectModel == nil){
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:MODELNAME withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    // 传入模型对象，初始化NSPersistentStoreCoordinator
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
    // 构建SQLite数据库文件的路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSURL *url = [NSURL fileURLWithPath:[doc stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", MODELNAME]]];
    NSLog(@"path: %@", [url path]);
    
    // 添加持久化存储库，这里使用SQLite作为存储库
    NSDictionary *optionsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],
                                       NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES],
                                       NSInferMappingModelAutomaticallyOption, nil];
    NSError *error = nil;
    NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:optionsDictionary error:&error];
    if (store == nil) {// 直接抛异常
        [NSException raise:@"数据库创建出错" format:@"%@", [error localizedDescription]];
    }
    // 初始化上下文，设置persistentStoreCoordinator属性
    self.context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.context.persistentStoreCoordinator = psc;
}

// 利用上下文对象，将数据同步到持久化存储库
-(void)saveContext{
    NSError *error = nil;
    if (self.context != nil) {
        if ([self.context hasChanges] && ![self.context save:&error]) {
            [NSException raise:@"访问数据库错误" format:@"%@", [error localizedDescription]];
        }
    }
}

//清空实体表内容
- (void)clearEntityTable:(NSString *)entityName{
    NSArray *entityArray = [self queryEntityName:entityName withCondition:@""];
    for (NSManagedObject *obj in entityArray) {
        [self.context deleteObject:obj];
    }
    [self saveContext];
}

//按条件删除
- (void)deleteEntityName:(NSString *)entityName withCondition:(NSString *)condition{
    NSArray *entityArray = [self queryEntityName:entityName withCondition:condition];
    for (NSManagedObject *obj in entityArray) {
        [self.context deleteObject:obj];
    }
    [self saveContext];
}

//按条件无序查询
- (NSArray *)queryEntityName:(NSString *)entityName withCondition:(NSString *)condition{
//    NSLog(@"entityName %@ condition %@",entityName , condition);
    NSError *error = nil;
    
    // 初始化一个查询请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    // 设置要查询的实体
    request.entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.context];
    
    if (condition != nil && ![condition isEqualToString:@""]) {
        //设置条件过滤
        NSPredicate *predicate = [NSPredicate predicateWithFormat:condition];
        request.predicate = predicate;
    }
    return [self.context executeFetchRequest:request error:&error];
}

//按条件升降序查询
- (NSArray *)queryEntityName:(NSString *)entityName withCondition:(NSString *)condition paraName:(NSString *)paraName isAsc:(BOOL)isAsc{
//    NSLog(@"entityName %@ condition %@",entityName , condition);
    NSError *error = nil;
    
    // 初始化一个查询请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    // 设置要查询的实体
    request.entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.context];
    
    // 设置排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:paraName ascending:isAsc];
    request.sortDescriptors = [NSArray arrayWithObject:sort];
    
    if (condition != nil && ![condition isEqualToString:@""]) {
        //设置条件过滤
        NSPredicate *predicate = [NSPredicate predicateWithFormat:condition];
        request.predicate = predicate;
    }
    return [self.context executeFetchRequest:request error:&error];
}

@end
