//
//  RoadDetailModel.h
//  EMapgoPOI
//
//  Created by MaRui on 2018/5/31.
//  Copyright © 2018年 MaRui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMapgoRouteDetailModel : NSObject

@property(nonatomic, copy) NSString *roadtime;//路线总时间（s）

@property(nonatomic, copy) NSString *roadDistance;//路线总距离（m）

-(instancetype)initWithDic:(NSDictionary* )dict;

@end
