//
//  RoadStepModel.h
//  EMapgoPOI
//
//  Created by MaRui on 2018/5/31.
//  Copyright © 2018年 MaRui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface EMapgoRouteStepModel : NSObject

@property(nonatomic, copy) NSString *stepDescription;//路线信息描述

@property(nonatomic, copy) NSString *distance;//当前步骤行驶距离

@property(nonatomic, copy) NSString *lat;//纬度

@property(nonatomic, copy) NSString *lon;//经度

@property(nonatomic, strong) UIImage *dirsectionImage;//行驶方向图片
@property(nonatomic, assign) BOOL isTransform;//是否左方向
@end
