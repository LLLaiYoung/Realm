//
//  DateBaseManager.h
//  Realm
//
//  Created by chairman on 16/5/13.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
static NSString *const kRealmCustomDBName = @"HiSchool";
@class HiSchool;
@interface DataBaseManager : NSObject
#warning  Update values must be within the 'transactionWithBlock' to modify in the calling this function
/** 单例 */
+ (instancetype)defaultManager;
#pragma mark - DefaultDataBase
/** 返回总个数 ->默认数据库 */
- (NSUInteger)numberOfDefaultDBCount;//YES
/** 插入一条数据 ->默认数据库*/
- (BOOL)insertDefaultDBWithHiSchool:(HiSchool *)hiSchool;//YES
/** 删除一条数据 ->默认数据库*/
- (void)deleteDefaultDBWithHiSchool:(HiSchool *)hiSchool;//YES
/** 根据index删除一条数据 ->默认数据库 */
- (void)deleteDefaultDBHischoolNumberOfIndex:(NSInteger)index;//YES
/** 删除数据库所有对象 ->默认数据库 */
- (void)deleteDefaultDBAllObjects;//YES
/** 更新一条数据 ->默认数据库 */
- (void)updateDefaultDBWithHiSchool:(HiSchool *)hiSchool;//YES
/** 更新多条数据 ->默认数据库 */
- (void)updateDefaultDBWithArray:(NSArray<HiSchool *> *)hiSchools;//YES
/** 根据index返回单个对象 ->默认数据库*/
- (HiSchool *)queryDefaultDBWithHiSchoolNumberOfIndex:(NSInteger)index;//YES
/** 获取数据库所有对象 ->默认数据库*/
- (RLMResults *)queryDefaultDBAllObjects;//YES
/** 条件查询 */
- (RLMResults *)queryDefaultDBWithContains:(NSString *)contain;//YES
/** 排序查询 */
- (RLMResults *)sortDefaultDBWithProperty:(id)property ascending:(BOOL)yesOrNo;//YES

@end
