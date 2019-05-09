//
//  EMGGeocoding.h
//  EMapgoPOI
//
//  Created by 王晓磊 on 2019/4/16.
//  Copyright © 2019 MaRui. All rights reserved.
//

#import "EMGBaseModel.h"
#import "EMGQuery.h"
#import "EMGEngine.h"

NS_ASSUME_NONNULL_BEGIN

@interface EMGGeocoding : EMGBaseModel

//地理编码的版本号。
@property (nonatomic, copy) NSString * version;

//搜索引擎所理解的检索。
@property (nonatomic, strong) EMGQuery * query;

//搜索引擎。
@property (nonatomic, strong) EMGEngine * engine;

//在每次检索发起时生成的时间戳。
@property (nonatomic, copy) NSString * timestamp;

@end

NS_ASSUME_NONNULL_END
