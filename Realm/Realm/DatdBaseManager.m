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
    if (index<0 || index>[self numberOfDefaultDBCount] ||[self numberOfDefaultDBCount]==0) return nil;
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


@end
