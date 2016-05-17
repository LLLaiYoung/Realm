//
//  HiSchool.m
//  Realm
//
//  Created by chairman on 16/5/13.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import "HiSchool.h"

@implementation HiSchool

// Specify default values for properties



// Specify properties to ignore (Realm won't persist these)
/**
 *  忽略属性(不在数据库中保存,即使写了保存到数据库中的语句)
 *  并且能够轻易重写它们的 setter 和 getter
 */
+ (NSArray *)ignoredProperties
{
    return @[kRealmWeight];
}

/** 
 * 设置必须的属性哪些不能为nil,如果为nil的话会抛出异常。
 * 不实现requiredProperties,NSData,Double会自动为nil
 */
+(NSArray<NSString *> *)requiredProperties {
    return @[kRealmAvatarData,kRealmDate,kRealmTitle,kRealmMale];
}
/**
 *  可以为数据模型中需要添加索引的属性建立索引
 *  Realm 支持字符串、整数、布尔值以及 NSDate 属性作为索引。
 *  @return 对属性进行索引可以以极小的插入花费加快比较检索的速度（比如说= 以及 IN 操作符
 */
+(NSArray<NSString *> *)indexedProperties {
    return @[kRealmTitle];
}
/**
 *  在每次对象创建之后为其提供默认值
 */
+(NSDictionary *)defaultPropertyValues {
    return @{};
}
/**
 *  主键
 */
+ (NSString *)primaryKey {
    return kRealmPrimaryKey;
}
- (NSString *)description {
    return [NSString stringWithFormat:@"PrimaryKey = %@,Title = %@,SubTitle = %@,isMale = %@,Age = %@,Height = %@,Weight = %@",self.hiSchoolID,self.title,self.subTitle,self.isMale,self.age,self.height,self.weight];
}
@end
