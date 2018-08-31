//
//  EMapRoadPlanDataManager.h
//  EMapgoPOI
//
//  Created by MaRui on 2018/5/31.
//  Copyright © 2018年 MaRui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMapgoRouteStepModel.h"
#import "EMapgoRouteDetailModel.h"

/*解析路线规划数据使用
 通过EMapRoadPlanning获取路线信息
 创建EMapRoadPlanDataManager *dataM = [[EMapRoadPlanDataManager alloc] initWithRoadData:data]实例;
 dataM.roadDetailArray为每条路线信息
 dataM.roadStepArray为每条路线步骤信息
 */
@interface EMapRoadPlanDataManager : NSObject

//存放路线信息数据
@property (nonatomic, copy, readonly) NSArray<EMapgoRouteDetailModel *> *roadDetailArray;

//存放线路步骤数据 @[@[RoadDetailModel,RoadDetailModel],@[RoadDetailModel,RoadDetailModel]]; roadSetpArray.count 为路线方案数
@property (nonatomic, copy, readonly) NSArray *roadStepArray;

- (instancetype)initWithRoadData:(NSDictionary *)dataDictionary;

@end
