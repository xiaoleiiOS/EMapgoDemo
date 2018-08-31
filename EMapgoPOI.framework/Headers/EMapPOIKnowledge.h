//
//  EMapPOIKnowledge.h
//  EMapgoPOI
//
//  Created by MaRui on 2018/8/3.
//  Copyright © 2018年 MaRui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMapPOIKnowledge : NSObject

typedef void (^EMapPOISuccessBlock)(NSDictionary *data);
typedef void (^EMapPOIFailureBlock)(NSError *error);

///通过poi id得到详情信息, 使用参数pid时, 参数poiname, lon, lat不会被使用
@property (nonatomic, copy) NSString *pid;

///POI名称, 通过POI名称和经纬度得到详情信息
@property (nonatomic, copy) NSString *poiname;

///经度，单位度
@property (nonatomic, copy) NSString *lon;

///纬度，单位度
@property (nonatomic, copy) NSString *lat;

- (void)startPOIKnowledgeWithsuccess:(EMapPOISuccessBlock)successBlock failure:(EMapPOIFailureBlock)failureBlock;
@end
