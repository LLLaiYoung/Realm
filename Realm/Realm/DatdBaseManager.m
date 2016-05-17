//
//  DateBaseManager.m
//  Realm
//
//  Created by chairman on 16/5/13.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import "DataBaseManager.h"
#import "HiSchool.h"
#import <UIKit/UIKit.h>
#define WEAKSELF __weak typeof(self) weakSelf = self;
@interface DataBaseManager()

@end
@implementation DataBaseManager
+ (instancetype)defaultManager {
    static DataBaseManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DataBaseManager alloc] init];
    });
    return manager;
}

#pragma mark - Private methods
/**
 *  获取数据库路径
 *
 *  @param dbName 数据库名称
 *
 *  @return 自定义数据库路径
 */
- (NSURL *)dataBasePath:(NSString *)dbName {
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbPath = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.realm",dbName]];
    return [NSURL URLWithString:dbPath];
}
// * 生成64位随机字符串作为主键 */
-(NSString *)ret64bitString {
    char data[64];
    for (int x=0; x <64; data[x++] = (char)('A' + (arc4random_uniform(26))));
    return [[NSString alloc] initWithBytes:data length:64 encoding:NSUTF8StringEncoding];
}
#pragma mark - Public methods
#pragma mark - DefaultDataBase
- (NSUInteger)numberOfDefaultDBCount {
    return [[HiSchool allObjects] count];
}

- (BOOL)insertDefaultDBWithHiSchool:(HiSchool *)hiSchool {
    if (hiSchool.title.length==0) return NO;
    //使用默认数据库
    RLMRealm *realm = [RLMRealm defaultRealm];
    //查看数据库路径
    NSLog(@"realmPath = %@",realm.configuration.fileURL);
    [realm beginWriteTransaction];
    NSDictionary *dic = @{
                          kRealmPrimaryKey:[self ret64bitString],
                          kRealmAvatarData:hiSchool.avatar,
                          kRealmTitle:hiSchool.title,
                          kRealmSubtitle:hiSchool.subTitle,
                          kRealmAge:hiSchool.age,
                          kRealmDate:hiSchool.date,
                          kRealmMale:hiSchool.isMale,
                          kRealmWeight:hiSchool.weight,
                          kRealmHeight:hiSchool.height
                          };
    [HiSchool createInDefaultRealmWithValue:dic];
    NSError *error = nil;
    if ([realm commitWriteTransaction:&error]) return YES;
    NSLog(@"%@",error);
    return NO;
}

- (void)deleteDefaultDBWithHiSchool:(HiSchool *)hiSchool {
    if (hiSchool.title.length==0) return;
    RLMRealm *realm = RLMRealm.defaultRealm;
    [realm beginWriteTransaction];
    [realm deleteObject:hiSchool];
    [realm commitWriteTransaction];
}

- (void)deleteDefaultDBHischoolNumberOfIndex:(NSInteger)index {
    if (index<0) return;
    RLMRealm *realm = RLMRealm.defaultRealm;
    HiSchool *hiSchool = [self queryDefaultDBWithHiSchoolNumberOfIndex:index];
    [realm transactionWithBlock:^{
        [realm deleteObject:hiSchool];
    }];
}

- (void)deleteDefaultDBAllObjects {
    RLMRealm *realm = RLMRealm.defaultRealm;
    [realm beginWriteTransaction];
    [realm deleteAllObjects];
    [realm commitWriteTransaction];
}

- (void)updateDefaultDBWithHiSchool:(HiSchool *)hiSchool {
    if (hiSchool.title.length==0) return;
    RLMRealm *realm = RLMRealm.defaultRealm;
    [realm transactionWithBlock:^{
        [HiSchool createOrUpdateInRealm:realm withValue:hiSchool];
    }];
}

- (void)updateDefaultDBWithArray:(NSArray<HiSchool *> *)hiSchools {
    if (hiSchools.count==0) return;
    RLMRealm *realm = RLMRealm.defaultRealm;
    [realm transactionWithBlock:^{
        [realm addOrUpdateObjectsFromArray:hiSchools];
    }];
}

- (RLMResults *)queryDefaultDBAllObjects {
    return [HiSchool allObjects];
}

- (HiSchool *)queryDefaultDBWithHiSchoolNumberOfIndex:(NSInteger)index {
    if (index<0 || index>[self numberOfDefaultDBCount]) return nil;
    HiSchool *hiSchool = [self queryDefaultDBAllObjects][index];
    return hiSchool;
}

- (RLMResults *)queryDefaultDBWithContains:(NSString *)contain {
    /** 断言查询 */
    return [HiSchool objectsWhere:[NSString stringWithFormat:@"title = '%@'",contain]];
    
    //** NSPredicate 查询 */ //[c] 不区分大小写
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title contains[c] %@",contain];
//    return [HiSchool objectsWithPredicate:predicate];
}

