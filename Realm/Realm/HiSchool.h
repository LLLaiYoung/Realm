//
//  HiSchool.h
//  Realm
//
//  Created by chairman on 16/5/13.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import <Realm/Realm.h>

static NSString *const kRealmPrimaryKey = @"hiSchoolID";
static NSString *const kRealmTitle = @"title";
static NSString *const kRealmAvatarData = @"avatar";
static NSString *const kRealmSubtitle = @"subTitle";
static NSString *const kRealmMale = @"isMale";
static NSString *const kRealmHeight = @"height";
static NSString *const kRealmWeight = @"weight";
static NSString *const kRealmDate = @"date";
static NSString *const kRealmAge = @"age";

@interface HiSchool : RLMObject
@property NSString *hiSchoolID;
@property NSData *avatar;
@property NSDate *date;
@property NSString *title;
@property NSString *subTitle;
@property NSNumber<RLMBool> *isMale;
@property NSNumber<RLMInt> *age;
@property NSNumber<RLMFloat> *height;
@property NSNumber<RLMDouble> *weight;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<HiSchool>
RLM_ARRAY_TYPE(HiSchool)
