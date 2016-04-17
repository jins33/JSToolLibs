//
//  CoreDataManager.h
//  CoreDataTest
//
//  Created by hjs on 16/3/20.
//  Copyright © 2016年 hjs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataManager : NSObject


@property NSManagedObjectContext *context;
@property NSManagedObjectModel *managedObjectModel;

+(instancetype)manager;

- (void)initContext;

-(void)saveContext;

//按条件查询
- (NSArray *)queryEntityName:(NSString *)entityName withCondition:(NSString *)condition;
//按条件删除
- (void)deleteEntityName:(NSString *)entityName withCondition:(NSString *)condition;
//按条件升降序查询
- (NSArray *)queryEntityName:(NSString *)entityName withCondition:(NSString *)condition paraName:(NSString *)paraName isAsc:(BOOL)isAsc;

//清空实体表内容
- (void)clearEntityTable:(NSString *)entityName;

@end