- (RLMResults *)sortDefaultDBWithProperty:(id)property ascending:(BOOL)yesOrNo {
    return [[HiSchool allObjects] sortedResultsUsingProperty:property ascending:yesOrNo];
}
#pragma mark - CustomDataBase
- (NSUInteger)numberOfCustomDBCountWithDBName:(NSString *)dbName {
    if (dbName.length==0) return 0;
    RLMRealm *realm = [RLMRealm realmWithURL:[self dataBasePath:kRealmCustomDBName]];
    return [HiSchool allObjectsInRealm:realm].count;
}

- (void)insertCustomDBWithDBName:(NSString *)dbName OfHiSchool:(HiSchool *)hiSchool {
    if (hiSchool.title.length==0 || dbName.length==0) return;
//    RLMRealm *realm = [RLMRealm realmWithURL:[self dataBasePath:kRealmCustomDBName]];
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    config.fileURL = [self dataBasePath:kRealmCustomDBName];
    config.readOnly = NO;
    RLMRealm *realm = [RLMRealm realmWithConfiguration:config error:nil];
    NSLog(@"path = %@",realm.configuration.fileURL);
    WEAKSELF
    [realm transactionWithBlock:^{
        NSDictionary *dic = @{
                              kRealmPrimaryKey:[weakSelf ret64bitString],
                              kRealmAvatarData:hiSchool.avatar,
                              kRealmTitle:hiSchool.title,
                              kRealmSubtitle:hiSchool.subTitle,
                              kRealmAge:hiSchool.age,
                              kRealmDate:hiSchool.date,
                              kRealmMale:hiSchool.isMale,
                              kRealmWeight:hiSchool.weight,
                              kRealmHeight:hiSchool.height
                              };
        [HiSchool createInRealm:realm withValue:dic];
    }];
}


- (void)deleteCustomDBWithDBName:(NSString *)dbName OfHiSchool:(HiSchool *)hiSchool {
    if (dbName.length==0 || hiSchool.title.length==0) return;
    RLMRealm *realm = [RLMRealm realmWithURL:[self dataBasePath:kRealmCustomDBName]];
    [realm beginWriteTransaction];
    [realm deleteObject:hiSchool];
    [realm commitWriteTransaction];
}

- (void)deleteCustomDBWithDBname:(NSString *)dbName hiSchoolOfIndex:(NSInteger)index {
    if (dbName.length==0 || index<0) return;
    RLMRealm *realm = [RLMRealm realmWithURL:[self dataBasePath:kRealmCustomDBName]];
    HiSchool *hiSchool = [self queryCustomDBWithDBName:dbName OfIndex:index];
    [realm transactionWithBlock:^{
        [realm deleteObject:hiSchool];
    }];
}

- (void)deleteCustomDBAllObajectsWithDBName:(NSString *)dbName {
    if (dbName.length==0) return;
    RLMRealm *realm = [RLMRealm realmWithURL:[self dataBasePath:dbName]];
    [realm beginWriteTransaction];
    [realm deleteAllObjects];
    [realm commitWriteTransaction];
}


- (void)updateCustomDBWithDBName:(NSString *)dbName OfHiSchool:(HiSchool *)hiSchool {
    if (dbName.length==0 || hiSchool.title.length==0) return;
    RLMRealm *realm = [RLMRealm realmWithURL:[self dataBasePath:dbName]];
    [realm transactionWithBlock:^{
        [realm addObject:hiSchool];
    }];
}

- (void)updateCustomDBWithDBName:(NSString *)dbName OfObjects:(NSArray<HiSchool *> *)hiSchools {
    if (dbName.length==0 || hiSchools.count==0) return;
    RLMRealm *realm = [RLMRealm realmWithURL:[NSURL URLWithString:dbName]];
    [realm beginWriteTransaction];
    [realm addOrUpdateObjectsFromArray:hiSchools];
    [realm commitWriteTransaction];
}

- (HiSchool *)queryCustomDBWithDBName:(NSString *)dbName OfIndex:(NSInteger)index {
    if (dbName.length==0) return nil;
    if (index<0 || index>[self numberOfCustomDBCountWithDBName:dbName]) return nil;
    HiSchool *hiSchool = [self queryCustomDBAllObjectsWithDBName:dbName][index];
    return hiSchool;
}


#warning 判断数据库是否存在 NSFileManager
- (RLMResults *)queryCustomDBAllObjectsWithDBName:(NSString *)dbName {
    if (dbName.length==0) return nil;
    RLMRealm *realm = [RLMRealm realmWithURL:[NSURL URLWithString:dbName]];
    return [HiSchool allObjectsInRealm:realm];
}

@end
